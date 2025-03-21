import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneCallVerification extends StatefulWidget {
  const PhoneCallVerification({super.key});

  @override
  State<PhoneCallVerification> createState() => _PhoneCallVerificationState();
}

class _PhoneCallVerificationState extends State<PhoneCallVerification> {
  late final TextEditingController _phoneController;
  late final TextEditingController _otpController;
  final int _code = 254; // Fixed to Kenya's country code
  String? _verificationId;
  bool _isCodeSent = false;
  bool _isLoading = false;

  @override
  void initState() {
    _phoneController = TextEditingController();
    _otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyPhoneNumber() async {
    setState(() => _isLoading = true);
    final phoneNumber = '+$_code${_phoneController.text.trim()}';

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _showSuccessAndNavigate();
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isCodeSent = true;
          _isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() => _verificationId = verificationId);
      },
    );
  }

  Future<void> _verifyOTP() async {
    setState(() => _isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpController.text.trim(),
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      _showSuccessAndNavigate();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP: $e')),
      );
    }
  }

  void _showSuccessAndNavigate() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Your account has been created successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close success dialog
              Navigator.pushReplacementNamed(context, '/login'); // Navigate to Sign-In page
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isCodeSent) ...[
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+$_code',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyPhoneNumber,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Send OTP',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ] else ...[
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(
                  hintText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOTP,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Verify OTP',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

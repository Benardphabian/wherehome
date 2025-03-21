import 'package:flutter/material.dart';

class PhoneCallVerification extends StatefulWidget {
  final Function(String phoneNumber) onPhoneVerified;

  const PhoneCallVerification({super.key, required this.onPhoneVerified});

  @override
  State<PhoneCallVerification> createState() => _PhoneCallVerificationState();
}

class _PhoneCallVerificationState extends State<PhoneCallVerification> {
  late final TextEditingController _phoneController;
  final int _code = 254; // Fixed to Kenya's country code

  @override
  void initState() {
    _phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
              Navigator.of(context).pop(); // Close the success dialog
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
              onPressed: () {
                final phoneNumber = '$_code${_phoneController.text.trim()}';
                widget.onPhoneVerified(phoneNumber);
                _showSuccessAndNavigate();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

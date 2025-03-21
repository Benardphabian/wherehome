import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'phone_call_verification.dart'; // Import the phone verification screen

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _passwordController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _registerWithFirebase() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _errorMessage = null);

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': _emailController.text,
        'phoneNumber': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneCallVerification(
            onPhoneVerified: (phoneNumber) async {
              await FirebaseFirestore.instance.collection('users').doc(userId).update({'phoneNumber': phoneNumber});
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message ?? 'An error occurred during registration.');
    } catch (e) {
      setState(() => _errorMessage = 'An unexpected error occurred.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'RenTIFY',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontSize: 36,
                          ),
                        ),
                        const SizedBox(height: 24),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Email is required';
                            if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+").hasMatch(value)) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Password is required';
                            if (value.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                            ),
                          ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _registerWithFirebase,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Colors.blueAccent,
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          child: const Text('Already have an account? Login'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
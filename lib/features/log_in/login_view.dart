import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wherehome/common/providers/user_provider.dart';
import 'package:wherehome/common/widgets/dialog_error.dart';
import 'package:wherehome/common/widgets/localized_textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _identifierController; // Handles both phone & email
  late final TextEditingController _passwordController;
  final int _code = 254; // Kenya country code

  @override
  void initState() {
    _identifierController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// **Determine whether the input is an email or a phone number**
  String _formatLoginIdentifier(String input) {
    if (input.contains("@")) {
      return input; // If it's an email, return as is
    } else {
      return '$_code$input@yourapp.com'; // If it's a phone number, convert it to an email format
    }
  }

  Future<void> _loginUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String identifier = _formatLoginIdentifier(_identifierController.text.trim());
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: identifier,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        userProvider.setUser(user);
        Navigator.pushNamed(context, '/home'); // Navigate to home screen
      }
    } catch (e) {
      showErrorDialog(context, "Login failed: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: Image.asset('assets/images/login_image.png', fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Enter your login credentials',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  LocalizedTextField(
                    key: const Key('identifierTextField'),
                    _identifierController,
                    'Enter phone number or email',
                    30,
                    TextInputType.emailAddress,
                    false,
                    (value) => null,
                  ),
                  const SizedBox(height: 10),
                  LocalizedTextField(
                    key: const Key('passwordTextField'),
                    _passwordController,
                    'Enter your password',
                    16,
                    TextInputType.visiblePassword,
                    true,
                    (value) => null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loginUser,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.maxFinite, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "OR",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      "Create an account",
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

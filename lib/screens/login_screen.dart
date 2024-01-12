import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 240, 235, 235),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 240, 235, 235),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  loginUser(context);
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

// login
  Future<void> loginUser(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      // Save authentication state
      await saveUserAuthenticationState();
      widget.onLoginSuccess();

      print('User logged in: ${userCredential.user!.email}');
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Credentials'),
          content: const Text('Please check your username and password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      print('Error: ${e.message}');
    }
  }

  Future<void> saveUserAuthenticationState() async {
    final LocalStorage storage = LocalStorage('my_app');

    // Save authentication state
    await storage.setItem('isLoggedIn', true);
  }
}

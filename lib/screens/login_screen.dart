import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final fontColor = Colors.orange[600];
  final heplerTextColor = const Color.fromARGB(221, 225, 227, 228);
  bool isLoading = false;
  bool isLargeScreen = true;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 400,
                height: 350,
                margin: const EdgeInsets.only(top: 150.0),
                color: const Color.fromARGB(41, 83, 83, 83),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 250,
                            height: 40,
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    color: fontColor, letterSpacing: 1.2),
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(82, 243, 123, 123),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .orange), // Set the focused border color
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 250,
                            height: 40,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    color: fontColor, letterSpacing: 1.2),
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(82, 243, 123, 123),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .orange), // Set the focused border color
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(82, 243, 123, 123)),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true; // Set loading state to true
                                });
                                await loginUser(context);
                                setState(() {
                                  isLoading = false; // Reset loading state
                                });
                              },
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22, // Adjust width as needed
                                      height: 22, // Adjust height as needed
                                      child: CircularProgressIndicator(
                                        color: Colors.orange,
                                        strokeWidth: 2.0,
                                      ),
                                    )
                                  : Text('Login',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: fontColor,
                                        letterSpacing: 1,
                                      )),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Contact info: - info@app-build.click',
                            style: TextStyle(
                                color: heplerTextColor,
                                letterSpacing: 0.5,
                                fontSize: 15),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Generate applications within 10 seconds',
                              style: TextStyle(
                                  color: heplerTextColor,
                                  letterSpacing: 0.8,
                                  fontSize: screenSize.width > 600 ? 17 : 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
    final LocalStorage storage = LocalStorage('my_app');
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      // Save authentication state
      await saveUserAuthenticationState(token: userCredential.user!.refreshToken);
      widget.onLoginSuccess();

      print('User logged in: ${userCredential.user!.email}');
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      if (e.code == 'user-disabled') {
      // User account is disabled
      await FirebaseAuth.instance.signOut();
      await storage.setItem('isLoggedIn', false);
   
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Account Disabled'),
          content: const Text('Your account has been disabled. Please contact support.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }else{
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
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
      print('Error: ${e.message}');
    }
  }

  Future<void> saveUserAuthenticationState({String? token}) async {
    final LocalStorage storage = LocalStorage('my_app');
  
    // Save authentication state
    await storage.setItem('isLoggedIn', true);
    await storage.setItem('token', token);
  }
}

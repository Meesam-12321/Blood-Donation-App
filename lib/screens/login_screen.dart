import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package
import 'package:donorfusion/services/auth_service.dart';
import 'main_menu_screen.dart'; // Import MainMenuScreen
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:donorfusion/services/theme_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
            fontFamily: 'Raleway',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Switch(
            value: themeProvider.themeMode == ThemeMode.light,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            activeColor: Colors.white,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeProvider.themeMode == ThemeMode.light
                ? [Colors.white, Colors.grey.shade200]
                : [Colors.black, Colors.blueGrey.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Donorfusion',
                      style: GoogleFonts.pacifico(
                        color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      width: 300, // Adjust the width of the input fields
                      child: CustomTextField(
                        label: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress, // Ensure this is provided
                        style: TextStyle(
                          color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                        ), // Set text color to match theme
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 300, // Adjust the width of the input fields
                      child: CustomTextField(
                        label: 'Password',
                        controller: _passwordController,
                        keyboardType: TextInputType.text, // Ensure this is provided
                        obscureText: true,
                        style: TextStyle(
                          color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                        ), // Set text color to match theme
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 40.0),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    CustomButton(
                      text: 'Login',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            User? user = await _auth.signInWithEmailAndPassword(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (user != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MainMenuScreen()),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              if (e.code == 'user-not-found') {
                                _errorMessage = 'No user found for that email.';
                              } else if (e.code == 'wrong-password') {
                                _errorMessage = 'Wrong password provided.';
                              } else {
                                _errorMessage = 'An error occurred. Please try again.';
                              }
                            });
                          } catch (e) {
                            setState(() {
                              _errorMessage = 'An error occurred. Please try again.';
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:donorfusion/services/auth_service.dart';
import 'package:donorfusion/services/firestore_service.dart';
import 'main_menu_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:donorfusion/services/theme_provider.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController(); // New field for name
  final _bloodTypeController = TextEditingController(); // New field for blood type
  final _locationController = TextEditingController(); // New field for location
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _bloodTypeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
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
            activeColor: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
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
                      width: 300,
                      child: CustomTextField(
                        label: 'Name',
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 300,
                      child: CustomTextField(
                        label: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white),
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
                      width: 300,
                      child: CustomTextField(
                        label: 'Password',
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style: TextStyle(color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white),
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
                    SizedBox(height: 20.0),
                    Container(
                      width: 300,
                      child: CustomTextField(
                        label: 'Confirm Password',
                        controller: _confirmPasswordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style: TextStyle(color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 300,
                      child: CustomTextField(
                        label: 'Blood Type',
                        controller: _bloodTypeController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your blood type';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 300,
                      child: CustomTextField(
                        label: 'Location',
                        controller: _locationController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your location';
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
                      text: 'Register',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            User? user = await _auth.createUserWithEmailAndPassword(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (user != null) {
                              await _firestore.createUserProfile(user, {
                                'name': _nameController.text,
                                'email': _emailController.text,
                                'bloodType': _bloodTypeController.text, // Store blood type
                                'location': _locationController.text, // Store location
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MainMenuScreen()),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              _errorMessage = e.message ?? 'An error occurred. Please try again.';
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

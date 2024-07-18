import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:donorfusion/services/theme_provider.dart';

class RequestBloodScreen extends StatefulWidget {
  @override
  _RequestBloodScreenState createState() => _RequestBloodScreenState();
}

class _RequestBloodScreenState extends State<RequestBloodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bloodTypeController = TextEditingController();
  final _locationController = TextEditingController();
  final _hospitalInfoController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _message = '';

  @override
  void dispose() {
    _bloodTypeController.dispose();
    _locationController.dispose();
    _hospitalInfoController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('blood_requests').add({
          'requesterId': user.uid,
          'requesterName': user.displayName ?? 'Anonymous',
          'bloodType': _bloodTypeController.text,
          'location': _locationController.text,
          'hospitalInfo': _hospitalInfoController.text,
          'timestamp': Timestamp.now(),
        });

        setState(() {
          _message = 'Requesting blood with type ${_bloodTypeController.text} in ${_locationController.text}';
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Request Submitted'),
              content: Text('Your blood request has been submitted successfully.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Blood',
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Request Blood',
                      style: GoogleFonts.pacifico(
                        color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                    SizedBox(height: 20.0),
                    Container(
                      width: 300, // Adjust the width of the input fields
                      child: CustomTextField(
                        label: 'Blood Type',
                        controller: _bloodTypeController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a blood type';
                          }
                          return null;
                        },
                        style: TextStyle(color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 300, // Adjust the width of the input fields
                      child: CustomTextField(
                        label: 'Location',
                        controller: _locationController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a location';
                          }
                          return null;
                        },
                        style: TextStyle(color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 300, // Adjust the width of the input fields
                      child: CustomTextField(
                        label: 'Hospital Information',
                        controller: _hospitalInfoController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the hospital information';
                          }
                          return null;
                        },
                        style: TextStyle(color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      width: 200, // Adjust the width of the button
                      child: ElevatedButton(
                        onPressed: _submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          shadowColor: Colors.redAccent,
                          elevation: 8.0,
                        ),
                        child: Text(
                          'Submit Request',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
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

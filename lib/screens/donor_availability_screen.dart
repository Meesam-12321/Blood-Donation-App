import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import the Flutter Animate package
import '../widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donorfusion/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:donorfusion/services/theme_provider.dart';

class DonorAvailabilityScreen extends StatefulWidget {
  @override
  _DonorAvailabilityScreenState createState() => _DonorAvailabilityScreenState();
}

class _DonorAvailabilityScreenState extends State<DonorAvailabilityScreen> {
  bool _isAvailable = false;
  final FirestoreService _firestore = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadAvailability();
  }

  Future<void> _loadAvailability() async {
    User? user = _auth.currentUser;
    if (user != null) {
      bool availability = await _firestore.getDonorAvailability(user.uid);
      setState(() {
        _isAvailable = availability;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donor Availability',
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Your Donation Status',
                    style: GoogleFonts.pacifico(
                      color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                  SizedBox(height: 20.0),
                  Text(
                    'Keep your status updated to help save lives.',
                    style: TextStyle(
                      color: themeProvider.themeMode == ThemeMode.light ? Colors.black54 : Colors.white70,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                  SizedBox(height: 40.0),
                  SwitchListTile(
                    title: Text(
                      'Available for Donation',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                      ),
                    ),
                    value: _isAvailable,
                    onChanged: (bool value) async {
                      setState(() {
                        _isAvailable = value;
                      });
                      // Update availability status in Firestore
                      User? user = _auth.currentUser;
                      if (user != null) {
                        await _firestore.updateDonorAvailability(user.uid, _isAvailable);
                      }
                    },
                    activeColor: Colors.redAccent,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.white24,
                  ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                  SizedBox(height: 40.0),
                  Container(
                    width: 200, // Adjust the width of the button
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle the save action, possibly saving the state to backend
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(_isAvailable ? 'You are now available for donation' : 'You are now unavailable for donation')),
                        );
                      },
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
                        'Save',
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
    );
  }
}

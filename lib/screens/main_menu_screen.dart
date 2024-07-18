import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'blood_search_screen.dart';
import 'request_blood_screen.dart';
import 'donor_availability_screen.dart';
import 'communication_screen.dart';
import 'package:donorfusion/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:donorfusion/services/theme_provider.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final FirestoreService _firestore = FirestoreService();
  User? user = FirebaseAuth.instance.currentUser;
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userProfile = await _firestore.getUserProfile(user!.uid);
        if (userProfile.exists) {
          setState(() {
            userName = userProfile['name'] ?? 'User';
          });
        } else {
          print('User profile does not exist');
        }
      } catch (e) {
        print('Error fetching user profile: $e');
      }
    } else {
      print('No user is currently logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Main Menu',
          style: TextStyle(color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white, fontFamily: 'Raleway'),
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
                    'Welcome, $userName',
                    style: GoogleFonts.pacifico(
                      color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                  SizedBox(height: 20.0),
                  Text(
                    'What would you like to do today?',
                    style: TextStyle(
                      color: themeProvider.themeMode == ThemeMode.light ? Colors.black54 : Colors.white70,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                  SizedBox(height: 40.0),
                  MenuButton(
                    text: 'Search for Blood Donors',
                    icon: Icons.search,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BloodSearchScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 20.0),
                  MenuButton(
                    text: 'Request Blood',
                    icon: Icons.bloodtype,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RequestBloodScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 20.0),
                  MenuButton(
                    text: 'Donor Availability',
                    icon: Icons.volunteer_activism,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DonorAvailabilityScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 20.0),
                  MenuButton(
                    text: 'Communication',
                    icon: Icons.message,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CommunicationScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 40.0),
                  Text(
                    'Together, we can save lives.',
                    style: TextStyle(
                      color: themeProvider.themeMode == ThemeMode.light ? Colors.black54 : Colors.white70,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  MenuButton({required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        shadowColor: Colors.redAccent,
        elevation: 8.0,
      ),
    ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms);
  }
}

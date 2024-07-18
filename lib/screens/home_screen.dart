import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import the Flutter Animate package
import 'package:provider/provider.dart';
import 'package:donorfusion/services/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to Donorfusion',
                  style: GoogleFonts.pacifico(
                    color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                SizedBox(height: 20.0),
                Text(
                  'A place where you can make a difference by donating blood.',
                  style: TextStyle(
                    color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                    fontSize: 20.0,
                  ),
                ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                SizedBox(height: 20.0),
                Text(
                  'Your blood donation can save lives. Be a hero today!',
                  style: TextStyle(
                    color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                    fontSize: 16.0,
                  ),
                ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                SizedBox(height: 40.0),
                Text(
                  'Join us in making the world a better place.',
                  style: TextStyle(
                    color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                    fontSize: 16.0,
                  ),
                ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

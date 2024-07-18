import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'services/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyBS0WDAF4SYy-k3kKEqjdAEGpzJJSM9bWw",
          authDomain: "perfect-lantern-424020-b9.firebaseapp.com",
          projectId: "perfect-lantern-424020-b9",
          storageBucket: "perfect-lantern-424020-b9.appspot.com",
          messagingSenderId: "894296873859",
          appId: "1:894296873859:web:c07226c8d6905c111874b6",
          measurementId: "G-C6E0RG733L",
        ),
      );
      print('Firebase initialized for Web');
    } else {
      await Firebase.initializeApp();
      print('Firebase initialized for Android');
    }
    runApp(DonorfusionApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class DonorfusionApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Donorfusion',
            theme: ThemeData(
              primarySwatch: Colors.red,
              textTheme: GoogleFonts.ralewayTextTheme(
                Theme.of(context).textTheme,
              ).copyWith(
                headline1: GoogleFonts.pacifico(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                headline6: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.redAccent,
                ),
                bodyText2: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Raleway',
                  fontSize: 20.0,
                ),
              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.red,
              textTheme: GoogleFonts.ralewayTextTheme(
                Theme.of(context).textTheme,
              ).copyWith(
                headline1: GoogleFonts.pacifico(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                headline6: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.redAccent,
                ),
                bodyText2: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Raleway',
                  fontSize: 20.0,
                ),
              ),
            ),
            themeMode: themeProvider.themeMode,
            home: HomeScreen(),
            routes: {
              '/login': (context) => LoginScreen(),
              '/signup': (context) => RegistrationScreen(),
            },
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
          );
        },
      ),
    );
  }
}

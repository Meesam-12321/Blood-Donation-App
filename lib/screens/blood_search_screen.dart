import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorfusion/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:donorfusion/services/theme_provider.dart';

class BloodSearchScreen extends StatefulWidget {
  @override
  _BloodSearchScreenState createState() => _BloodSearchScreenState();
}

class _BloodSearchScreenState extends State<BloodSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bloodTypeController = TextEditingController();
  final _locationController = TextEditingController();
  final FirestoreService _firestore = FirestoreService();
  List<QueryDocumentSnapshot> _searchResults = [];
  bool _noResultsFound = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _bloodTypeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _searchBloodDonors() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _noResultsFound = false;
        _searchResults = [];
      });

      try {
        QuerySnapshot results = await _firestore.searchUsersByBloodTypeAndLocation(
          _bloodTypeController.text,
          _locationController.text,
        );

        setState(() {
          _searchResults = results.docs;
          _noResultsFound = _searchResults.isEmpty;
        });
      } catch (e) {
        print('Error searching for donors: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search for Blood Donors',
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
                      'Find a Blood Donor',
                      style: GoogleFonts.pacifico(
                        color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                    SizedBox(height: 20.0),
                    Text(
                      'Enter the blood type and location to find matching donors.',
                      style: TextStyle(
                        color: themeProvider.themeMode == ThemeMode.light ? Colors.black54 : Colors.white70,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                    SizedBox(height: 40.0),
                    Container(
                      width: 300,
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
                      width: 300,
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
                    SizedBox(height: 40.0),
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _searchBloodDonors,
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
                          'Search',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                    ),
                    SizedBox(height: 40.0),
                    if (_isLoading)
                      CircularProgressIndicator(
                        color: Colors.redAccent,
                      ),
                    if (_noResultsFound)
                      Text(
                        'No users found with the specified blood type and location.',
                        style: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                      ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms),
                    if (_searchResults.isNotEmpty)
                      ..._searchResults.map((doc) {
                        return ListTile(
                          title: Text(
                            doc['name'],
                            style: TextStyle(color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white),
                          ),
                          subtitle: Text(
                            'Blood Type: ${doc['bloodType']}, Location: ${doc['location']}',
                            style: TextStyle(color: themeProvider.themeMode == ThemeMode.light ? Colors.black54 : Colors.white70),
                          ),
                        ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms);
                      }).toList(),
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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:donorfusion/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:donorfusion/services/theme_provider.dart';

class CommunicationScreen extends StatefulWidget {
  final String? requesterId;
  final String? requesterName;

  CommunicationScreen({this.requesterId, this.requesterName});

  @override
  _CommunicationScreenState createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  final FirestoreService _firestore = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _message = '';
  List<Map<String, String>> _localMessages = [];

  String? _userBloodType;
  String? _userLocation;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userProfile = await _firestore.getUserProfile(user.uid);
      final userData = userProfile.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
      setState(() {
        _userBloodType = userData?['bloodType'];
        _userLocation = userData?['location'];
        _userName = userData?['name'];
      });
    }
  }

  void _handleAccept(String notificationId) async {
    await _firestore.acceptBloodRequest(notificationId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have accepted the request.')),
    );
  }

  void _handleReject(String notificationId) async {
    await _firestore.rejectBloodRequest(notificationId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have rejected the request.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
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
        child: Column(
          children: [
            if (_userBloodType != null && _userLocation != null)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.getBloodRequests(_userBloodType!, _userLocation!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: Colors.redAccent));
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No notifications found.'));
                    }

                    final notifications = snapshot.data!.docs;

                    return ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot notification = notifications[index];
                        Map<String, dynamic> data = notification.data() as Map<String, dynamic>; // Cast to Map
                        String hospitalInfo = data.containsKey('hospitalInfo') ? data['hospitalInfo'] : 'N/A'; // Safe access
                        String notificationId = notification.id;

                        return Card(
                          color: themeProvider.themeMode == ThemeMode.light ? Colors.white70 : Colors.white24,
                          child: ListTile(
                            title: Text(
                              'Request from $hospitalInfo',
                              style: TextStyle(
                                  color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white),
                            ),
                            subtitle: Text(
                              'Hospital: $hospitalInfo',
                              style: TextStyle(
                                  color: themeProvider.themeMode == ThemeMode.light ? Colors.black54 : Colors.white70),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.check, color: Colors.green),
                                  onPressed: () => _handleAccept(notificationId),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _handleReject(notificationId),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms);
                      },
                    );
                  },
                ),
              ),
            if (user != null)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.getNotifications(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: Colors.redAccent));
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No notifications found.'));
                    }

                    final messages = snapshot.data!.docs;

                    return ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot messageDoc = messages[index];
                        String message = messageDoc['message'];
                        Map<String, dynamic> data = messageDoc.data() as Map<String, dynamic>; // Cast to Map
                        String hospitalInfo = data.containsKey('hospitalInfo') ? data['hospitalInfo'] : 'N/A'; // Safe access

                        return Card(
                          color: themeProvider.themeMode == ThemeMode.light ? Colors.white70 : Colors.white24,
                          child: ListTile(
                            title: Text(
                              message,
                              style: TextStyle(
                                  color: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white),
                            ),
                            subtitle: Text(
                              'Hospital: $hospitalInfo',
                              style: TextStyle(
                                  color: themeProvider.themeMode == ThemeMode.light ? Colors.black54 : Colors.white70),
                            ),
                          ),
                        ).animate().fadeIn(duration: 1000.ms).then().slide(duration: 500.ms);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile(User user, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(data);
      print('User profile created: $data');
    } catch (e) {
      print('Error creating user profile: $e');
    }
  }
  Future<DocumentSnapshot> getUserProfile(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }


  Future<QuerySnapshot> searchUsersByBloodTypeAndLocation(String bloodType, String location) async {
    try {
      return await _firestore.collection('users')
          .where('bloodType', isEqualTo: bloodType)
          .where('location', isEqualTo: location)
          .where('isAvailable', isEqualTo: true)
          .get();
    } catch (e) {
      print('Error searching users: $e');
      rethrow;
    }
  }

  Future<void> sendBloodRequest(String bloodType, String location, String hospitalInfo) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userProfile = await getUserProfile(user.uid);
        final userData = userProfile.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
        final requesterName = userData?['name'] ?? 'Anonymous'; // Ensure name is fetched

        // Print requester name to console
        print('Requester Name: $requesterName');

        Map<String, dynamic> requestData = {
          'requesterId': user.uid,
          'requesterName': requesterName, // Store requester's name
          'bloodType': bloodType,
          'location': location,
          'hospitalInfo': hospitalInfo,
          'timestamp': Timestamp.now(),
        };

        // Print request data to console
        print('Request Data: $requestData');

        await _firestore.collection('blood_requests').add(requestData);
        print('Blood request sent: $requestData');
      } catch (e) {
        print('Error sending blood request: $e');
      }
    } else {
      print('User not logged in');
    }
  }



  Future<void> acceptBloodRequest(String requestId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userProfile = await getUserProfile(user.uid);
        final acceptorName = userProfile['name'] ?? 'Anonymous';

        final requestDoc = await _firestore.collection('blood_requests').doc(requestId).get();
        if (requestDoc.exists) {
          final requesterId = requestDoc['requesterId'];
          final requesterName = requestDoc['requesterName'];
          final hospitalInfo = requestDoc['hospitalInfo'];

          await sendNotificationToRequester(requesterId, '$acceptorName has accepted your request to donate blood.', hospitalInfo);
          await _firestore.collection('blood_requests').doc(requestId).delete(); // Remove the request once accepted
          print('Blood request accepted: $requestId');
        }
      } catch (e) {
        print('Error accepting blood request: $e');
      }
    } else {
      print('User not logged in');
    }
  }

  Future<void> rejectBloodRequest(String requestId) async {
    try {
      await _firestore.collection('blood_requests').doc(requestId).delete();
      print('Blood request rejected: $requestId');
    } catch (e) {
      print('Error rejecting blood request: $e');
    }
  }

  Stream<QuerySnapshot> getBloodRequests(String bloodType, String location) {
    return _firestore
        .collection('blood_requests')
        .where('bloodType', isEqualTo: bloodType)
        .where('location', isEqualTo: location)
        .snapshots();
  }

  Future<void> updateDonorAvailability(String uid, bool isAvailable) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isAvailable': isAvailable,
      });
      print('Donor availability updated: $uid isAvailable: $isAvailable');
    } catch (e) {
      print('Error updating donor availability: $e');
    }
  }

  Future<bool> getDonorAvailability(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        print('Donor availability fetched: ${doc['isAvailable']}');
        return doc['isAvailable'] ?? false;
      }
    } catch (e) {
      print('Error fetching donor availability: $e');
    }
    return false;
  }

  Future<void> sendNotificationToRequester(String requesterId, String message, String hospitalInfo) async {
    try {
      await _firestore.collection('users').doc(requesterId).collection('messages').add({
        'message': message,
        'hospitalInfo': hospitalInfo,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'unread',
      });
      print('Notification sent to requester: $requesterId, message: $message');
    } catch (e) {
      print('Error sending notification to requester: $e');
    }
  }

  Stream<QuerySnapshot> getNotifications(String uid) {
    return _firestore.collection('users').doc(uid).collection('messages').snapshots();
  }
}

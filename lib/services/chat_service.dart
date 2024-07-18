import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final String chatRoomId;
  ChatService({required this.chatRoomId});

  final CollectionReference chatCollection = FirebaseFirestore.instance.collection('chats');

  // Send a message
  Future<void> sendMessage(String message, String senderId) async {
    return await chatCollection.doc(chatRoomId).collection('messages').add({
      'message': message,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get chat messages
  Stream<QuerySnapshot> getMessages() {
    return chatCollection.doc(chatRoomId).collection('messages').orderBy('timestamp').snapshots();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  Future<void> addMessageToFirebase(String userId, String receiverId, String message) async {
    if (message.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection(userId)
          .doc(receiverId)
          .collection('messages')
          .add({
        'message': message,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
        // Add timestamp to sort messages
      });

      await FirebaseFirestore.instance
          .collection(receiverId)
          .doc(userId)
          .collection('messages')
          .add({
        'message': message,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
        // Add timestamp to sort messages
      });
      print("Message added to receiver==========> : $message");
    }
  }

  // Fetch messages as a stream for real-time updates
  Stream<QuerySnapshot> getMessagesStream(String userId, String receiverId) {
    return FirebaseFirestore.instance
        .collection(userId)
        .doc(receiverId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTestService {
  static Future<void> testConnection() async {
    await FirebaseFirestore.instance
        .collection('test')
        .doc('connection')
        .set({
      'status': 'connected',
      'timestamp': DateTime.now().toString(),
    });

    print('Firestore Connected Successfully');
  }
}
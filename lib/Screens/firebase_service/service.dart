import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> updateFirestore(String name) async {
    await _firestore.collection('User').doc(auth.currentUser!.uid).set({
      'name': name,
    }, SetOptions(merge: true));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/base.dart';

Future<Base> fetchUserBase(String userId) async {
  try {
    final doc =
        await FirebaseFirestore.instance.collection('bases').doc(userId).get();

    if (doc.exists) {
      return Base.fromFirestore(doc); // Pass DocumentSnapshot to fromFirestore
    } else {
      throw Exception('Base not found for userId: $userId');
    }
  } catch (e) {
    throw Exception('Error fetching user base: $e');
  }
}

Future<void> saveUserBase(Base base) async {
  try {
    await FirebaseFirestore.instance
        .collection('bases')
        .doc(base.userId)
        .set(base.toFirestore()); // Convert Base to Firestore document
  } catch (e) {
    throw Exception('Error saving user base: $e');
  }
}

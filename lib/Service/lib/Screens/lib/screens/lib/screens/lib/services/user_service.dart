import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user profile after first OTP login
  Future<void> createUserProfile({
    required String name,
    required int age,
    required String gender,
    required String county,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'phone': _auth.currentUser?.phoneNumber,
      'name': name,
      'age': age,
      'gender': gender,
      'county': county,
      'photos': [],
      'createdAt': FieldValue.serverTimestamp(),
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  // Get potential matches - opposite gender, same county first
  Stream<List<Map<String, dynamic>>> getPotentialMatches() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _db
        .collection('users')
        .where('uid', isNotEqualTo: uid)
        .limit(20)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.data()).toList());
  }

  // Record a like
  Future<void> likeUser(String likedUserId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('likes').add({
      'from': uid,
      'to': likedUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Check if it's a match
    final match = await _db
        .collection('likes')
        .where('from', isEqualTo: likedUserId)

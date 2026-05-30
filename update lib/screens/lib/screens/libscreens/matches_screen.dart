import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'chat_screen.dart';

class MatchesScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Scaffold(body: Center(child: Text('Login first')));

    return Scaffold(
      appBar: AppBar(title: Text('Matches')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('matches').where('users', arrayContains: uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Color(0xFFB71C1C)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No matches yet. Keep swiping!',
                style: TextStyle(color: Colors.grey[400], fontSize: 16)),
            );
          }

          final matches = snapshot.data!.docs;
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              final users = List<String>.from(match['users']);
              final otherUserId = users.firstWhere((id) => id!= uid);

              return FutureBuilder<DocumentSnapshot>(
                future: _db.collection('users').doc(otherUserId).get(),
                builder: (context, userSnap) {
                  if (!userSnap.hasData) return ListTile(title: Text('Loading...'));
                  final userData = userSnap.data!.data() as Map<String, dynamic>;
                  final photo = userData['photos']!= null && userData['photos'].isNotEmpty
                    ? userData

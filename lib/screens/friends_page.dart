import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synergy/screens/view_user_profile_page.dart';

class FriendsPage extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final friendsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.email)
        .collection('friends')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Friends'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: friendsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching friends'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final friendEmail =
              (documents[index].data() as Map<String, dynamic>)['email']
              as String?;

              return ListTile(
                title: Text(friendEmail ?? ''),
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text(
                    friendEmail?.isNotEmpty == true ? friendEmail![0].toUpperCase() : '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewUserProfilePage(friendEmail!),
                      ),
                    );
                  },
                  icon: Icon(Icons.visibility),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

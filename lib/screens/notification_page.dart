import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synergy/Helpers/logger.dart';

class NotificationPage extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;

  void acceptRequest(Map<String, dynamic> request) {
    final docId = '${request['senderEmail']}-${request['recipientEmail']}';

      // Add request to sender's friends collection
      FirebaseFirestore.instance
          .collection('users')
          .doc(request['senderEmail'])
          .collection('friends')
          .doc(currentUser?.email!)
          .set({
        'email': currentUser?.email,
      });

      // Add request to recipient's friends collection
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.email!)
          .collection('friends')
          .doc(request['senderEmail'])
          .set({
        'email': request['senderEmail'],
      });

    // Remove request from requests collection
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.email!)
        .collection('requests')
        .doc(docId)
        .delete()
        .then((_) {
      LoggerUtil.log().d("Request deleted successfully");
    });

  }

  void deleteRequest(Map<String, dynamic> request) {
    final docId = '${request['senderEmail']}-${request['recipientEmail']}';
    // Remove request from requests collection
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.email!)
        .collection('requests')
        .doc(docId)
        .delete()
        .then((_) {
      print("Request deleted successfully");
    })
        .catchError((error) {
      print("Error deleting request: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    final requestStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.email!)
        .collection('requests')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: requestStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching notifications'),
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
              final Map<String, dynamic> request =
              documents[index].data() as Map<String, dynamic>;

              return ListTile(
                title: const Text('Friend Request'),
                subtitle:
                Text('${request['senderEmail']} wants to be your friend.'),
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text(
                    request['senderEmail']![0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        acceptRequest(request);
                      },
                      color: Colors.green,
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    MaterialButton(
                      onPressed: () {
                        deleteRequest(request);
                      },
                      color: Colors.red,
                      child: const Text(
                        'Ignore',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

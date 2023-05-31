import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synergy/widgets/my_post_widget.dart';

import '../Helpers/helper.dart';
import 'comment_widget.dart';

class CommentSection extends StatelessWidget {
  final String postId;
  TextEditingController commentController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  CommentSection({super.key, required this.postId});

  void onUploadPressed() {
    if (commentController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .collection("Comments")
          .add({
        'UserEmail': currentUser.email,
        'Message': commentController.text,
        'Timestamp': Timestamp.now(),
      });
      commentController.clear();
    } else {
      Helper.showToast("Post is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Comments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(postId)
                  .collection("Comments")
                  .orderBy('Timestamp',
                      descending:
                          true) // 'Comments' is a sub collection within the post document
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final comments = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final commentSnapshot = comments[index];
                      final comment = {
                        'UserEmail': commentSnapshot['UserEmail'],
                        'Message': commentSnapshot['Message'],
                        'Timestamp': Helper.formatTimestamp(
                            commentSnapshot['Timestamp']),
                      };
                      return Column(
                        children: [
                          CommentItem(
                            comment: comment,
                            postID: postId,
                            commentId: commentSnapshot.id,
                          ),
                          const Divider()
                        ],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error.toString()}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          PostWidget(
              onUploadPressed: onUploadPressed, controller: commentController),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

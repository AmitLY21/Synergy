import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synergy/widgets/my_messenger_widget.dart';
import '../../Helpers/helper.dart';
import '../../models/FirestoreServiceModel.dart';
import 'comment_widget.dart';

class CommentSection extends StatelessWidget {
  final String postId;
  TextEditingController commentController = TextEditingController();
  final FirestoreServiceModel firestoreServiceModel = FirestoreServiceModel();

  CommentSection({Key? key, required this.postId});

  void onUploadPressed() {
    final message = commentController.text;
    try {
      firestoreServiceModel.addComment(postId, message);
      commentController.clear();
    } catch (e) {
      Helper.showToast(e.toString());
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
              stream: firestoreServiceModel.getComments(postId),
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
            onUploadPressed: onUploadPressed,
            controller: commentController,
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

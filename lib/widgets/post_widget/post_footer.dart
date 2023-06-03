import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/FirestoreServiceModel.dart';
import '../comment_widget/my_comment_button.dart';
import '../buttons_widgets/my_like_button.dart';

class PostFooter extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onTapLike;
  final String postID;
  final List<String> likes;
  final String issueType;
  final VoidCallback onTapComment;

  const PostFooter({
    Key? key,
    required this.isLiked,
    required this.onTapLike,
    required this.postID,
    required this.likes,
    required this.issueType,
    required this.onTapComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreServiceModel firestoreServiceModel = FirestoreServiceModel();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            LikeButton(
              isLiked: isLiked,
              onTap: onTapLike,
              likes: likes,
            ),
            const SizedBox(width: 6),
            StreamBuilder<QuerySnapshot>(
              stream: firestoreServiceModel.getComments(postID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final commentDocs = snapshot.data!.docs;
                  final numOfComments = commentDocs.length;

                  return CommentButton(
                    onTap: onTapComment,
                    numOfComments: numOfComments,
                  );
                } else {
                  return CommentButton(
                    onTap: onTapComment,
                    numOfComments: 0,
                  );
                }
              },
            ),
          ],
        ),
        Chip(
          label: Text(issueType),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }
}

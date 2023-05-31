import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:synergy/constants/app_constants.dart';
import 'package:synergy/widgets/report_section.dart';

import '../Helpers/logger.dart';
import '../screens/view_user_profile_page.dart';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;
  final String postID;
  final String commentId;
  List<SlidableAction> slidableActions = [];

  CommentItem(
      {required this.comment, required this.postID, required this.commentId});

  final currentUser = FirebaseAuth.instance.currentUser!;

  void deleteComment() {
    DocumentReference commentRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('Comments')
        .doc(commentId);
    commentRef
        .delete()
        .then((res) =>
            LoggerUtil.log().d("The post: $commentRef deleted successfully!"))
        .catchError((error) =>
            LoggerUtil.log().d('Delete for post $commentRef failed: $error'));
  }

  void reportComment(BuildContext context, String reportId){
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ReportSection(
          reportType: AppConstants.commentReportType,
          reportId: reportId,
        );
      },
    );
  }

  List<SlidableAction> buildSlidableActions(bool isCurrentUserComment) {
    final slidableActions = <SlidableAction>[];

    if (isCurrentUserComment) {
      slidableActions.add(
        SlidableAction(
          onPressed: (context) {
            deleteComment();
          },
          backgroundColor: Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      );
    } else {
      slidableActions.addAll([
        SlidableAction(
          onPressed: (context) {
            reportComment(context,commentId);
          },
          backgroundColor: Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.report,
          label: 'Report',
        ),
        SlidableAction(
          onPressed: (context) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ViewUserProfilePage(comment['UserEmail'])));
          },
          backgroundColor: Color(0xFF50C878),
          foregroundColor: Colors.white,
          icon: Icons.person,
          label: 'View',
        ),
      ]);
    }

    return slidableActions;
  }


  @override
  Widget build(BuildContext context) {
    bool isCurrentUserComment = currentUser.email == comment['UserEmail'];
    slidableActions = buildSlidableActions(isCurrentUserComment);
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: slidableActions
      ),
      child: ListTile(
        title: Text(comment['UserEmail']),
        subtitle: Text(comment['Message']),
        trailing: Text(
          comment['Timestamp'],
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

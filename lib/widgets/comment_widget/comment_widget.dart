import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../constants/app_constants.dart';
import '../../models/FirestoreServiceModel.dart';
import '../../screens/view_user_profile_page.dart';
import '../report_section.dart';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;
  final String postID;
  final String commentId;
  final FirestoreServiceModel firestoreServiceModel = FirestoreServiceModel();

  CommentItem({super.key,
    required this.comment,
    required this.postID,
    required this.commentId,
  });

  void deleteComment() {
    firestoreServiceModel.deleteComment(postID, commentId);
  }

  void reportComment(BuildContext context, String reportId) {
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

  void viewUserProfile(BuildContext context) {
    final userEmail = comment['UserEmail'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewUserProfilePage(userEmail),
      ),
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
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      );
    } else {
      slidableActions.addAll([
        SlidableAction(
          onPressed: (context) {
            reportComment(context, commentId);
          },
          backgroundColor: Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.report,
          label: 'Report',
        ),
        SlidableAction(
          onPressed: (context) {
            viewUserProfile(context);
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
    final currentUserEmail = firestoreServiceModel.currentUser.email!;
    final isCurrentUserComment = currentUserEmail == comment['UserEmail'];
    final slidableActions = buildSlidableActions(isCurrentUserComment);

    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: slidableActions,
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

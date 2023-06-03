import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synergy/widgets/comment_widget/comment_section.dart';
import 'package:synergy/widgets/post_widget/post_body.dart';
import 'package:synergy/widgets/post_widget/post_footer.dart';
import 'package:synergy/widgets/post_widget/post_header.dart';
import 'package:synergy/widgets/report_section.dart';
import '../../models/FirestoreServiceModel.dart';
import '../../screens/view_user_profile_page.dart';

class PostView extends StatefulWidget {
  final String user;
  final Timestamp timestamp;
  final String message;
  final String postID;
  final List<String> likes;
  final String issueType;
  final bool isAnonymous;

  const PostView({
    Key? key,
    required this.user,
    required this.timestamp,
    required this.message,
    required this.postID,
    required this.likes,
    required this.issueType,
    required this.isAnonymous,
  }) : super(key: key);

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final FirestoreServiceModel firestoreServiceModel = FirestoreServiceModel();
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  late Future<int> numOfComments;
  late Future<String> username;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);

    setState(() {
      username = firestoreServiceModel.fetchUsername(widget.user);
      numOfComments =
          firestoreServiceModel.fetchNumOfPostComments(widget.postID);
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Report':
        reportPost(widget.postID);
        break;
      case 'Delete Post':
        firestoreServiceModel.deletePost(widget.postID);
        break;
      case 'View Profile':
        viewUserProfile(widget.user);
    }
  }

  void viewUserProfile(String user) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ViewUserProfilePage(user)));
  }

  void reportPost(String postID) {
    _showPostReportOptions(context, 'post', postID);
  }

  void _showCommentSection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CommentSection(postId: widget.postID);
      },
    );
  }

  void _showPostReportOptions(
      BuildContext context, String reportType, String reportId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ReportSection(
          reportType: reportType,
          reportId: reportId,
        );
      },
    );
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    firestoreServiceModel.toggleLike(widget.postID,isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostHeader(
                user: widget.user,
                isAnonymous: widget.isAnonymous,
                timestamp: widget.timestamp,
                username: username,
                currentUserEmail: currentUser.email!,
                handleClick: handleClick,
              ),
              const SizedBox(height: 8),
              PostBody(message: widget.message),
              const SizedBox(height: 8),
              PostFooter(
                isLiked: isLiked,
                onTapLike: toggleLike,
                postID: widget.postID,
                likes: widget.likes,
                issueType: widget.issueType,
                onTapComment: () {
                  _showCommentSection(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

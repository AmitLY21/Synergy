import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synergy/Helpers/helper.dart';
import 'package:synergy/Helpers/logger.dart';
import 'package:synergy/widgets/comment_section.dart';
import 'package:synergy/widgets/my_comment_button.dart';
import 'package:synergy/widgets/report_section.dart';
import '../screens/view_user_profile_page.dart';
import 'my_like_button.dart';
import 'package:readmore/readmore.dart';

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
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  int numOfComments = 0;
  late Future<String> username;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    username = fetchUserData();
    fetchNumOfComments();
  }

  Future<String> fetchUserData() async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user)
        .get();
    if (documentSnapshot.exists) {
      return documentSnapshot.data()!['username'];
    } else {
      return widget.user.split('@')[0];
    }
  }

  void fetchNumOfComments() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postID)
        .collection('Comments')
        .get();

    setState(() {
      numOfComments = querySnapshot.docs.length;
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Report':
        reportPost(widget.postID);
        break;
      case 'Delete Post':
        deletePost(widget.postID);
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

  void deletePost(String postID) {
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(postID);
    postRef
        .delete()
        .then((res) =>
            LoggerUtil.log().d("The post: $postID deleted successfully!"))
        .catchError((error) =>
            LoggerUtil.log().d('Delete for post $postID failed: $error'));
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

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(widget.postID);
    //Add user email
    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      //Remove user email
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
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
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: widget.isAnonymous
                    ? const CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Text(
                          widget.user.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                title: Text(
                  widget.isAnonymous ? "Anonymous User" : widget.user,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: FutureBuilder<String>(
                  future: username,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        Helper.formatTimestamp(widget.timestamp),
                        style: const TextStyle(fontSize: 14),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final username = snapshot.data!;
                      return Text(
                        widget.isAnonymous
                            ? Helper.formatTimestamp(widget.timestamp)
                            : "$username | ${Helper.formatTimestamp(widget.timestamp)}",
                        style: const TextStyle(fontSize: 14),
                      );
                    }
                  },
                ),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    final menuItems = <PopupMenuEntry<String>>[];

                    if (widget.user != currentUser.email!) {
                      if (!widget.isAnonymous) {
                        menuItems.add(
                          const PopupMenuItem<String>(
                            value: 'View Profile',
                            child: Text('View Profile'),
                          ),
                        );
                      }

                      menuItems.add(
                        const PopupMenuItem<String>(
                          value: 'Report',
                          child: Text('Report'),
                        ),
                      );
                    } else {
                      menuItems.add(
                        const PopupMenuItem<String>(
                          value: 'Delete Post',
                          child: Text('Delete Post'),
                        ),
                      );
                    }

                    return menuItems;
                  },
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: ReadMoreText(
                  widget.message,
                  trimLines: 5,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '\nShow more',
                  trimExpandedText: '\nShow less',
                  style: const TextStyle(fontSize: 16),
                  moreStyle: const TextStyle(
                      fontSize: 16, color: Colors.deepPurpleAccent),
                  lessStyle: const TextStyle(
                      fontSize: 16, color: Colors.deepPurpleAccent),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      LikeButton(
                        isLiked: isLiked,
                        onTap: toggleLike,
                        likes: widget.likes,
                      ),
                      const SizedBox(width: 6),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.postID)
                            .collection('Comments')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final commentDocs = snapshot.data!.docs;
                            final numOfComments = commentDocs.length;

                            return CommentButton(
                              onTap: () {
                                _showCommentSection(context);
                              },
                              numOfComments: numOfComments,
                            );
                          } else {
                            return CommentButton(
                              onTap: () {
                                _showCommentSection(context);
                              },
                              numOfComments: 0,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Chip(
                    label: Text(widget.issueType),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

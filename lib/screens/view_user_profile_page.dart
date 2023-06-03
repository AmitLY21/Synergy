import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synergy/Helpers/logger.dart';
import 'package:synergy/constants/app_constants.dart';
import 'package:synergy/widgets/buttons_widgets/my_button.dart';

import '../widgets/post_widget/my_post_view.dart';
import '../widgets/report_section.dart';

class ViewUserProfilePage extends StatefulWidget {
  final String user;

  ViewUserProfilePage(this.user);

  @override
  _ViewUserProfilePageState createState() => _ViewUserProfilePageState();
}

class _ViewUserProfilePageState extends State<ViewUserProfilePage> {
  late Future<String> usernameFuture;
  late Future<String> userBioFuture;

  @override
  void initState() {
    super.initState();
    usernameFuture = getUsernameFromFirestore(widget.user);
    userBioFuture = getUserBioFromFirestore(widget.user);
  }

  static Future<String> getUsernameFromFirestore(String user) async {
    final documentSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(user).get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data()!['username'];
    } else {
      return user.split('@')[0];
    }
  }

  static Future<String> getUserBioFromFirestore(String user) async {
    final documentSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(user).get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data()!['bio'];
    } else {
      return 'Empty Bio';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.userProfileTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.report),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => ReportSection(
                  reportType: 'user',
                  reportId: widget.user,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: const Icon(
                  Icons.person,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.user,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Divider(indent: 20, endIndent: 20),
            const SizedBox(height: 8),
            const Text(
              AppConstants.detailsText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<String>(
              future: usernameFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text(AppConstants.nameText),
                    subtitle: Text(snapshot.data!),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            FutureBuilder<String>(
              future: userBioFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text(AppConstants.bioText),
                    subtitle: Text(snapshot.data!),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 8),
            const Divider(indent: 20, endIndent: 20),
            const SizedBox(height: 8),
            const Text(
              AppConstants.postsText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('UserEmail', isEqualTo: widget.user)
                  .where('isAnonymous', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final posts = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PostView(
                            user: post['UserEmail'],
                            timestamp: post['Timestamp'],
                            message: post['Message'],
                            likes: List<String>.from(post['Likes'] ?? []),
                            issueType: post['issueType'],
                            isAnonymous: post['isAnonymous'],
                            postID: post.id,
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${AppConstants.errorPrefix}${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: MyButton(
                buttonText: 'Add Friend',
                onPressed: () {
                  LoggerUtil.log().d(
                    "${FirebaseAuth.instance.currentUser
                        ?.email!} is adding ${widget.user} as a friend",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synergy/constants/app_constants.dart';
import 'package:synergy/widgets/my_post_view.dart';

import '../widgets/edit_dialog.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late Future<String> usernameFuture;
  late Future<String> userBioFuture;

  @override
  void initState() {
    super.initState();
    usernameFuture = getUsernameFromFirestore(currentUser);
    userBioFuture = getUserBioFromFirestore(currentUser);
  }

  static Future<String> getUsernameFromFirestore(User user) async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email!)
        .get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data()!['username'];
    } else {
      return user.email!.split('@')[0];
    }
  }

  static Future<String> getUserBioFromFirestore(User user) async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email!)
        .get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data()!['bio'];
    } else {
      return 'Empty Bio';
    }
  }

  void updateUsername(String newUsername) async {
    setState(() {
      usernameFuture = Future.value(newUsername);
    });

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.email!);

    await userRef.update({'username': newUsername});
  }

  void updateUserBio(String newBio) async {
    setState(() {
      userBioFuture = Future.value(newBio);
    });

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.email!);

    await userRef.update({'bio': newBio});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.userProfileTitle),
      ),
      body: Column(
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
            currentUser.email!,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Divider(indent: 20, endIndent: 20),
          const SizedBox(height: 8),
          const Text(
            AppConstants.myDetailsText,
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
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditDialog(
                          title: AppConstants.usernameDialogTitle,
                          initialValue: snapshot.data!,
                          onUpdate: updateUsername,
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
          FutureBuilder<String>(
            future: userBioFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text(AppConstants.bioText),
                  subtitle: Text(snapshot.data!),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditDialog(
                          title: AppConstants.bioText,
                          initialValue: snapshot.data!,
                          onUpdate: updateUserBio,
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
          const SizedBox(height: 8),
          const Divider(indent: 20, endIndent: 20),
          const SizedBox(height: 8),
          const Text(
            'My Posts',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .where('UserEmail', isEqualTo: currentUser.email!)
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
        ],
      ),
    );
  }
}

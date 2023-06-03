import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../widgets/post_widget/my_post_view.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({Key? key}) : super(key: key);

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white70,
        child: Column(
          children: [
            //Posts
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .orderBy("Timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          //get message
                          final post = snapshot.data!.docs[index];

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
                        });
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error.toString()}'),
                    );
                  }
                  return const Center(
                      child: SpinKitSpinningLines(color: Colors.purple));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

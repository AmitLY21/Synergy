import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:synergy/Helpers/logger.dart';
import 'package:synergy/constants/app_constants.dart';
import '../widgets/chip_filter_issue.dart';
import '../widgets/post_widget/my_post_view.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<String> selectedChips = [];
  final currentUser = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    super.initState();
    checkForUserIssueTypes();
  }

  Future<void> checkForUserIssueTypes() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.email)
        .get();

    if (docSnapshot.exists) {
      final userIssueTypes =
          List<String>.from(docSnapshot['userIssueTypes'] ?? []);
      LoggerUtil.log().d(
          "checkForUserIssueTypes: assigning selectedChips -> $selectedChips with userIssueTypes -> $userIssueTypes");
      setState(() {
        selectedChips = userIssueTypes;
      });
    }
  }

  void handleSelectedChips(List<String> selectedChips) {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser?.email!);

    // Get the current user issue types
    userRef.get().then((snapshot) {
      List<String> currentIssueTypes =
          List<String>.from(snapshot.get('userIssueTypes') ?? []);

      // Remove existing issue types
      WriteBatch batch = FirebaseFirestore.instance.batch();
      currentIssueTypes.forEach((issueType) {
        batch.update(userRef, {
          'userIssueTypes': FieldValue.arrayRemove([issueType])
        });
      });

      // Add selected issue types
      selectedChips.forEach((issueType) {
        batch.update(userRef, {
          'userIssueTypes': FieldValue.arrayUnion([issueType])
        });
      });

      batch.commit().then((_) {
        setState(() {
          this.selectedChips = selectedChips;
        });
      }).catchError((error) {
        // Handle the error if the update fails
        LoggerUtil.log().d(AppConstants.failedToUpdateIssueTypesError + error);
      });
    }).catchError((error) {
      // Handle the error if fetching the user document fails
      LoggerUtil.log().d(AppConstants.failedToFetchUserDocumentError + error);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.explorePageTitle),
      ),
      body: Column(
        children: [
          IssueChipsRow(
            onChipsSelected: handleSelectedChips,
            selectedChips: selectedChips,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .orderBy("Timestamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final post = documents[index];
                      if (selectedChips.contains(post['issueType'])) {
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
                      }
                      // Add a default return statement to return an empty container if the condition is not met
                      return Container();
                    },
                  );
                } else if (snapshot.hasError) {
                  LoggerUtil.log().d('${snapshot.error.toString()}');
                  return Center(
                    child: Text( '${AppConstants.errorPrefix}${snapshot.error.toString()}'),
                  );
                }
                return const Center(
                    child: SpinKitSpinningLines(color: Colors.purple));
              },
            ),
          ),
        ],
      ),
    );
  }
}

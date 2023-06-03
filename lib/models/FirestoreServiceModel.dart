import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synergy/Helpers/logger.dart';

import '../constants/app_constants.dart';

class FirestoreServiceModel {
  final CollectionReference _postsCollection =
      FirebaseFirestore.instance.collection("posts");
  final CollectionReference _reportsCollection =
      FirebaseFirestore.instance.collection("reports");
  final User _currentUser = FirebaseAuth.instance.currentUser!;

  User get currentUser => _currentUser;

  //PostView Section
  Future<String> fetchUsername(String user) async {
    final documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    if (documentSnapshot.exists) {
      return documentSnapshot.data()!['username'];
    } else {
      return user.split('@')[0];
    }
  }

  Future<int> fetchNumOfPostComments(String postID) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('Comments')
        .get();
    return querySnapshot.docs.length;
  }

  void deletePost(String postID) {
    DocumentReference postRef = _postsCollection.doc(postID);
    postRef
        .delete()
        .then((res) =>
            LoggerUtil.log().d("The post: $postID deleted successfully!"))
        .catchError((error) =>
            LoggerUtil.log().d('Delete for post $postID failed: $error'));
  }

  void toggleLike(String postID, bool isLiked) {
    DocumentReference postRef = _postsCollection.doc(postID);
    //Add user email
    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      }).then((value) =>
          {LoggerUtil.log().d("The post: $postID was liked by user: ${currentUser.email}")});
    } else {
      //Remove user email
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      }).then((value) =>
      {LoggerUtil.log().d("The post: $postID was un-like by user: ${currentUser.email}")});;
    }
  }

  //Reports Section
  void sendReport(
      {required String reportType,
      required String reportId,
      required String reportReason}) {
    final reportData = {
      'reportType': reportType,
      'reportId': reportId,
      'reporterEmail': _currentUser.email!,
      'reportReason': reportReason,
    };

    _reportsCollection
        .doc(reportType)
        .collection('$reportType' 'Reports')
        .add(reportData)
        .then((value) {
      LoggerUtil.log().d(
          'Report sent - Type: $reportType, ID: $reportId, Reason: $reportReason');
    }).catchError((error) {
      LoggerUtil.log().e('Error sending report: $error');
    });
  }

  List<String> getReportOptions(String reportType) {
    if (reportType == 'post') {
      return AppConstants.reportPostOptions;
    } else if (reportType == 'comment') {
      return AppConstants.reportCommentOptions;
    } else if (reportType == 'user') {
      return AppConstants.reportUserOptions;
    } else {
      return [];
    }
  }

  //Comment Section Functions
  Future<void> addComment(String postId, String message) async {
    if (message.isNotEmpty) {
      await _postsCollection.doc(postId).collection("Comments").add({
        'UserEmail': _currentUser.email,
        'Message': message,
        'Timestamp': Timestamp.now(),
      }).then((value) => {
            LoggerUtil.log().d(
                "Uploaded successfully comment ID: ${value.id} to post ID: ${postId} with the message: \"$message\"")
          });
    } else {
      throw Exception('Comment message is empty');
    }
  }

  Stream<QuerySnapshot> getComments(String postId) {
    return _postsCollection
        .doc(postId)
        .collection("Comments")
        .orderBy('Timestamp', descending: true)
        .snapshots();
  }

  //Comment widget
  Future<void> deleteComment(String postId, String commentId) async {
    final commentRef =
        _postsCollection.doc(postId).collection('Comments').doc(commentId);
    await commentRef.delete();
    LoggerUtil.log().d("The post: $commentRef deleted successfully!");
  }
}

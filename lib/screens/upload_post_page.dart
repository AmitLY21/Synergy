import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synergy/Helpers/logger.dart';
import 'package:synergy/constants/app_constants.dart';

import '../Helpers/helper.dart';
import '../models/AppsFlyerService.dart';
import '../widgets/buttons_widgets/modern_button.dart';
import '../widgets/my_dropdown_menu.dart';

class UploadPost extends StatefulWidget {
  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  bool isAnonymous = false;
  TextEditingController postController = TextEditingController();
  var selectedCategory = 'Love';
  final currentUser = FirebaseAuth.instance.currentUser!;

  void uploadPost(String postText, bool isAnonymous, String selectedCategory) {
    //only post if there is something in the text field
    if (postController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("posts").add({
        'UserEmail': currentUser.email,
        'Message': postController.text,
        'Timestamp': Timestamp.now(),
        'Likes': [],
        'isAnonymous': isAnonymous,
        'issueType': selectedCategory
      }).then((success) => {
            LoggerUtil.log().d(
                'Successfully uploaded ${currentUser.email} post: $postText , Anonymous: $isAnonymous , $success '),
            AppsFlyerService().logEvent("Upload Post", {"userEmail" : currentUser.email , "isAnonymous" : isAnonymous , "postID" : success.id })
      });

      postController.clear();
    } else {
      Helper.showToast(AppConstants.postIsEmpty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.uploadPostTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                SwitchListTile(
                  title: const Text(
                    AppConstants.postAnonymously,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  value: isAnonymous,
                  onChanged: (value) {
                    setState(() {
                      isAnonymous = value;
                    });
                  },
                  activeColor: Colors.purple[600],
                  contentPadding: const EdgeInsets.all(0.0),
                  dense: true, // Reduce the tile height
                ),
                const SizedBox(height: 16.0),
                MyDropdownMenu(
                  selectedCategory: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  values: AppConstants.allIssues,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                  enableInteractiveSelection: true,
                  controller: postController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: AppConstants.postTextFieldHint,
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 48.0, // Specify a fixed height for the container
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: ModernButton(
                      icon: Icons.send_sharp,
                      text: AppConstants.uploadButtonText,
                      onPressed: () {
                        String postText = postController.text;
                        uploadPost(postText, isAnonymous, selectedCategory);
                      },
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Flexible(
                    fit: FlexFit.tight,
                    child: ModernButton(
                      icon: Icons.add_a_photo,
                      text: AppConstants.addPhotoButtonText,
                      onPressed: () {
                        // Add photo button action
                        // Handle adding photo logic
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

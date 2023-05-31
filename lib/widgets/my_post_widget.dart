import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PostWidget extends StatelessWidget {
  final VoidCallback onUploadPressed;
  final TextEditingController controller;

  const PostWidget({
    Key? key,
    required this.onUploadPressed,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'What is on your mind?...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: onUploadPressed,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Ionicons.send_outline,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

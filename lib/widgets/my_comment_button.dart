import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final VoidCallback onTap;
  final int numOfComments;

  CommentButton({required this.onTap, required this.numOfComments});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(Icons.comment),
          SizedBox(width: 4),
          Text('$numOfComments'),
        ],
      ),
    );
  }
}

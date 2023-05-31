import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final List<String> likes;
  void Function()? onTap;

  LikeButton({
    Key? key,
    required this.isLiked,
    required this.onTap,
    required this.likes,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  void showListDialog(BuildContext context, List<String> items) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (items.isEmpty) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            title: Text('Likes'),
            content: Text('No items to display.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            title: Text('Likes'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(items.length, (index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(items[index]),
                  onTap: () {
                    // Handle item tap
                    Navigator.pop(context); // Close the dialog
                  },
                );
              }),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          onLongPress: () {
            showListDialog(context, widget.likes);
          },
          child: Icon(
            widget.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.isLiked ? Colors.purple : Colors.grey,
          ),
        ),
        const SizedBox(width: 3),
        Text(widget.likes.length.toString()),
      ],
    );
  }
}

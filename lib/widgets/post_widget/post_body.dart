import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class PostBody extends StatelessWidget {
  final String message;

  const PostBody({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: ReadMoreText(
        message,
        trimLines: 5,
        trimMode: TrimMode.Line,
        trimCollapsedText: '\nShow more',
        trimExpandedText: '\nShow less',
        style: const TextStyle(fontSize: 16),
        moreStyle: const TextStyle(fontSize: 16, color: Colors.deepPurpleAccent),
        lessStyle: const TextStyle(fontSize: 16, color: Colors.deepPurpleAccent),
      ),
    );
  }
}

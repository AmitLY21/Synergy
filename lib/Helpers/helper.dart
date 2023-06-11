import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Helper {
  static final Helper _instance = Helper._internal();

  factory Helper() => _instance;

  Helper._internal();

  static void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static String formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    String formattedDate = '';

    // Format the date
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 7) {
      // Display the full date if the post is older than a week
      formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays >= 1) {
      // Display the number of days ago if the post is older than a day
      formattedDate = '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      // Display the number of hours ago if the post is older than an hour
      formattedDate = '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      // Display the number of minutes ago if the post is older than a minute
      formattedDate = '${difference.inMinutes} minutes ago';
    } else {
      // Display "Just now" if the post is very recent
      formattedDate = 'Just now';
    }

    return formattedDate;
  }

  String formatPublishedDate(String publishedAt) {
    DateTime parsedDate = DateTime.parse(publishedAt);
    String formattedDate = DateFormat.yMMMMd().format(parsedDate);
    return formattedDate;
  }

}

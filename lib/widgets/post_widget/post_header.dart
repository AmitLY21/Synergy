import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synergy/Helpers/helper.dart';

import '../../constants/app_constants.dart';

class PostHeader extends StatelessWidget {
  final String user;
  final bool isAnonymous;
  final Timestamp timestamp;
  final Future<String> username;
  final String currentUserEmail;
  final Function(String) handleClick;

  const PostHeader({
    Key? key,
    required this.user,
    required this.isAnonymous,
    required this.timestamp,
    required this.username,
    required this.currentUserEmail,
    required this.handleClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: isAnonymous
          ? const CircleAvatar(
        backgroundColor: Colors.black,
        child: Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
      )
          : CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(
          user.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        isAnonymous ? AppConstants.userAnonymously : user,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: FutureBuilder<String>(
        future: username,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text(
              Helper.formatTimestamp(timestamp),
              style: const TextStyle(fontSize: 14),
            );
          } else if (snapshot.hasError) {
            return Text('${AppConstants.errorPrefix}${snapshot.error}');
          } else {
            final username = snapshot.data!;
            return Text(
              isAnonymous
                  ? Helper.formatTimestamp(timestamp)
                  : "$username | ${Helper.formatTimestamp(timestamp)}",
              style: const TextStyle(fontSize: 14),
            );
          }
        },
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        onSelected: handleClick,
        itemBuilder: (BuildContext context) {
          final menuItems = <PopupMenuEntry<String>>[];

          if (user != currentUserEmail) {
            if (!isAnonymous) {
              menuItems.add(
                const PopupMenuItem<String>(
                  value: 'View Profile',
                  child: Text('View Profile'),
                ),
              );
            }

            menuItems.add(
              const PopupMenuItem<String>(
                value: 'Report',
                child: Text('Report'),
              ),
            );
          } else {
            menuItems.add(
              const PopupMenuItem<String>(
                value: 'Delete Post',
                child: Text('Delete Post'),
              ),
            );
          }

          return menuItems;
        },
      ),
    );
  }
}

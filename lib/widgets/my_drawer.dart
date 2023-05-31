import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void logOut() {
      FirebaseAuth.instance.signOut();
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.bolt_sharp,
                        size: 50,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(AppConstants.appTitle),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  title: Text('Settings'),
                  onTap: (){
                    //TODO: Add Settings page
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: Text('Logout'),
              onTap: (){
                logOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

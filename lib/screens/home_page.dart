import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:synergy/constants/app_constants.dart';
import 'package:synergy/screens/upload_post_page.dart';
import 'package:synergy/screens/user_profile_page.dart';
import 'package:synergy/widgets/my_drawer.dart';
import 'package:synergy/screens/explore_page.dart';
import 'package:synergy/screens/news_feed_page.dart';
import 'package:synergy/screens/organization_page.dart';

final glbKey = GlobalKey();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  void _navigateBottomBar(int currentIndex) {
    setState(() {
      _selectedIndex = currentIndex;
    });
  }

  final List<Widget> _routes = [
    const NewsFeedPage(),
    const ExplorePage(),
    UploadPost(),
    OrganizationPage(),
    UserProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        bottom: PreferredSize(
            preferredSize: Size.zero,
            child: //Sign as
                Text(currentUser.email!)),
        actions: [Center(child: IconButton(onPressed: (){}, icon: const Icon(Ionicons.notifications )))],
      ),
      drawer: const MyDrawer(),
      body: _routes[_selectedIndex],
      bottomNavigationBar: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 20, top: 8, left: 20, right: 20),
        alignment: Alignment.topCenter,
        child: GNav(
          key: glbKey,
          tabBorderRadius: 15,
          tabActiveBorder: Border.all(color: Colors.white, width: 1),
          selectedIndex: _selectedIndex,
          gap: 8,
          iconSize: 24,
          onTabChange: _navigateBottomBar,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: AppConstants.bottomNavHome,
            ),
            GButton(
              icon: Icons.explore,
              text: AppConstants.bottomNavExplore,
            ),
            GButton(
              icon: Icons.add,
              text: AppConstants.bottomNavUpload,
            ),
            GButton(
              icon: Icons.list_alt,
              text: AppConstants.bottomNavOrganizations,
            ),
            GButton(
              icon: Icons.person,
              text: AppConstants.bottomNavProfile,
            )
          ],
        ),
      ),
    );
  }
}

/**/

import 'package:flutter/material.dart';
import 'package:synergy/screens/articles_tab.dart';

import 'organizations_tab.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({Key? key}) : super(key: key);

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[200],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.business_sharp),
                      SizedBox(width: 8),
                      Text('Organizations'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.article_outlined),
                      SizedBox(width: 8),
                      Text('Articles'),
                    ],
                  ),
                ),
              ],
              indicatorSize: TabBarIndicatorSize.label,
            ),
            title: const Text('Organizations & Articles'),
          ),
          body: const TabBarView(
            children: [
              OrganizationTab(),
              ArticlesTab(),
            ],
          ),

        ),
      ),
    );
  }
}

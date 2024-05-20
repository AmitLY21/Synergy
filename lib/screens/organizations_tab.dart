import 'package:flutter/material.dart';
import 'package:synergy/models/ApiService.dart';

import '../models/AppsFlyerService.dart';
import '../models/organization.dart';
import '../widgets/organization_list_tile.dart';

class OrganizationTab extends StatefulWidget {
  const OrganizationTab({Key? key}) : super(key: key);

  @override
  State<OrganizationTab> createState() => _OrganizationTabState();
}

class _OrganizationTabState extends State<OrganizationTab> {
  final client = ApiService();
  late Future<List<Organization>> futureOrganizations;

  @override
  void initState() {
    super.initState();
    futureOrganizations = client.getOrganizations();
    AppsFlyerService().logEvent("Open organization tab", {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Organization>>(
        future: futureOrganizations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<Organization> organizations = snapshot.data!;
            return ListView.builder(
              itemCount: organizations.length,
              itemBuilder: (context, index) =>
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OrganizationListTile(organization: organizations[index]),
                  ),
            );
          } else {
            return const Center(
              child: Text('No organizations found.'),
            );
          }
        },
      ),
    );
  }
}

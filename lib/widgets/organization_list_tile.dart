import 'package:flutter/material.dart';

import '../models/organization.dart';
import '../screens/organization_info_page.dart';

class OrganizationListTile extends StatelessWidget {
  final Organization organization;

  const OrganizationListTile({required this.organization});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.white,
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrganizationInfoPage(organization: organization),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: "organizationImage${organization.imageUrl}",
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: organization.imageUrl.isNotEmpty
                      ? Image.network(
                    organization.imageUrl,
                    fit: BoxFit.scaleDown,
                  )
                      : const Icon(Icons.business_sharp),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 0.2,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organization.organizationName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      organization.description.split('\n')[0],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

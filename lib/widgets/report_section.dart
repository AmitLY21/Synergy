import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synergy/Helpers/logger.dart';

import '../constants/app_constants.dart';

class ReportSection extends StatelessWidget {
  final String reportType;
  final String reportId;

  ReportSection({required this.reportType, required this.reportId});

  void sendReport(String reportReason) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final reportData = {
      'reportType': reportType,
      'reportId': reportId,
      'reporterEmail': currentUser?.email!,
      'reportReason': reportReason,
    };

    FirebaseFirestore.instance
        .collection('reports')
        .doc(reportType)
        .collection('$reportType' 'Reports')
        .add(reportData)
        .then((value) {
      LoggerUtil.log().d(
          'Report sent - Type: $reportType, ID: $reportId, Reason: $reportReason');
    }).catchError((error) {
      LoggerUtil.log().e('Error sending report: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          MediaQuery.of(context).size.height * 0.5, // Half of the screen height
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Report',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            'Why are you reporting this $reportType?',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: getReportOptions().length,
              itemBuilder: (context, index) {
                final reportOption = getReportOptions()[index];
                return Column(
                  children: [
                    ListTile(
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                      title: Text(reportOption),
                      onTap: () {
                        Navigator.of(context)
                            .pop(); // Close the modal bottom sheet
                        sendReport(
                            reportOption); // Trigger the sendReport function
                      },
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> getReportOptions() {
    if (reportType == 'post') {
      return AppConstants.reportPostOptions;
    } else if (reportType == 'comment') {
      return AppConstants.reportCommentOptions;
    } else if (reportType == 'user') {
      return AppConstants.reportUserOptions;
    } else {
      return [];
    }
  }
}

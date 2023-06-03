import 'package:flutter/material.dart';
import '../models/FirestoreServiceModel.dart';

class ReportSection extends StatelessWidget {
  final String reportType;
  final String reportId;
  final FirestoreServiceModel firestoreServiceModel = FirestoreServiceModel();

  ReportSection({required this.reportType, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
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
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: firestoreServiceModel.getReportOptions(reportType).length,
              itemBuilder: (context, index) {
                final reportOption = firestoreServiceModel.getReportOptions(reportType)[index];
                return Column(
                  children: [
                    ListTile(
                      trailing: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                      title: Text(reportOption),
                      onTap: () {
                        Navigator.of(context).pop();
                        firestoreServiceModel.sendReport(
                          reportType: reportType,
                          reportId: reportId,
                          reportReason: reportOption,
                        );
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

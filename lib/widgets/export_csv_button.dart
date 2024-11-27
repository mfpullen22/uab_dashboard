// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:uab_dashboard/models/project.dart';

class ExportCsvButton extends StatelessWidget {
  const ExportCsvButton({super.key, required this.projects});

  final List<Project> projects;

  void exportToCsv() {
    // Define the CSV headers
    const headers = [
      "Title",
      "Short Name",
      "PI",
      "Co-PIs",
      "Status",
      "Type",
      "Subgroup",
      "Sites",
      "Description",
      "Presented Date",
      "Approval SC Date",
      "Approval CDC Date",
      "Approval IRB Date",
      "IRB Number",
      "Approval Contract Date",
      "Activated Date",
      "Enrollment Screened",
      "Enrollment Enrolled",
      "Data Collection",
      "Close Out",
      "Start Date",
      "End Date",
      "Funding",
      "Comments",
    ];

    // Create a list of rows, starting with the headers
    final rows = <List<String>>[headers];

    // Add project data as rows
    for (var project in projects) {
      rows.add([
        project.title,
        project.shortName,
        project.pi,
        project.copis.join(", "), // Convert list to a comma-separated string
        project.status,
        project.type,
        project.subgroup,
        project.sites.join(", "), // Convert list to a comma-separated string
        project.description,
        project.presentedDate,
        project.approvalSCDate,
        project.approvalCDCDate,
        project.approvalIRBDate,
        project.irbNumber,
        project.approvalContractDate,
        project.activatedDate,
        project.enrollment["screened"]?.toString() ?? "0",
        project.enrollment["enrolled"]?.toString() ?? "0",
        project.dataCollection,
        project.closeOut,
        project.startDate,
        project.endDate,
        jsonEncode(project.funding), // Encode funding map as JSON
        jsonEncode(project.comments), // Encode comments map as JSON
      ]);
    }

    // Convert rows to CSV string
    final csvContent = const ListToCsvConverter().convert(rows);

    // Create a Blob and download it
    final blob = Blob([csvContent]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'projects.csv'
      ..click();
    Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: exportToCsv,
      child: const Text('Export to CSV'),
    );
  }
}

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:uab_dashboard/models/project.dart';

class ExportExcelButton extends StatelessWidget {
  const ExportExcelButton({super.key, required this.projects});

  final List<Project> projects;

  void exportToExcel() {
    // Create a new Excel document
    final excel = Excel.createExcel();

    // Define headers as a list of `CellValue`
    final headers = [
      TextCellValue("Title"),
      TextCellValue("Short Name"),
      TextCellValue("PI"),
      TextCellValue("Co-PIs"),
      TextCellValue("Status"),
      TextCellValue("Type"),
      TextCellValue("Subgroup"),
      TextCellValue("Sites"),
      TextCellValue("Description"),
      TextCellValue("Presented Date"),
      TextCellValue("Approval SC Date"),
      TextCellValue("Approval CDC Date"),
      TextCellValue("Approval IRB Date"),
      TextCellValue("IRB Number"),
      TextCellValue("Approval Contract Date"),
      TextCellValue("Activated Date"),
      TextCellValue("Enrollment Screened"),
      TextCellValue("Enrollment Enrolled"),
      TextCellValue("Data Collection"),
      TextCellValue("Close Out"),
      TextCellValue("Start Date"),
      TextCellValue("End Date"),
      TextCellValue("Active/Pending"),
      TextCellValue("Funding"),
      TextCellValue("Comments"),
    ];

    // Function to add projects to a specific sheet
    void addProjectsToSheet(String sheetName, List<Project> projectList) {
      final sheet = excel[sheetName]; // Create or get the sheet

      // Add headers to the sheet
      sheet.appendRow(headers);

      // Add rows of project data
      for (var project in projectList) {
        sheet.appendRow([
          TextCellValue(project.title),
          TextCellValue(project.shortName),
          TextCellValue(project.pi),
          TextCellValue(project.copis.join(", ")), // Convert list to a string
          TextCellValue(project.status),
          TextCellValue(project.type),
          TextCellValue(project.subgroup),
          TextCellValue(project.sites.join(", ")), // Convert list to a string
          TextCellValue(project.description),
          TextCellValue(project.presentedDate),
          TextCellValue(project.approvalSCDate),
          TextCellValue(project.approvalCDCDate),
          TextCellValue(project.approvalIRBDate),
          TextCellValue(project.irbNumber),
          TextCellValue(project.approvalContractDate),
          TextCellValue(project.activatedDate),
          TextCellValue(project.enrollment["screened"]?.toString() ?? "0"),
          TextCellValue(project.enrollment["enrolled"]?.toString() ?? "0"),
          TextCellValue(project.dataCollection),
          TextCellValue(project.closeOut),
          TextCellValue(project.startDate),
          TextCellValue(project.endDate),
          TextCellValue(project.activeFilter),
          TextCellValue(
              project.funding.isNotEmpty ? project.funding.toString() : ""),
          TextCellValue(
              project.comments.isNotEmpty ? project.comments.toString() : ""),
        ]);
      }
    }

    // Split projects into active and pending
    final activeProjects = projects.where((p) => p.status == "active").toList();
    final pendingProjects =
        projects.where((p) => p.status == "pending").toList();

    // Add data to respective sheets
    addProjectsToSheet("Active Projects", activeProjects);
    addProjectsToSheet("Pending Projects", pendingProjects);

    // Delete the default "Sheet1"
    excel.delete('Sheet1');

    // Save the file and trigger download
    final fileBytes = excel.save(fileName: "projects_test.xlsx");
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: exportToExcel,
      child: const Text('Export to Excel'),
    );
  }
}



/* // ignore_for_file: avoid_web_libraries_in_flutter

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
      "Active/Pending",
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
        project.activeFilter,
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
 */
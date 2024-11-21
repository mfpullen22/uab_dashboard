import 'package:flutter/material.dart';
import 'package:uab_dashboard/models/project.dart';

class ProjectsTable extends StatelessWidget {
  const ProjectsTable({super.key, required this.projects});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Title')),
          DataColumn(label: Text('Short Name')),
          DataColumn(label: Text('PI')),
          DataColumn(label: Text('Co-PIs')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Subgroup')),
          DataColumn(label: Text('Sites')),
          DataColumn(label: Text('Presented Date')),
          // Add more columns as needed
        ],
        rows: projects.map((project) {
          return DataRow(cells: [
            DataCell(Text(project.title)),
            DataCell(Text(project.shortName)),
            DataCell(Text(project.pi)),
            DataCell(Text(project.copis.join(', '))),
            DataCell(Text(project.status)),
            DataCell(Text(project.type)),
            DataCell(Text(project.subgroup)),
            DataCell(Text(project.sites.join(', '))),
            DataCell(Text(project.presentedDate)),
            // Add more cells as needed
          ]);
        }).toList(),
      ),
    );
  }
}

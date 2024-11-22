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
          DataColumn(label: Text('Title/PI')),
          DataColumn(label: Text('Presented')),
          DataColumn(label: Text('Approved')),
          DataColumn(label: Text('IRB Number')),
          DataColumn(label: Text('Activated')),
          DataColumn(label: Text('Enrolled')),
          DataColumn(label: Text('Data Collection')),
          DataColumn(label: Text('Close Out')),
          DataColumn(label: Text('Comments')),
        ],
        rows: projects.map(
          (project) {
            return DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: 200, // Fixed width for the column
                    child: Wrap(
                      spacing: 0, // No spacing between wrapped elements
                      runSpacing: 4, // Add spacing between lines
                      children: [
                        Text(
                          project.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Text(
                              "PI: ",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(project.pi),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                DataCell(Text(project.presentedDate)),
                DataCell(SizedBox(
                  width: 150,
                  child: Wrap(
                    spacing: 0,
                    runSpacing: 4,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "SC: ",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(project.approvalSCDate),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "CDC: ",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(project.approvalCDCDate),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("IRB: ",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold)),
                          Text(project.approvalIRBDate),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Contract: ",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold)),
                          Text(project.approvalContractDate.isEmpty
                              ? 'Pending'
                              : project.approvalContractDate),
                        ],
                      ),
                    ],
                  ),
                )),
                DataCell(
                  Text(project.irbNumber.isNotEmpty
                      ? project.irbNumber
                      : 'Pending'),
                ),
                DataCell(
                  Text(project.activatedDate.isNotEmpty
                      ? project.activatedDate
                      : 'Pending'),
                ),
                DataCell(
                  SizedBox(
                    width: 150,
                    child: Wrap(
                      spacing: 0,
                      runSpacing: 4,
                      children: [
                        Row(
                          children: [
                            const Text("Screened: "),
                            Text(project.enrollment["screened"].isNotEmpty
                                ? project.enrollment["screened"]
                                : '0'),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Enrolled: "),
                            Text(project.enrollment["enrolled"].isNotEmpty
                                ? project.enrollment["enrolled"]
                                : '0'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                DataCell(
                  Text(project.dataCollection.isNotEmpty
                      ? project.dataCollection
                      : 'Pending'),
                ),
                DataCell(
                  Text(project.closeOut.isNotEmpty
                      ? project.closeOut
                      : 'Pending'),
                ),
                DataCell(
                  SizedBox(
                    width: 150,
                    child: Wrap(
                      children: project.comments.entries.map((entry) {
                        return Row(
                          children: [
                            Text(
                              entry.key,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(entry.value),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}

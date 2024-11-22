import 'package:flutter/material.dart';
import 'package:uab_dashboard/models/project.dart';

class ProjectsTable extends StatelessWidget {
  const ProjectsTable({super.key, required this.projects});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: projects.map(
          (project) {
            return Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom:
                      BorderSide(color: Colors.grey, width: 2), // Divider line
                ),
              ),
              child: DataTable(
                dataRowMinHeight: 50,
                dataRowMaxHeight: double.infinity,
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
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 200,
                          child: Wrap(
                            spacing: 0,
                            runSpacing: 4,
                            children: [
                              Text(
                                project.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                      DataCell(
                        SizedBox(
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
                            ],
                          ),
                        ),
                      ),
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
                            children: project.comments.entries.map(
                              (entry) {
                                return Row(
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(entry.value),
                                    ),
                                  ],
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

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
        headingRowColor: MaterialStateProperty.resolveWith<Color>(
          (states) => Colors.grey[200]!, // Light grey for the header row
        ),
        dataRowMinHeight: 50,
        dataRowMaxHeight: double.infinity,
        columns: const [
          DataColumn(
            label: Text(
              'Title/PI',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Presented',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Approved',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'IRB Number',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Activated',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Enrolled',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Data Collection',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Close Out',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Latest Comment',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          ),
        ],
        rows: projects.asMap().entries.map(
          (entry) {
            final index = entry.key; // Current index
            final project = entry.value; // Current project

            final recentCommentEntry =
                project.comments.entries.fold<MapEntry<String, dynamic>?>(
              null,
              (mostRecent, entry) {
                if (mostRecent == null) return entry;
                final mostRecentDate = DateTime.tryParse(mostRecent.key);
                final currentDate = DateTime.tryParse(entry.key);
                if (currentDate != null &&
                    (mostRecentDate == null ||
                        currentDate.isAfter(mostRecentDate))) {
                  return entry;
                }
                return mostRecent;
              },
            );

            final recentCommentDate = recentCommentEntry?.key ?? 'No Comments';
            final recentCommentText =
                recentCommentEntry?.value ?? 'No Comments';

            // Determine row background color
            final backgroundColor = MaterialStateProperty.resolveWith<Color>(
              (states) =>
                  (index % 2 == 0) ? Colors.lightBlue[50]! : Colors.transparent,
            );

            return DataRow(
              color: backgroundColor, // Alternate row color
              cells: [
                DataCell(
                  SizedBox(
                    width: 150,
                    child: Wrap(
                      spacing: 0,
                      runSpacing: 4,
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
                DataCell(
                  SizedBox(width: 80, child: Text(project.presentedDate)),
                ),
                DataCell(
                  SizedBox(
                    width: 120,
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
                            const Text(
                              "IRB: ",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(project.approvalIRBDate.isNotEmpty
                                ? project.approvalIRBDate
                                : 'Pending'),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Contract: ",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(project.approvalContractDate.isNotEmpty
                                ? project.approvalContractDate
                                : 'Pending'),
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
                    width: 100,
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
                  SizedBox(
                    width: 100,
                    child: Text(project.dataCollection.isNotEmpty
                        ? project.dataCollection
                        : 'Pending'),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 100,
                    child: Text(project.closeOut.isNotEmpty
                        ? project.closeOut
                        : 'Pending'),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 300,
                    child: Wrap(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recentCommentDate,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(recentCommentText),
                          ),
                        ],
                      ),
                    ]),
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

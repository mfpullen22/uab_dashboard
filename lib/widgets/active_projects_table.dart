import 'package:flutter/material.dart';
import 'package:uab_dashboard/models/project.dart';

class ActiveProjectsTable extends StatelessWidget {
  const ActiveProjectsTable({super.key, required this.projects});

  final List<Project> projects;

  DateTime parseDate(String dateString) {
    try {
      // Split the string into components (MM/DD/YYYY)
      final parts = dateString.split('/');
      if (parts.length == 3) {
        final month = int.parse(parts[0]);
        final day = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      debugPrint('Error parsing date: $dateString, error: $e');
    }
    return DateTime(0); // Fallback to epoch if parsing fails
  }

  @override
  Widget build(BuildContext context) {
    final activeProjects =
        projects.where((project) => project.activeFilter == "active").toList()
          ..sort((a, b) {
            final dateA = parseDate(a.presentedDate);
            final dateB = parseDate(b.presentedDate);
            return dateA.compareTo(dateB);
          });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.resolveWith<Color>(
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
                fontSize: 16,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Presented',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Approved',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          ),
/*           DataColumn(
            label: Text(
              'IRB Number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          ), */
          DataColumn(
            label: Text(
              'Activated',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Enrolled',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          ),
/*           DataColumn(
            label: Text(
              'Data Collection',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Close Out',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          ), */
          DataColumn(
            label: Text(
              'Latest Comment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          ),
        ],
        rows: activeProjects.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final project = entry.value;

            final recentCommentEntry = project.comments.entries
                .fold<MapEntry<String, dynamic>?>(null, (mostRecent, entry) {
              final currentDate = parseDate(entry.key);
              if (mostRecent == null ||
                  currentDate.isAfter(parseDate(mostRecent.key))) {
                return entry;
              }
              return mostRecent;
            });

            final recentCommentDate = recentCommentEntry?.key ?? 'No Comments';
            final recentCommentText =
                recentCommentEntry?.value ?? 'No Comments';

            return DataRow(
              color: WidgetStateProperty.resolveWith<Color>(
                (states) => (index % 2 == 0)
                    ? Colors.lightBlue[50]!
                    : Colors.transparent,
              ),
              cells: [
                DataCell(
                  SizedBox(
                    width: 250, // Fixed width for the cell
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          softWrap: true, // Allow text to wrap
                          overflow:
                              TextOverflow.visible, // Ensure all text is shown
                        ),
                        const SizedBox(
                            height: 4), // Small spacing between title and PI
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "PI: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                project.pi,
                                softWrap: true, // Allow text to wrap
                                overflow: TextOverflow
                                    .visible, // Ensure all text is shown
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                DataCell(Text(project.presentedDate)),
                DataCell(Text(
                  project.approvalSCDate.isNotEmpty
                      ? project.approvalSCDate
                      : 'Pending',
                )),
                /* DataCell(Text(project.irbNumber.isNotEmpty
                    ? project.irbNumber
                    : 'Pending')), */
                DataCell(Text(project.activatedDate.isNotEmpty
                    ? project.activatedDate
                    : 'Pending')),
                DataCell(Text(
                  "Screened: ${project.enrollment['screened'] ?? '0'}\n"
                  "Enrolled: ${project.enrollment['enrolled'] ?? '0'}",
                )),
/*                 DataCell(Text(project.dataCollection.isNotEmpty
                    ? project.dataCollection
                    : 'Pending')),
                DataCell(Text(project.closeOut.isNotEmpty
                    ? project.closeOut
                    : 'Pending')), */
                DataCell(
                  SizedBox(
                    width: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recentCommentDate,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          softWrap: true, // Allow text to wrap
                          overflow: TextOverflow.visible,
                        ),
                        Text(recentCommentText),
                      ],
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

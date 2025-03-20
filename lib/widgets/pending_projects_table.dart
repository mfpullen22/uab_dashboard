import 'package:flutter/material.dart';
import 'package:uab_dashboard/models/project.dart';

class PendingProjectsTable extends StatelessWidget {
  const PendingProjectsTable({super.key, required this.projects});

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
    final pendingProjects =
        projects.where((project) => project.activeFilter == "pending").toList()
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
              'PI',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Short Name',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Title',
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
        rows: pendingProjects.asMap().entries.map(
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
            final backgroundColor = WidgetStateProperty.resolveWith<Color>(
              (states) =>
                  (index % 2 == 0) ? Colors.lightBlue[50]! : Colors.transparent,
            );

            return DataRow(
              color: backgroundColor, // Alternate row color
              cells: [
                DataCell(
                  SizedBox(
                    width: 120,
                    child: Text(project.pi),
                  ),
                ),
                DataCell(
                  SizedBox(width: 120, child: Text(project.shortName)),
                ),
                DataCell(
                  SizedBox(
                    width: 370,
                    child: Wrap(
                      spacing: 0,
                      runSpacing: 4,
                      children: [
                        Text(
                          project.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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

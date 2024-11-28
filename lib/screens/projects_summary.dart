import "package:flutter/material.dart";
import "package:uab_dashboard/models/project.dart";
import "package:uab_dashboard/services/firestore_service.dart";
import "package:uab_dashboard/widgets/active_projects_table.dart";
import "package:uab_dashboard/widgets/export_csv_button.dart";

class ProjectsSummaryScreen extends StatelessWidget {
  ProjectsSummaryScreen({super.key});

  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Project>>(
        future: _firebaseService.fetchProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No projects found'));
          }

          final projects = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Approved Projects",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16),
                      ExportCsvButton(projects: projects),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ActiveProjectsTable(projects: projects),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

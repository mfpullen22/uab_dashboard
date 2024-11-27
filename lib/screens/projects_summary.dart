import "package:flutter/material.dart";
import "package:uab_dashboard/models/project.dart";
import "package:uab_dashboard/services/firestore_service.dart";
import "package:uab_dashboard/widgets/projects_table.dart";
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
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Approved Projects",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ExportCsvButton(projects: projects),
                  ),
                ],
              ),
              Expanded(
                child: ProjectsTable(projects: projects),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uab_dashboard/models/project.dart';
import 'package:uab_dashboard/services/firestore_service.dart';
import 'package:uab_dashboard/widgets/active_projects_table.dart';
import 'package:uab_dashboard/widgets/export_csv_button.dart';
import 'package:uab_dashboard/widgets/pending_projects_table.dart';

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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Approved Projects",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ExportExcelButton(projects: projects),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ActiveProjectsTable(projects: projects),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Pending Projects",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: PendingProjectsTable(projects: projects),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

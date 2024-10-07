import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:uab_dashboard/widgets/add_project_dialog.dart";

class UserProjectsScreen extends StatelessWidget {
  const UserProjectsScreen({super.key});

  Future<List<String>> _getProjectTitles() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) {
      return [];
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (userDoc.docs.isNotEmpty) {
      final userData = userDoc.docs.first.data();

      final List projects = userData['projects'] ?? [];

      final projectTitles = projects
          .map<String>((project) => project['title'] as String)
          .toList();

      return projectTitles;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final projects =
        FirebaseFirestore.instance.collection("users").doc("email").toString();
    return FutureBuilder<List<String>>(
      future: _getProjectTitles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error fetching project titles"));
        }

        final projectTitles = snapshot.data ?? [];

        return Column(
          children: [
            ElevatedButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => const Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AddProjectDialog(),
                  ),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              child: const Text("Add a project"),
            ),
            if (projectTitles.isEmpty) const Text("No projects found"),
            for (final title in projectTitles) Text(title),
          ],
        );
      },
    );
  }
}


/*             ListView.builder(
              itemCount: projectTitles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(projectTitles[index]),
                );
              },
            ), */
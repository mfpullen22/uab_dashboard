// ignore_for_file: unnecessary_to_list_in_spreads

import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:uab_dashboard/models/project.dart";
import "package:uab_dashboard/widgets/project_card.dart";

class MyProjectsScreen extends StatefulWidget {
  const MyProjectsScreen({super.key});

  @override
  State<MyProjectsScreen> createState() => _MyProjectsScreenState();
}

class _MyProjectsScreenState extends State<MyProjectsScreen> {
  Future<List<Project>> _getUserProjects() async {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    if (userUid == null) {
      return [];
    }

    final projectDocs = await FirebaseFirestore.instance
        .collection('projects')
        .where('user_owner', isEqualTo: userUid)
        .get();

    return projectDocs.docs.map((doc) {
      final data = doc.data();
      return Project(
        docId: doc.id, // Get the document ID
        title: data['title'] as String,
        shortName: data['shortName'] as String,
        pi: data['pi'] as String,
        copis: List<String>.from(data['copis'] ?? []),
        description: data['description'] as String,
        status: data['status'] as String,
        type: data['type'] as String,
        subgroup: data['subgroup'] as String,
        sites: List<String>.from(data['sites'] ?? []),
        presentedDate: data['presentedDate'] as String,
        approvalSCDate: data['approvalSCDate'] as String,
        approvalCDCDate: data['approvalCDCDate'] as String,
        approvalIRBDate: data['approvalIRBDate'] as String,
        irbNumber: data['irbNumber'] as String,
        approvalContractDate: data['approvalContractDate'] as String,
        activatedDate: data['activatedDate'] as String,
        enrollment: Map<String, dynamic>.from(data['enrollment'] ?? {}),
        dataCollection: data['dataCollection'] as String,
        closeOut: data['closeOut'] as String,
        comments: Map<String, dynamic>.from(data['comments'] ?? {}),
        startDate: data['startDate'] as String,
        endDate: data['endDate'] as String,
        funding: Map<String, dynamic>.from(data['funding'] ?? {}),
        activeFilter: data['activeFilter'] as String,
        attachedFiles: (data['attachedFiles'] as List<dynamic>?)
                ?.map((fileMap) => Map<String, String>.from(fileMap as Map))
                .toList() ??
            [],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Project>>(
      future: _getUserProjects(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error fetching projects"));
        }

        final projects = snapshot.data ?? [];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: projects
                  .map(
                    (project) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: _buildProjectCard(project),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectCard(Project project) {
    return ProjectCard(
      project: project,
      onSubmit: (updatedProject) async {
        await FirebaseFirestore.instance
            .collection('projects')
            .doc(project.docId) // Use the document ID
            .update(updatedProject.toMap());
        setState(() {}); // Refresh UI
      },
    );
  }
}

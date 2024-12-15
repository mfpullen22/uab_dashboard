import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:uab_dashboard/models/project.dart";

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

class ProjectCard extends StatefulWidget {
  final Project project;
  final Function(Project updatedProject) onSubmit;

  const ProjectCard({super.key, required this.project, required this.onSubmit});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool isEditing = false;

  late TextEditingController shortNameController;
  late TextEditingController piController;
  late List<TextEditingController> copisControllers;
  late TextEditingController typeController;
  late List<TextEditingController> sitesControllers;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController irbNumberController;
  late TextEditingController enrolledController;
  late TextEditingController screenedController;
  late List<MapEntry<TextEditingController, TextEditingController>>
      fundingControllers;

  @override
  void initState() {
    super.initState();
    shortNameController = TextEditingController(text: widget.project.shortName);
    piController = TextEditingController(text: widget.project.pi);
    copisControllers = widget.project.copis
        .map((c) => TextEditingController(text: c))
        .toList();
    typeController = TextEditingController(text: widget.project.type);
    sitesControllers = widget.project.sites
        .map((s) => TextEditingController(text: s))
        .toList();
    startDateController = TextEditingController(text: widget.project.startDate);
    endDateController = TextEditingController(text: widget.project.endDate);
    irbNumberController = TextEditingController(text: widget.project.irbNumber);
    enrolledController = TextEditingController(
        text: widget.project.enrollment['enrolled']?.toString() ?? '');
    screenedController = TextEditingController(
        text: widget.project.enrollment['screened']?.toString() ?? '');
    fundingControllers = widget.project.funding.entries
        .map((e) => MapEntry(TextEditingController(text: e.key),
            TextEditingController(text: e.value.toString())))
        .toList();
  }

  @override
  void dispose() {
    shortNameController.dispose();
    piController.dispose();
    copisControllers.forEach((c) => c.dispose());
    typeController.dispose();
    sitesControllers.forEach((s) => s.dispose());
    startDateController.dispose();
    endDateController.dispose();
    irbNumberController.dispose();
    enrolledController.dispose();
    screenedController.dispose();
    fundingControllers.forEach((fc) {
      fc.key.dispose();
      fc.value.dispose();
    });
    super.dispose();
  }

  void _submitChanges() {
    final updatedProject = Project(
      docId: widget.project.docId,
      title: widget.project.title, // Title remains static
      shortName: shortNameController.text,
      pi: piController.text,
      copis: copisControllers.map((c) => c.text).toList(),
      description: widget.project.description,
      type: typeController.text,
      sites: sitesControllers.map((s) => s.text).toList(),
      startDate: startDateController.text,
      endDate: endDateController.text,
      irbNumber: irbNumberController.text,
      enrollment: {
        'enrolled': int.tryParse(enrolledController.text) ?? 0,
        'screened': int.tryParse(screenedController.text) ?? 0,
      },
      funding: {
        for (var entry in fundingControllers)
          entry.key.text: int.tryParse(entry.value.text) ?? 0,
      },
      status: widget.project.status,
      subgroup: widget.project.subgroup,
      presentedDate: widget.project.presentedDate,
      approvalSCDate: widget.project.approvalSCDate,
      approvalCDCDate: widget.project.approvalCDCDate,
      approvalIRBDate: widget.project.approvalIRBDate,
      approvalContractDate: widget.project.approvalContractDate,
      activatedDate: widget.project.activatedDate,
      dataCollection: widget.project.dataCollection,
      closeOut: widget.project.closeOut,
      comments: widget.project.comments,
      activeFilter: widget.project.activeFilter,
    );

    widget.onSubmit(updatedProject);
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue[50], // Light blue background
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Padding around content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.project.title,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            if (isEditing)
              Column(
                children: [
                  TextField(
                      controller: shortNameController,
                      decoration:
                          const InputDecoration(labelText: "Short Name")),
                  TextField(
                      controller: piController,
                      decoration: const InputDecoration(
                          labelText: "Principal Investigator")),
                  ...copisControllers.map(
                    (controller) => TextField(
                        controller: controller,
                        decoration: const InputDecoration(labelText: "Co-PI")),
                  ),
                  TextField(
                      controller: typeController,
                      decoration: const InputDecoration(labelText: "Type")),
                  ...sitesControllers.map(
                    (controller) => TextField(
                        controller: controller,
                        decoration: const InputDecoration(labelText: "Site")),
                  ),
                  TextField(
                      controller: startDateController,
                      decoration:
                          const InputDecoration(labelText: "Start Date")),
                  TextField(
                      controller: endDateController,
                      decoration: const InputDecoration(labelText: "End Date")),
                  TextField(
                      controller: irbNumberController,
                      decoration:
                          const InputDecoration(labelText: "IRB Number")),
                  TextField(
                      controller: enrolledController,
                      decoration: const InputDecoration(labelText: "Enrolled")),
                  TextField(
                      controller: screenedController,
                      decoration: const InputDecoration(labelText: "Screened")),
                  ...fundingControllers.map(
                    (entry) => Row(
                      children: [
                        Expanded(
                            child: TextField(
                                controller: entry.key,
                                decoration:
                                    const InputDecoration(labelText: "Key"))),
                        const SizedBox(width: 8),
                        Expanded(
                            child: TextField(
                                controller: entry.value,
                                decoration:
                                    const InputDecoration(labelText: "Value"))),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRichText("Short Name:", widget.project.shortName),
                  _buildRichText("Principal Investigator:", widget.project.pi),
                  _buildRichText("Co-PIs:", widget.project.copis.join(", ")),
                  _buildRichText("Status:", widget.project.status),
                  _buildRichText("Type:", widget.project.type),
                  _buildRichText("Subgroup:", widget.project.subgroup),
                  _buildRichText("Sites:", widget.project.sites.join(", ")),
                  _buildRichText("Description:", widget.project.description),
                  _buildRichText("Start Date:", widget.project.startDate),
                  _buildRichText("End Date:", widget.project.endDate),
                  _buildRichText(
                      "Presented Date:", widget.project.presentedDate),
                  _buildRichText(
                      "Approval (SC):", widget.project.approvalSCDate),
                  _buildRichText(
                      "Approval (CDC):", widget.project.approvalCDCDate),
                  _buildRichText(
                      "Approval (IRB):", widget.project.approvalIRBDate),
                  _buildRichText("IRB Number:", widget.project.irbNumber),
                  _buildRichText("Contract Approval:",
                      widget.project.approvalContractDate),
                  _buildRichText(
                      "Activated Date:", widget.project.activatedDate),
                  _buildRichText(
                      "Data Collection:", widget.project.dataCollection),
                  _buildRichText("Close Out:", widget.project.closeOut),
                  const Text("Enrollment:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                  _buildRichText("Enrolled:",
                      widget.project.enrollment['enrolled']?.toString() ?? "0"),
                  _buildRichText("Screened:",
                      widget.project.enrollment['screened']?.toString() ?? "0"),
                  const Text("Funding:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                  ...widget.project.funding.entries
                      .map((entry) => _buildRichText(
                          "${entry.key}:", entry.value.toString()))
                      .toList(),
                  const Text("Comments:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                  ...widget.project.comments.entries
                      .map((entry) => _buildRichText(
                          "${entry.key}:", entry.value.toString()))
                      .toList(),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  child: Text(isEditing ? "Cancel" : "Edit"),
                ),
                if (isEditing)
                  ElevatedButton(
                    onPressed: _submitChanges,
                    child: const Text("Save"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}







/* import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:uab_dashboard/models/project.dart";

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

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children:
                projects.map((project) => _buildProjectCard(project)).toList(),
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

class ProjectCard extends StatefulWidget {
  final Project project;
  final Function(Project updatedProject) onSubmit;

  const ProjectCard({super.key, required this.project, required this.onSubmit});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool isEditing = false;

  late TextEditingController titleController;
  late TextEditingController shortNameController;
  late TextEditingController piController;
  late List<TextEditingController> copisControllers;
  late TextEditingController typeController;
  late List<TextEditingController> sitesControllers;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController irbNumberController;
  late TextEditingController enrolledController;
  late TextEditingController screenedController;
  late List<MapEntry<TextEditingController, TextEditingController>>
      fundingControllers;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.project.title);
    shortNameController = TextEditingController(text: widget.project.shortName);
    piController = TextEditingController(text: widget.project.pi);
    copisControllers = widget.project.copis
        .map((c) => TextEditingController(text: c))
        .toList();
    typeController = TextEditingController(text: widget.project.type);
    sitesControllers = widget.project.sites
        .map((s) => TextEditingController(text: s))
        .toList();
    startDateController = TextEditingController(text: widget.project.startDate);
    endDateController = TextEditingController(text: widget.project.endDate);
    irbNumberController = TextEditingController(text: widget.project.irbNumber);
    enrolledController = TextEditingController(
        text: widget.project.enrollment['enrolled']?.toString() ?? '');
    screenedController = TextEditingController(
        text: widget.project.enrollment['screened']?.toString() ?? '');
    fundingControllers = widget.project.funding.entries
        .map((e) => MapEntry(TextEditingController(text: e.key),
            TextEditingController(text: e.value.toString())))
        .toList();
  }

  @override
  void dispose() {
    titleController.dispose();
    shortNameController.dispose();
    piController.dispose();
    copisControllers.forEach((c) => c.dispose());
    typeController.dispose();
    sitesControllers.forEach((s) => s.dispose());
    startDateController.dispose();
    endDateController.dispose();
    irbNumberController.dispose();
    enrolledController.dispose();
    screenedController.dispose();
    fundingControllers.forEach((fc) {
      fc.key.dispose();
      fc.value.dispose();
    });
    super.dispose();
  }

  void _submitChanges() {
    final updatedProject = Project(
      docId: widget.project.docId,
      title: titleController.text,
      shortName: shortNameController.text,
      pi: piController.text,
      copis: copisControllers.map((c) => c.text).toList(),
      description: widget.project.description,
      type: typeController.text,
      sites: sitesControllers.map((s) => s.text).toList(),
      startDate: startDateController.text,
      endDate: endDateController.text,
      irbNumber: irbNumberController.text,
      enrollment: {
        'enrolled': int.tryParse(enrolledController.text) ?? 0,
        'screened': int.tryParse(screenedController.text) ?? 0,
      },
      funding: {
        for (var entry in fundingControllers)
          entry.key.text: int.tryParse(entry.value.text) ?? 0,
      },
      status: widget.project.status,
      subgroup: widget.project.subgroup,
      presentedDate: widget.project.presentedDate,
      approvalSCDate: widget.project.approvalSCDate,
      approvalCDCDate: widget.project.approvalCDCDate,
      approvalIRBDate: widget.project.approvalIRBDate,
      approvalContractDate: widget.project.approvalContractDate,
      activatedDate: widget.project.activatedDate,
      dataCollection: widget.project.dataCollection,
      closeOut: widget.project.closeOut,
      comments: widget.project.comments,
      activeFilter: widget.project.activeFilter,
    );

    widget.onSubmit(updatedProject);
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isEditing
                ? TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Title"))
                : _buildRichText("Title:", widget.project.title),
            isEditing
                ? TextField(
                    controller: shortNameController,
                    decoration: const InputDecoration(labelText: "Short Name"))
                : _buildRichText("Short Name:", widget.project.shortName),
            isEditing
                ? TextField(
                    controller: piController,
                    decoration: const InputDecoration(
                        labelText: "Principal Investigator"))
                : _buildRichText("Principal Investigator:", widget.project.pi),
            if (isEditing)
              Column(
                children: copisControllers
                    .map((controller) => TextField(
                        controller: controller,
                        decoration: const InputDecoration(labelText: "Co-PI")))
                    .toList(),
              )
            else
              _buildRichText("Co-PIs:", widget.project.copis.join(", ")),
            _buildRichText("Status:", widget.project.status),
            isEditing
                ? TextField(
                    controller: typeController,
                    decoration: const InputDecoration(labelText: "Type"))
                : _buildRichText("Type:", widget.project.type),
            _buildRichText("Subgroup:", widget.project.subgroup),
            if (isEditing)
              Column(
                children: sitesControllers
                    .map((controller) => TextField(
                        controller: controller,
                        decoration: const InputDecoration(labelText: "Site")))
                    .toList(),
              )
            else
              _buildRichText("Sites:", widget.project.sites.join(", ")),
            _buildRichText("Description:", widget.project.description),
            isEditing
                ? TextField(
                    controller: startDateController,
                    decoration: const InputDecoration(labelText: "Start Date"))
                : _buildRichText("Start Date:", widget.project.startDate),
            isEditing
                ? TextField(
                    controller: endDateController,
                    decoration: const InputDecoration(labelText: "End Date"))
                : _buildRichText("End Date:", widget.project.endDate),
            _buildRichText("Presented Date:", widget.project.presentedDate),
            _buildRichText("Approval (SC):", widget.project.approvalSCDate),
            _buildRichText("Approval (CDC):", widget.project.approvalCDCDate),
            _buildRichText("Approval (IRB):", widget.project.approvalIRBDate),
            isEditing
                ? TextField(
                    controller: irbNumberController,
                    decoration: const InputDecoration(labelText: "IRB Number"))
                : _buildRichText("IRB Number:", widget.project.irbNumber),
            _buildRichText(
                "Contract Approval:", widget.project.approvalContractDate),
            _buildRichText("Activated Date:", widget.project.activatedDate),
            _buildRichText("Data Collection:", widget.project.dataCollection),
            _buildRichText("Close Out:", widget.project.closeOut),
            const Text("Enrollment:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline)),
            if (isEditing)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                      controller: enrolledController,
                      decoration: const InputDecoration(labelText: "Enrolled")),
                  TextField(
                      controller: screenedController,
                      decoration: const InputDecoration(labelText: "Screened")),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRichText("Enrolled:",
                      widget.project.enrollment['enrolled']?.toString() ?? "0"),
                  _buildRichText("Screened:",
                      widget.project.enrollment['screened']?.toString() ?? "0"),
                ],
              ),
            const Text("Funding:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline)),
            if (isEditing)
              Column(
                children: fundingControllers
                    .map(
                      (entry) => Row(
                        children: [
                          Expanded(
                              child: TextField(
                                  controller: entry.key,
                                  decoration:
                                      const InputDecoration(labelText: "Key"))),
                          const SizedBox(width: 8),
                          Expanded(
                              child: TextField(
                                  controller: entry.value,
                                  decoration: const InputDecoration(
                                      labelText: "Value"))),
                        ],
                      ),
                    )
                    .toList(),
              )
            else
              Column(
                children: widget.project.funding.entries
                    .map((e) => _buildRichText("${e.key}:", e.value.toString()))
                    .toList(),
              ),
            const Text("Comments:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.project.comments.entries.map((comment) {
                return _buildRichText(comment.key, comment.value);
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  child: Text(isEditing ? "Cancel" : "Edit"),
                ),
                if (isEditing)
                  ElevatedButton(
                    onPressed: _submitChanges,
                    child: const Text("Save"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
} */



/* import "package:accordion/accordion.dart";
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:uab_dashboard/models/project.dart";
import "package:uab_dashboard/widgets/edit_project_dialog.dart";

class MyProjectsScreen extends StatelessWidget {
  const MyProjectsScreen({super.key});

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

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Accordion(
            children: projects.map((project) {
              return AccordionSection(
                header: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    project.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 24.0, color: Colors.white),
                  ),
                ),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRichText("Principal Investigator:", project.pi),
                      _buildRichText("Short Name:", project.shortName),
                      _buildRichText("Co-PIs:", project.copis.join(", ")),
                      _buildRichText("Status:", project.status),
                      _buildRichText("Type:", project.type),
                      _buildRichText("Subgroup:", project.subgroup),
                      _buildRichText("Sites:", project.sites.join(", ")),
                      _buildRichText("Description:", project.description),
                      _buildRichText("Start Date:", project.startDate),
                      _buildRichText("End Date:", project.endDate),
                      _buildRichText("Presented Date:", project.presentedDate),
                      _buildRichText("Approval (SC):", project.approvalSCDate),
                      _buildRichText(
                          "Approval (CDC):", project.approvalCDCDate),
                      _buildRichText(
                          "Approval (IRB):", project.approvalIRBDate),
                      _buildRichText("IRB Number:", project.irbNumber),
                      _buildRichText(
                          "Contract Approval:", project.approvalContractDate),
                      _buildRichText("Activated Date:", project.activatedDate),
                      _buildRichText(
                          "Data Collection:", project.dataCollection),
                      _buildRichText("Close Out:", project.closeOut),
                      const Text(
                        "Enrollment:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      _buildEnrollmentDisplay(project.enrollment),
                      const Text(
                        "Comments:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      _buildCommentsDisplay(project.comments),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                EditProjectDialog(project: project),
                          );
                        },
                        child: const Text("Edit Project"),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

// Helper method to create styled RichText widgets
Widget _buildRichText(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(
            text: " $value",
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    ),
  );
}

// Helper to display the enrollment map with capitalized keys and indentation
Widget _buildEnrollmentDisplay(Map<String, dynamic> enrollment) {
  const keyMap = {'enrolled': 'Enrolled', 'screened': 'Screened'};

  return Padding(
    padding: const EdgeInsets.only(left: 16.0), // Add indentation
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: enrollment.entries.map((entry) {
        final displayKey = keyMap[entry.key] ?? entry.key;
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "$displayKey: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "${entry.value}",
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ),
  );
}

// Helper to display comments sorted by descending date with indentation
Widget _buildCommentsDisplay(Map<String, dynamic> comments) {
  final sortedComments = comments.entries.toList()
    ..sort((a, b) {
      final dateA = _parseDate(a.key);
      final dateB = _parseDate(b.key);
      return dateB.compareTo(dateA);
    });

  return Padding(
    padding: const EdgeInsets.only(left: 16.0), // Add indentation
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedComments.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "${entry.key}: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "${entry.value}",
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ),
  );
}

// Helper to parse MM/DD/YYYY formatted dates
DateTime _parseDate(String dateString) {
  final parts = dateString.split('/');
  return DateTime(
    int.parse(parts[2]), // Year
    int.parse(parts[0]), // Month
    int.parse(parts[1]), // Day
  );
}
 */
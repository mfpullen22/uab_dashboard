// ignore_for_file: use_build_context_synchronously
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uab_dashboard/screens/my_projects.dart';

class SubmitProjectScreen extends StatefulWidget {
  final Function(Widget page, String title) selectPage; // Callback to navigate

  const SubmitProjectScreen({super.key, required this.selectPage});

  @override
  State<SubmitProjectScreen> createState() => _SubmitProjectScreenState();
}

class _SubmitProjectScreenState extends State<SubmitProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for all fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController shortNameController = TextEditingController();
  final TextEditingController piController = TextEditingController();
  final List<TextEditingController> copisControllers = [];
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController subgroupController = TextEditingController();
  final List<TextEditingController> sitesControllers = [];
  final TextEditingController presentedDateController = TextEditingController();
  final TextEditingController approvalSCDateController =
      TextEditingController();
  final TextEditingController approvalCDCDateController =
      TextEditingController();
  final TextEditingController approvalIRBDateController =
      TextEditingController();
  final TextEditingController irbNumberController = TextEditingController();
  final TextEditingController approvalContractDateController =
      TextEditingController();
  final TextEditingController activatedDateController = TextEditingController();
  final TextEditingController dataCollectionController =
      TextEditingController();
  final TextEditingController closeOutController = TextEditingController();
  final TextEditingController enrolledController = TextEditingController();
  final TextEditingController screenedController = TextEditingController();
  final List<MapEntry<TextEditingController, TextEditingController>>
      fundingControllers = [];

  /// List of files the user has added. Each item: { "filename": string, "downloadUrl": string }
  List<Map<String, String>> attachedFiles = [];

  @override
  void dispose() {
    // Dispose all controllers
    titleController.dispose();
    shortNameController.dispose();
    piController.dispose();
    descriptionController.dispose();
    statusController.dispose();
    typeController.dispose();
    subgroupController.dispose();
    for (var c in copisControllers) {
      c.dispose();
    }
    for (var c in sitesControllers) {
      c.dispose();
    }
    presentedDateController.dispose();
    approvalSCDateController.dispose();
    approvalCDCDateController.dispose();
    approvalIRBDateController.dispose();
    irbNumberController.dispose();
    approvalContractDateController.dispose();
    activatedDateController.dispose();
    dataCollectionController.dispose();
    closeOutController.dispose();
    enrolledController.dispose();
    screenedController.dispose();
    for (var fc in fundingControllers) {
      fc.key.dispose();
      fc.value.dispose();
    }
    super.dispose();
  }

  /// Pick a file, upload it to Firebase Storage, and store the download URL in [attachedFiles].
  Future<void> _addFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final fileName = file.name;
      final fileBytes = file.bytes; // Raw bytes of the file

      if (fileBytes != null) {
        try {
          // Upload to Firebase Storage
          final storage = firebase_storage.FirebaseStorage.instanceFor(
            bucket: 'uab-dashboard.firebasestorage.app',
          );
          final storageRef = storage
              .ref()
              .child('project_files')
              .child('${DateTime.now().millisecondsSinceEpoch}_$fileName');

          // Upload file bytes
          final uploadTask = await storageRef.putData(fileBytes);
          final downloadUrl = await uploadTask.ref.getDownloadURL();

          // Add to attachedFiles list
          setState(() {
            attachedFiles.add({
              "filename": fileName,
              "downloadUrl": downloadUrl,
            });
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to upload file: $e")),
          );
        }
      }
    }
  }

  /// Confirm and remove a file from [attachedFiles]. Optionally, delete from Storage as well.
  Future<void> _removeFile(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Remove File"),
        content: const Text("Are you sure you want to remove this file?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Remove"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final fileToRemove = attachedFiles[index];
      setState(() {
        attachedFiles.removeAt(index);
      });

      // Optional: If you want to remove the file from Firebase Storage too
      try {
        final fileRef = firebase_storage.FirebaseStorage.instance
            .refFromURL(fileToRemove["downloadUrl"]!);
        await fileRef.delete();
      } catch (e) {
        // If deletion from storage fails, handle accordingly (log it, etc.)
      }
    }
  }

  Future<void> _submitProject() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("You must be logged in to submit a project")),
        );
        return;
      }

      final newProject = {
        "title": titleController.text,
        "shortName": shortNameController.text,
        "pi": piController.text,
        "copis": copisControllers.map((c) => c.text).toList(),
        "description": descriptionController.text,
        "status": statusController.text,
        "type": typeController.text,
        "subgroup": subgroupController.text,
        "sites": sitesControllers.map((s) => s.text).toList(),
        "presentedDate": presentedDateController.text,
        "approvalSCDate": approvalSCDateController.text,
        "approvalCDCDate": approvalCDCDateController.text,
        "approvalIRBDate": approvalIRBDateController.text,
        "irbNumber": irbNumberController.text,
        "approvalContractDate": approvalContractDateController.text,
        "activatedDate": activatedDateController.text,
        "dataCollection": dataCollectionController.text,
        "closeOut": closeOutController.text,
        "enrollment": {
          "enrolled": int.tryParse(enrolledController.text) ?? 0,
          "screened": int.tryParse(screenedController.text) ?? 0,
        },
        "funding": {
          for (var entry in fundingControllers)
            entry.key.text: int.tryParse(entry.value.text) ?? 0,
        },
        "comments": {}, // Default to empty map
        "startDate": presentedDateController.text,
        "endDate": closeOutController.text,
        "activeFilter": "pending",
        "user_owner": user.uid,
        // Instead of storing base64 content, we store {filename, downloadUrl}
        "attachedFiles": attachedFiles,
      };

      try {
        await FirebaseFirestore.instance.collection('projects').add(newProject);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Project submitted successfully")),
        );
        widget.selectPage(const MyProjectsScreen(), "My Projects");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error submitting project: $e")),
        );
      }
    }
  }

  void _addCoPiField() {
    setState(() {
      copisControllers.add(TextEditingController());
    });
  }

  void _addSiteField() {
    setState(() {
      sitesControllers.add(TextEditingController());
    });
  }

  void _addFundingField() {
    setState(() {
      fundingControllers
          .add(MapEntry(TextEditingController(), TextEditingController()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit a New Project")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: shortNameController,
                decoration: const InputDecoration(labelText: "Short Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: piController,
                decoration:
                    const InputDecoration(labelText: "Principal Investigator"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              const Text("Co-PIs"),
              ...copisControllers.map(
                (controller) => TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: "Co-PI"),
                ),
              ),
              TextButton(
                  onPressed: _addCoPiField, child: const Text("Add Co-PI")),
              TextFormField(
                controller: typeController,
                decoration: const InputDecoration(
                    labelText: "Study Type (Prospective, Retrospective, etc.)"),
              ),
              const SizedBox(height: 8),
              const Text("Sites"),
              ...sitesControllers.map(
                (controller) => TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: "Site"),
                ),
              ),
              TextButton(
                  onPressed: _addSiteField, child: const Text("Add Site")),
              const SizedBox(height: 8),
              TextFormField(
                controller: irbNumberController,
                decoration: const InputDecoration(
                    labelText: "IRB number (if applicable)"),
              ),
              const SizedBox(height: 8),
              const Text("Current Funding (if any)"),
              ...fundingControllers.map(
                (entry) => Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: entry.key,
                        decoration: const InputDecoration(labelText: "Source"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: entry.value,
                        decoration: const InputDecoration(labelText: "Amount"),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                  onPressed: _addFundingField,
                  child: const Text("Add Funding Source")),
              const SizedBox(height: 8),
              // Display attached files
              for (int i = 0; i < attachedFiles.length; i++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child:
                          Text(attachedFiles[i]["filename"] ?? "Unnamed File"),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeFile(i),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _addFile,
                    child: const Text("Add File"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitProject,
                    child: const Text("Submit Project"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

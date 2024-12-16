import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:uab_dashboard/models/project.dart";

class EditProjectDialog extends StatefulWidget {
  final Project project;

  const EditProjectDialog({super.key, required this.project});

  @override
  State<EditProjectDialog> createState() => _EditProjectDialogState();
}

class _EditProjectDialogState extends State<EditProjectDialog> {
  late TextEditingController titleController;
  late TextEditingController shortNameController;
  late TextEditingController piController;
  late List<TextEditingController> copisControllers;
  late TextEditingController descriptionController;
  late List<TextEditingController> sitesControllers;
  late TextEditingController enrolledController;
  late TextEditingController screenedController;
  late TextEditingController fundingController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.project.title);
    shortNameController = TextEditingController(text: widget.project.shortName);
    piController = TextEditingController(text: widget.project.pi);
    copisControllers = widget.project.copis
        .map((copi) => TextEditingController(text: copi))
        .toList();
    descriptionController =
        TextEditingController(text: widget.project.description);
    sitesControllers = widget.project.sites
        .map((site) => TextEditingController(text: site))
        .toList();
    enrolledController = TextEditingController(
        text: widget.project.enrollment['enrolled'].toString());
    screenedController = TextEditingController(
        text: widget.project.enrollment['screened'].toString());
    fundingController = TextEditingController(
        text: widget.project.funding['amount']?.toString() ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    shortNameController.dispose();
    piController.dispose();
    for (var controller in copisControllers) {
      controller.dispose();
    }
    descriptionController.dispose();
    for (var controller in sitesControllers) {
      controller.dispose();
    }
    enrolledController.dispose();
    screenedController.dispose();
    fundingController.dispose();
    super.dispose();
  }

  void _updateProject() async {
    final updatedData = {
      'title': titleController.text,
      'shortName': shortNameController.text,
      'pi': piController.text,
      'copis': copisControllers.map((c) => c.text).toList(),
      'description': descriptionController.text,
      'sites': sitesControllers.map((c) => c.text).toList(),
      'enrollment': {
        'enrolled': int.tryParse(enrolledController.text) ?? 0,
        'screened': int.tryParse(screenedController.text) ?? 0,
      },
      'funding': {
        'amount': int.tryParse(fundingController.text) ?? 0,
      },
    };

    await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.project.title) // Assuming the project title is unique
        .update(updatedData);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: FocusScope(
        autofocus: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: shortNameController,
                  decoration: const InputDecoration(labelText: "Short Name"),
                ),
                TextField(
                  controller: piController,
                  decoration: const InputDecoration(
                      labelText: "Principal Investigator"),
                ),
                const Text("Co-PIs:"),
                for (var controller in copisControllers)
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: "Co-PI"),
                  ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      copisControllers.add(TextEditingController());
                    });
                  },
                  child: const Text("Add Co-PI"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                const Text("Sites:"),
                for (var controller in sitesControllers)
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: "Site"),
                  ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      sitesControllers.add(TextEditingController());
                    });
                  },
                  child: const Text("Add Site"),
                ),
                TextField(
                  controller: enrolledController,
                  decoration: const InputDecoration(labelText: "Enrolled"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: screenedController,
                  decoration: const InputDecoration(labelText: "Screened"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: fundingController,
                  decoration:
                      const InputDecoration(labelText: "Funding Amount"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: _updateProject,
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

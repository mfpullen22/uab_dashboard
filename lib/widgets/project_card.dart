// ignore_for_file: unnecessary_to_list_in_spreads

import 'dart:html' as html;
import "package:flutter/material.dart";
import "package:uab_dashboard/models/project.dart";

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
    for (var c in copisControllers) {
      c.dispose();
    }
    typeController.dispose();
    for (var s in sitesControllers) {
      s.dispose();
    }
    startDateController.dispose();
    endDateController.dispose();
    irbNumberController.dispose();
    enrolledController.dispose();
    screenedController.dispose();
    for (var fc in fundingControllers) {
      fc.key.dispose();
      fc.value.dispose();
    }
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

  void _downloadFile(String downloadUrl, String fileName) {
    final anchor = html.AnchorElement(href: downloadUrl)
      ..download = fileName // This forces the browser to download the file
      ..style.display = 'none';
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
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
                  if (widget.project.attachedFiles.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      "Files:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.project.attachedFiles.map((fileInfo) {
                        final fileName = fileInfo["filename"] ?? "Unnamed File";
                        final downloadUrl = fileInfo["downloadUrl"] ?? "#";

                        return InkWell(
                          onTap: () => _downloadFile(downloadUrl, fileName),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              fileName,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ]
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

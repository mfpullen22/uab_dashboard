import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({super.key});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final _form = GlobalKey<FormState>();
  String? _enteredTitle;
  String? _enteredPI;
  String? _enteredDescription;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _fundingUAB;
  String? _fundingNIH;
  String? _fundingCDC;
  String? _fundingInst;
  String? _fundingInd;
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MM-dd-yyyy'); // Date format

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _startDateController.text =
            _dateFormatter.format(picked); // Update controller
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _endDateController.text =
            _dateFormatter.format(picked); // Update controller
      });
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _submitProject() async {
    if (!_form.currentState!.validate()) return;

    _form.currentState!.save();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user logged in')),
      );
      return;
    }

    final userEmail = user.email;
    print(userEmail);

    final projectData = {
      "title": _enteredTitle,
      "pi": _enteredPI,
      "description": _enteredDescription,
      "startDate": _startDate,
      "endDate": _endDate,
      "funding": {
        "uab": _fundingUAB,
        "nih": _fundingNIH,
        "cdc": _fundingCDC,
        "institutional": _fundingInst,
        "industry": _fundingInd,
      },
    };

    try {
      final userDocQuery = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: userEmail)
          .limit(1)
          .get();

      print("Fetched document for user: ${userDocQuery.docs.first.id}");

      if (userDocQuery.docs.isNotEmpty) {
        final docRef = userDocQuery.docs.first.reference;

        // Append the new project data to the "projects" array
        await docRef.update({
          "projects": FieldValue.arrayUnion([projectData]) // Append the project
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project added successfully!')),
        );

        Navigator.of(context).pop(); // Close the dialog
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found in Firestore')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding project: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _form,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add your project details below",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 20.0, color: Colors.black),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Project Title",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a project title.";
                      }
                      return null;
                    },
                    onSaved: (value) => _enteredTitle = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Project PI",
                    ),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a Project PI.";
                      }
                      return null;
                    },
                    onSaved: (value) => _enteredPI = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Brief project description",
                    ),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Re-enter your password.";
                      }
                      return null;
                    },
                    onSaved: (value) => _enteredDescription = value!,
                  ),
                  GestureDetector(
                    onTap: () => _selectStartDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller:
                            _startDateController, // Controller for start date
                        decoration: const InputDecoration(
                          labelText: "Project start date",
                        ),
                        validator: (value) {
                          if (_startDate == null) {
                            return "Please select a project start date.";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectEndDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller:
                            _endDateController, // Controller for end date
                        decoration: const InputDecoration(
                          labelText: "Projected end date",
                        ),
                        validator: (value) {
                          if (_endDate == null) {
                            return "Please select a project end date.";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Funding",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Text("UAB"),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Amount",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter the amount.";
                            }
                            return null;
                          },
                          onSaved: (value) => _fundingUAB = value!,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Text("NIH"),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Amount",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter the amount.";
                            }
                            return null;
                          },
                          onSaved: (value) => _fundingNIH = value!,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Text("CDC"),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Amount",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter the amount.";
                            }
                            return null;
                          },
                          onSaved: (value) => _fundingCDC = value!,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Text("Institutional"),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Amount",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter the amount.";
                            }
                            return null;
                          },
                          onSaved: (value) => _fundingInst = value!,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Text("Industry"),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Amount",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter the amount.";
                            }
                            return null;
                          },
                          onSaved: (value) => _fundingInd = value!,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_form.currentState!.validate()) {
                            _form.currentState!.save();
                            Navigator.of(context).pop();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ),
                        child: const Text("Add Project"),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.red),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                        child: const Text("Cancel"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

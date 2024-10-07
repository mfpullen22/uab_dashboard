import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uab_dashboard/hub.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _form = GlobalKey<FormState>();
  var _firstName = "";
  var _lastName = "";
  var _credentials = "";
  var _organization = "";

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    try {
      // Using the UID as the document ID to ensure that user data is stored properly
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          "first_name": _firstName,
          "last_name": _lastName,
          "credentials": _credentials,
          "organization": _organization,
        });

        // Navigate to the HubScreen after successfully updating profile
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HubScreen(),
            ),
          );
        }
      }
    } on FirebaseException catch (error) {
      if (mounted) {
        String errorMessage;

        switch (error.code) {
          case 'permission-denied':
            errorMessage = "You do not have permission to perform this action.";
            break;
          case 'unavailable':
            errorMessage =
                "Firestore is currently unavailable. Please try again later.";
            break;
          default:
            errorMessage = error.message ?? "An unknown error occurred.";
            break;
        }

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An unexpected error occurred. Please try again."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(40),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Form(
            key: _form,
            child: Column(
              children: [
                Text(
                  "Edit your profile below",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 24.0, color: Colors.black),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'First Name'),
                  onSaved: (value) {
                    _firstName = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  onSaved: (value) {
                    _lastName = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Credentials (MD, DO, PhD, etc.)'),
                  onSaved: (value) {
                    _credentials = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your credentials';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Organization (University, Company)'),
                  onSaved: (value) {
                    _organization = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your organization';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                        Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                  onPressed: _submit,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

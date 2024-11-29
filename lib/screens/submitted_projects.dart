import "package:flutter/material.dart";

class SubmittedProjectsScreen extends StatelessWidget {
  const SubmittedProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "This is the Submitted Projects screen",
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 24.0, color: Colors.black),
      ),
    );
  }
}

import "package:flutter/material.dart";

class CompletedProjectsScreen extends StatelessWidget {
  const CompletedProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "This is the Completed Projects screen",
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 24.0, color: Colors.black),
      ),
    );
  }
}

import "package:flutter/material.dart";

class ProjectsSummaryScreen extends StatelessWidget {
  const ProjectsSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "This is the Projects Summary screen",
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 24.0, color: Colors.black),
      ),
    );
  }
}

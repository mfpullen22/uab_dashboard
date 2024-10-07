import "package:flutter/material.dart";

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "This is the Documents screen",
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 24.0, color: Colors.black),
      ),
    );
  }
}

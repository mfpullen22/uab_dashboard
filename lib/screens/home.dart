import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to the Dashboard",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "This dashboard serves as a hub for all projects funded through the UAB CDC U01 grant.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              color: Colors.blue[50], // Placeholder for additional content
              child: const Center(
                child: Text("More Content Here"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/* import "package:flutter/material.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              Scaffold.of(context)
                  .appBarMaxHeight!, // Ensure it takes full height
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16), // Space under the AppBar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "This dashboard serves as a hub for all projects funded through the UAB CDC U01 grant.",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 24.0, color: Colors.black),
                ),
              ),

              Expanded(
                child:
                    Container(), // Placeholder to push the content if there's little content
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 */
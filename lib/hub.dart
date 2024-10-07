import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:uab_dashboard/screens/active_projects.dart";
import "package:uab_dashboard/screens/completed_projects.dart";
import "package:uab_dashboard/screens/documents.dart";
import "package:uab_dashboard/screens/home.dart";
import "package:uab_dashboard/screens/profile.dart";
import "package:uab_dashboard/screens/user_projects.dart";

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  Widget _activePage = const HomeScreen();
  String _activePageTitle = "Home";

  void _selectPage(Widget page, String title) {
    setState(() {
      _activePage = page;
      _activePageTitle = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width * 0.5),
            Text(_activePageTitle)
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _selectPage(const ProfileScreen(), "User Profile");
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      _selectPage(const HomeScreen(), "Home");
                    },
                    child: Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: _activePageTitle == "Home"
                            ? FontWeight.bold
                            : FontWeight.normal,
                        decoration: _activePageTitle == "Home"
                            ? TextDecoration.underline
                            : null,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      _selectPage(
                          const ActiveProjectsScreen(), "Active Projects");
                    },
                    child: Text(
                      "Active Projects",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: _activePageTitle == "Active Projects"
                            ? FontWeight.bold
                            : FontWeight.normal,
                        decoration: _activePageTitle == "Active Projects"
                            ? TextDecoration.underline
                            : null,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      _selectPage(const CompletedProjectsScreen(),
                          "Completed Projects");
                    },
                    child: Text(
                      "Completed Projects",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: _activePageTitle == "Completed Projects"
                            ? FontWeight.bold
                            : FontWeight.normal,
                        decoration: _activePageTitle == "Completed Projects"
                            ? TextDecoration.underline
                            : null,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      _selectPage(const DocumentsScreen(), "Documents");
                    },
                    child: Text(
                      "Documents",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: _activePageTitle == "Documents"
                            ? FontWeight.bold
                            : FontWeight.normal,
                        decoration: _activePageTitle == "Documents"
                            ? TextDecoration.underline
                            : null,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      _selectPage(
                          const UserProjectsScreen(), "Add/Edit a Project");
                    },
                    child: Text(
                      "Add/Edit a Project",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: _activePageTitle == "Add/Edit a Project"
                            ? FontWeight.bold
                            : FontWeight.normal,
                        decoration: _activePageTitle == "Add/Edit a Project"
                            ? TextDecoration.underline
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Vertical Divider
          Container(
            width: 1, // Width of the vertical line
            height: double.infinity, // Makes the line stretch the full height
            color: Colors.grey, // Color of the vertical line
          ),
          Expanded(
            child: _activePage,
          ),
        ],
      ),
    );
  }
}

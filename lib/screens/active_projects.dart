import 'package:flutter/material.dart';
import 'package:uab_dashboard/widgets/accordion_active_projects.dart';

class ActiveProjectsScreen extends StatelessWidget {
  const ActiveProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: AccordionActiveProjects());
  }
}

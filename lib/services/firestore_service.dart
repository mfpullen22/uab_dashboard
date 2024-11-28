import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uab_dashboard/models/project.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Project>> fetchProjects() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('projects').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Project(
          title: data['title'],
          shortName: data['shortName'],
          pi: data['pi'],
          copis: List<String>.from(data['copis'] ?? []),
          status: data['status'],
          type: data['type'],
          subgroup: data['subgroup'],
          sites: List<String>.from(data['sites'] ?? []),
          description: data['description'],
          presentedDate: data['presentedDate'],
          approvalSCDate: data['approvalSCDate'],
          approvalCDCDate: data['approvalCDCDate'],
          approvalIRBDate: data['approvalIRBDate'],
          irbNumber: data['irbNumber'],
          approvalContractDate: data['approvalContractDate'],
          activatedDate: data['activatedDate'],
          enrollment: data['enrollment'] ?? {},
          dataCollection: data['dataCollection'],
          closeOut: data['closeOut'],
          comments: data['comments'] ?? {},
          startDate: data['startDate'],
          endDate: data['endDate'],
          funding: Map<String, dynamic>.from(data['funding'] ?? {}),
          activeFilter: data['activeFilter'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching projects: $e');
      return [];
    }
  }
}

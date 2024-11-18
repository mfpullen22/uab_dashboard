class Project {
  const Project({
    required this.title,
    required this.shortName,
    required this.pi,
    required this.description,
    required this.presentedDate,
    required this.approvalSCDate,
    required this.approvalCDCDate,
    required this.approvalIRBDate,
    required this.irbNumber,
    required this.approvalContractDate,
    required this.activatedDate,
    required this.enrollment,
    required this.dataCollection,
    required this.closeOut,
    required this.comments,
    required this.startDate,
    required this.endDate,
    required this.funding,
  });

  final String title;
  final String shortName;
  final String pi;
  final String description;
  final String presentedDate;
  final String approvalSCDate;
  final String approvalCDCDate;
  final String approvalIRBDate;
  final String irbNumber;
  final String approvalContractDate;
  final String activatedDate;
  final Map<String, dynamic> enrollment;
  final String dataCollection;
  final String closeOut;
  final Map<String, dynamic> comments;
  final DateTime startDate;
  final DateTime endDate;
  final List<Map<String, dynamic>> funding;
}

class Project {
  const Project({
    required this.docId,
    required this.title,
    required this.shortName,
    required this.pi,
    required this.copis,
    required this.status,
    required this.type,
    required this.subgroup,
    required this.sites,
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
    required this.activeFilter,
    this.attachedFiles = const [],
  });

  final String docId;
  final String title;
  final String shortName;
  final String pi;
  final List<String> copis;
  final String description;
  final String status;
  final String type;
  final String subgroup;
  final List<String> sites;
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
  final String startDate;
  final String endDate;
  final Map<String, dynamic> funding;
  final String activeFilter;
  final List<Map<String, String>> attachedFiles;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'shortName': shortName,
      'pi': pi,
      'copis': copis,
      'description': description,
      'status': status,
      'type': type,
      'subgroup': subgroup,
      'sites': sites,
      'presentedDate': presentedDate,
      'approvalSCDate': approvalSCDate,
      'approvalCDCDate': approvalCDCDate,
      'approvalIRBDate': approvalIRBDate,
      'irbNumber': irbNumber,
      'approvalContractDate': approvalContractDate,
      'activatedDate': activatedDate,
      'enrollment': enrollment,
      'dataCollection': dataCollection,
      'closeOut': closeOut,
      'comments': comments,
      'startDate': startDate,
      'endDate': endDate,
      'funding': funding,
      'activeFilter': activeFilter,
    };
  }
}

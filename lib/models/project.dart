class Project {
  const Project({
    required this.title,
    required this.pi,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.funding,
  });

  final String title;
  final String pi;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<Map<String, dynamic>> funding;
}

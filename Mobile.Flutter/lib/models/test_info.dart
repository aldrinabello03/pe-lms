class TestInfo {
  final String key;
  final String title;
  final String purpose;
  final String? formula;
  final List<String> equipment;
  final List<String> procedureTester;
  final List<String> procedurePartner;
  final String scoring;
  final String nextPage;
  final String previousPage;
  final String? videoUrl;

  const TestInfo({
    required this.key,
    required this.title,
    required this.purpose,
    this.formula,
    required this.equipment,
    required this.procedureTester,
    required this.procedurePartner,
    required this.scoring,
    required this.nextPage,
    required this.previousPage,
    this.videoUrl,
  });

  factory TestInfo.fromJson(Map<String, dynamic> json) {
    List<String> parseStringList(dynamic value) {
      if (value == null) return [];
      if (value is List) return value.map((e) => e.toString()).toList();
      return [value.toString()];
    }

    return TestInfo(
      key: json['key'] as String? ?? '',
      title: json['title'] as String? ?? '',
      purpose: json['purpose'] as String? ?? '',
      formula: json['formula'] as String?,
      equipment: parseStringList(json['equipment']),
      procedureTester: parseStringList(json['procedureTester']),
      procedurePartner: parseStringList(json['procedurePartner']),
      scoring: json['scoring'] as String? ?? '',
      nextPage: json['nextPage'] as String? ?? '',
      previousPage: json['previousPage'] as String? ?? '',
      videoUrl: json['videoUrl'] as String?,
    );
  }
}

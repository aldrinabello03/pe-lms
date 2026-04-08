class StudentDashboard {
  final String studentName;
  final BmiResult? bmi;
  final ScoreResult? balance;
  final ScoreResult? stepTest;
  final ScoreResult? juggling;
  final ScoreResult? zipper;
  final SitReachResult? sitAndReach;
  final ScoreResult? pushUp;
  final ScoreResult? plank;
  final LongJumpResult? longJump;
  final StickDropResult? stickDrop;
  final ScoreResult? sprint;

  const StudentDashboard({
    required this.studentName,
    this.bmi,
    this.balance,
    this.stepTest,
    this.juggling,
    this.zipper,
    this.sitAndReach,
    this.pushUp,
    this.plank,
    this.longJump,
    this.stickDrop,
    this.sprint,
  });

  factory StudentDashboard.fromJson(Map<String, dynamic> json) {
    return StudentDashboard(
      studentName: json['studentName'] as String? ?? '',
      bmi: json['bmi'] != null
          ? BmiResult.fromJson(json['bmi'] as Map<String, dynamic>)
          : null,
      balance: json['balance'] != null
          ? ScoreResult.fromJson(json['balance'] as Map<String, dynamic>)
          : null,
      stepTest: json['stepTest'] != null
          ? ScoreResult.fromJson(json['stepTest'] as Map<String, dynamic>)
          : null,
      juggling: json['juggling'] != null
          ? ScoreResult.fromJson(json['juggling'] as Map<String, dynamic>)
          : null,
      zipper: json['zipper'] != null
          ? ScoreResult.fromJson(json['zipper'] as Map<String, dynamic>)
          : null,
      sitAndReach: json['sitAndReach'] != null
          ? SitReachResult.fromJson(
              json['sitAndReach'] as Map<String, dynamic>)
          : null,
      pushUp: json['pushUp'] != null
          ? ScoreResult.fromJson(json['pushUp'] as Map<String, dynamic>)
          : null,
      plank: json['plank'] != null
          ? ScoreResult.fromJson(json['plank'] as Map<String, dynamic>)
          : null,
      longJump: json['longJump'] != null
          ? LongJumpResult.fromJson(json['longJump'] as Map<String, dynamic>)
          : null,
      stickDrop: json['stickDrop'] != null
          ? StickDropResult.fromJson(
              json['stickDrop'] as Map<String, dynamic>)
          : null,
      sprint: json['sprint'] != null
          ? ScoreResult.fromJson(json['sprint'] as Map<String, dynamic>)
          : null,
    );
  }
}

class BmiResult {
  final double? height;
  final double? weight;
  final double? bmiValue;
  final String? classification;

  const BmiResult({this.height, this.weight, this.bmiValue, this.classification});

  factory BmiResult.fromJson(Map<String, dynamic> json) {
    return BmiResult(
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      bmiValue: (json['bmiValue'] as num?)?.toDouble(),
      classification: json['classification'] as String?,
    );
  }
}

class ScoreResult {
  final dynamic value;
  final dynamic value2;
  final String? interpretation;

  const ScoreResult({this.value, this.value2, this.interpretation});

  factory ScoreResult.fromJson(Map<String, dynamic> json) {
    return ScoreResult(
      value: json['value'],
      value2: json['value2'],
      interpretation: json['interpretation'] as String?,
    );
  }
}

class SitReachResult {
  final double? try1;
  final double? try2;
  final double? bestScore;
  final String? interpretation;

  const SitReachResult({this.try1, this.try2, this.bestScore, this.interpretation});

  factory SitReachResult.fromJson(Map<String, dynamic> json) {
    return SitReachResult(
      try1: (json['try1'] as num?)?.toDouble(),
      try2: (json['try2'] as num?)?.toDouble(),
      bestScore: (json['bestScore'] as num?)?.toDouble(),
      interpretation: json['interpretation'] as String?,
    );
  }
}

class LongJumpResult {
  final int? try1;
  final int? try2;
  final String? interpretation;

  const LongJumpResult({this.try1, this.try2, this.interpretation});

  factory LongJumpResult.fromJson(Map<String, dynamic> json) {
    return LongJumpResult(
      try1: json['try1'] as int?,
      try2: json['try2'] as int?,
      interpretation: json['interpretation'] as String?,
    );
  }
}

class StickDropResult {
  final double? drop1;
  final double? drop2;
  final double? drop3;
  final String? interpretation;

  const StickDropResult({this.drop1, this.drop2, this.drop3, this.interpretation});

  factory StickDropResult.fromJson(Map<String, dynamic> json) {
    return StickDropResult(
      drop1: (json['drop1'] as num?)?.toDouble(),
      drop2: (json['drop2'] as num?)?.toDouble(),
      drop3: (json['drop3'] as num?)?.toDouble(),
      interpretation: json['interpretation'] as String?,
    );
  }
}

class TeacherStudentItem {
  final int userAccountId;
  final String studentNumber;
  final String firstName;
  final String lastName;
  final String level;
  final String section;
  final String school;

  const TeacherStudentItem({
    required this.userAccountId,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.level,
    required this.section,
    required this.school,
  });

  String get fullName => '$firstName $lastName';

  factory TeacherStudentItem.fromJson(Map<String, dynamic> json) {
    return TeacherStudentItem(
      userAccountId: json['userAccountId'] as int,
      studentNumber: json['studentNumber'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      level: json['level'] as String? ?? '',
      section: json['section'] as String? ?? '',
      school: json['school'] as String? ?? '',
    );
  }
}

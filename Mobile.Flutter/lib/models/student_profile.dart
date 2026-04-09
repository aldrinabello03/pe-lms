class StudentProfile {
  final int? id;
  final String studentNumber;
  final String firstName;
  final String lastName;
  final String middleName;
  final int age;
  final String gender;
  final String teacherName;
  final String school;
  final String level;
  final String section;
  final double weight;
  final double height;
  final String? bodyType;
  final int? userAccountId;

  const StudentProfile({
    this.id,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.age,
    required this.gender,
    required this.teacherName,
    required this.school,
    required this.level,
    required this.section,
    this.weight = 0,
    this.height = 0,
    this.bodyType,
    this.userAccountId,
  });

  String get fullName => '$firstName $lastName';

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as int?,
      studentNumber: json['studentNumber'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      middleName: json['middleName'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? '',
      teacherName: json['teacherName'] as String? ?? '',
      school: json['school'] as String? ?? '',
      level: json['level'] as String? ?? '',
      section: json['section'] as String? ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 0,
      height: (json['height'] as num?)?.toDouble() ?? 0,
      bodyType: json['bodyType'] as String?,
      userAccountId: json['userAccountId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'studentNumber': studentNumber,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'age': age,
      'gender': gender,
      'teacherName': teacherName,
      'school': school,
      'level': level,
      'section': section,
      'weight': weight,
      'height': height,
      if (bodyType != null) 'bodyType': bodyType,
      if (userAccountId != null) 'userAccountId': userAccountId,
    };
  }
}

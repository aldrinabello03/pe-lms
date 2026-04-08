class TeacherProfile {
  final int? id;
  final String employeeNumber;
  final String title;
  final String firstName;
  final String lastName;
  final String middleName;
  final String school;
  final int? userAccountId;

  const TeacherProfile({
    this.id,
    required this.employeeNumber,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.school,
    this.userAccountId,
  });

  String get fullName => '$title $firstName $lastName';

  factory TeacherProfile.fromJson(Map<String, dynamic> json) {
    return TeacherProfile(
      id: json['id'] as int?,
      employeeNumber: json['employeeNumber'] as String? ?? '',
      title: json['title'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      middleName: json['middleName'] as String? ?? '',
      school: json['school'] as String? ?? '',
      userAccountId: json['userAccountId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'employeeNumber': employeeNumber,
      'title': title,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'school': school,
      if (userAccountId != null) 'userAccountId': userAccountId,
    };
  }
}

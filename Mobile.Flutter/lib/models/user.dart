class User {
  final int id;
  final String userName;
  final String name;
  final String role;
  final int age;
  final String gender;
  final int profileId;

  const User({
    required this.id,
    required this.userName,
    required this.name,
    required this.role,
    required this.age,
    required this.gender,
    required this.profileId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      userName: json['userName'] as String,
      name: json['name'] as String? ?? json['userName'] as String,
      role: json['role'] as String,
      age: json['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? '',
      profileId: json['profileId'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'name': name,
      'role': role,
      'age': age,
      'gender': gender,
      'profileId': profileId,
    };
  }

  bool get isStudent => role == 'Student';
  bool get isTeacher => role == 'Teacher';
  bool get hasProfile => profileId > 0;
}

class AuthResponse {
  final String token;
  final User user;

  const AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

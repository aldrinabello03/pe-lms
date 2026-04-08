class ApiConfig {
  // Default: Android emulator uses 10.0.2.2 to reach host machine localhost
  // Change to 'http://localhost:5000/api' for iOS simulator
  // Change to your server URL for physical device or production
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // Profile endpoints
  static const String studentProfile = '/student-profile';
  static const String teacherProfile = '/teacher-profile';

  // Dashboard endpoints
  static const String studentDashboard = '/dashboard/student';
  static const String studentsDashboard = '/dashboard/students';
  static String studentDashboardById(int userAccountId) =>
      '/dashboard/student/$userAccountId';

  // Test endpoints
  static String testDetails(String testKey) => '/tests/$testKey';

  // Score endpoints
  static const String scores = '/scores';

  // Export endpoints
  static const String exportStudent = '/export/student';
  static String exportStudentById(int userAccountId) =>
      '/export/student/$userAccountId';
  static const String exportAll = '/export/all';
}

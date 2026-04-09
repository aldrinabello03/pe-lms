class AppConstants {
  static const String appName = 'PELMS';
  static const String appFullName =
      'Physical Education Learning Management System';

  static const double tabletBreakpoint = 600.0;

  static const List<String> genderOptions = ['Male', 'Female'];
  static const List<String> roleOptions = ['Student', 'Teacher'];
  static const List<String> titleOptions = ['Mr.', 'Ms.', 'Mrs.', 'Dr.'];

  // Test navigation order (keys used in API calls)
  static const List<String> testOrder = [
    'Body Composition',
    'Balance',
    'Cardio Vascular Endurance',
    'Coordination',
    'Flexibility1',
    'Flexibility2',
    'Strength1',
    'Strength2',
    'Power',
    'Reaction Time',
    'Test for Speed',
  ];

  // Interpretation label → map to color via AppTheme.interpretationColor
  static const List<String> interpretations = [
    'Excellent',
    'Very Good',
    'Good',
    'Fair',
    'Needs Improvement',
    'Poor',
  ];

  static String nextTest(String currentKey) {
    final idx = testOrder.indexOf(currentKey);
    if (idx < 0 || idx == testOrder.length - 1) return testOrder.first;
    return testOrder[idx + 1];
  }

  static String previousTest(String currentKey) {
    final idx = testOrder.indexOf(currentKey);
    if (idx <= 0) return testOrder.last;
    return testOrder[idx - 1];
  }
}

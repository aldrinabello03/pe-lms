class Validators {
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? userName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? integer(String? value, [String fieldName = 'Value']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final n = int.tryParse(value.trim());
    if (n == null) return '$fieldName must be a whole number';
    if (n < 0) return '$fieldName must be non-negative';
    return null;
  }

  static String? decimal(String? value, [String fieldName = 'Value']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final d = double.tryParse(value.trim());
    if (d == null) return '$fieldName must be a number';
    if (d < 0) return '$fieldName must be non-negative';
    return null;
  }

  static String? age(String? value) {
    final err = integer(value, 'Age');
    if (err != null) return err;
    final n = int.parse(value!.trim());
    if (n < 1 || n > 120) return 'Please enter a valid age';
    return null;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dashboard.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class StudentDashboardState {
  final StudentDashboard? dashboard;
  final bool isLoading;
  final String? error;

  const StudentDashboardState({
    this.dashboard,
    this.isLoading = false,
    this.error,
  });

  StudentDashboardState copyWith({
    StudentDashboard? dashboard,
    bool? isLoading,
    String? error,
  }) {
    return StudentDashboardState(
      dashboard: dashboard ?? this.dashboard,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class StudentDashboardNotifier extends StateNotifier<StudentDashboardState> {
  final ApiService _apiService;

  StudentDashboardNotifier(this._apiService)
      : super(const StudentDashboardState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final dashboard = await _apiService.getStudentDashboard();
      state = StudentDashboardState(dashboard: dashboard);
    } on Exception catch (e) {
      state = StudentDashboardState(error: e.toString());
    }
  }

  Future<void> refresh() => load();
}

final studentDashboardProvider =
    StateNotifierProvider<StudentDashboardNotifier, StudentDashboardState>(
        (ref) {
  final apiService = ref.watch(apiServiceProvider);
  return StudentDashboardNotifier(apiService);
});

// Teacher: list of students
class TeacherStudentsState {
  final List<TeacherStudentItem> students;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const TeacherStudentsState({
    this.students = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  TeacherStudentsState copyWith({
    List<TeacherStudentItem>? students,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return TeacherStudentsState(
      students: students ?? this.students,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<TeacherStudentItem> get filtered {
    if (searchQuery.isEmpty) return students;
    final q = searchQuery.toLowerCase();
    return students.where((s) {
      return s.fullName.toLowerCase().contains(q) ||
          s.studentNumber.toLowerCase().contains(q) ||
          s.level.toLowerCase().contains(q) ||
          s.section.toLowerCase().contains(q);
    }).toList();
  }
}

class TeacherStudentsNotifier extends StateNotifier<TeacherStudentsState> {
  final ApiService _apiService;

  TeacherStudentsNotifier(this._apiService)
      : super(const TeacherStudentsState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final students = await _apiService.getStudentsList();
      state = TeacherStudentsState(students: students);
    } on Exception catch (e) {
      state = TeacherStudentsState(error: e.toString());
    }
  }

  Future<void> refresh() => load();

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final teacherStudentsProvider =
    StateNotifierProvider<TeacherStudentsNotifier, TeacherStudentsState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TeacherStudentsNotifier(apiService);
});

// Teacher: student detail dashboard
class StudentDetailDashboardState {
  final StudentDashboard? dashboard;
  final bool isLoading;
  final String? error;

  const StudentDetailDashboardState({
    this.dashboard,
    this.isLoading = false,
    this.error,
  });
}

class StudentDetailDashboardNotifier
    extends StateNotifier<StudentDetailDashboardState> {
  final ApiService _apiService;

  StudentDetailDashboardNotifier(this._apiService)
      : super(const StudentDetailDashboardState());

  Future<void> load(int userAccountId) async {
    state = const StudentDetailDashboardState(isLoading: true);
    try {
      final dashboard =
          await _apiService.getStudentDashboardById(userAccountId);
      state = StudentDetailDashboardState(dashboard: dashboard);
    } on Exception catch (e) {
      state = StudentDetailDashboardState(error: e.toString());
    }
  }
}

final studentDetailDashboardProvider = StateNotifierProvider.family<
    StudentDetailDashboardNotifier,
    StudentDetailDashboardState,
    int>((ref, userAccountId) {
  final apiService = ref.watch(apiServiceProvider);
  final notifier = StudentDetailDashboardNotifier(apiService);
  notifier.load(userAccountId);
  return notifier;
});

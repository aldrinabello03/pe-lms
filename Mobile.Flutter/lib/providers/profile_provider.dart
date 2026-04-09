import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student_profile.dart';
import '../models/teacher_profile.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class StudentProfileState {
  final StudentProfile? profile;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  const StudentProfileState({
    this.profile,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  StudentProfileState copyWith({
    StudentProfile? profile,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return StudentProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

class StudentProfileNotifier extends StateNotifier<StudentProfileState> {
  final ApiService _apiService;

  StudentProfileNotifier(this._apiService) : super(const StudentProfileState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profile = await _apiService.getStudentProfile();
      state = StudentProfileState(profile: profile);
    } on Exception catch (e) {
      state = StudentProfileState(error: e.toString());
    }
  }

  Future<bool> save(StudentProfile profile) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      StudentProfile saved;
      if (profile.id == null || profile.id == 0) {
        saved = await _apiService.createStudentProfile(profile);
      } else {
        saved = await _apiService.updateStudentProfile(profile);
      }
      state = StudentProfileState(profile: saved);
      return true;
    } on Exception catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }
}

final studentProfileProvider =
    StateNotifierProvider<StudentProfileNotifier, StudentProfileState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return StudentProfileNotifier(apiService);
});

class TeacherProfileState {
  final TeacherProfile? profile;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  const TeacherProfileState({
    this.profile,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  TeacherProfileState copyWith({
    TeacherProfile? profile,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return TeacherProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

class TeacherProfileNotifier extends StateNotifier<TeacherProfileState> {
  final ApiService _apiService;

  TeacherProfileNotifier(this._apiService) : super(const TeacherProfileState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profile = await _apiService.getTeacherProfile();
      state = TeacherProfileState(profile: profile);
    } on Exception catch (e) {
      state = TeacherProfileState(error: e.toString());
    }
  }

  Future<bool> save(TeacherProfile profile) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      TeacherProfile saved;
      if (profile.id == null || profile.id == 0) {
        saved = await _apiService.createTeacherProfile(profile);
      } else {
        saved = await _apiService.updateTeacherProfile(profile);
      }
      state = TeacherProfileState(profile: saved);
      return true;
    } on Exception catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }
}

final teacherProfileProvider =
    StateNotifierProvider<TeacherProfileNotifier, TeacherProfileState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TeacherProfileNotifier(apiService);
});

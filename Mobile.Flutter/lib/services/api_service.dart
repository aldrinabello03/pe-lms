import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/student_profile.dart';
import '../models/teacher_profile.dart';
import '../models/test_info.dart';
import '../models/student_score.dart';
import '../models/dashboard.dart';
import 'storage_service.dart';

class ApiService {
  late final Dio _dio;
  final StorageService _storage;

  ApiService(this._storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _storage.clearAll();
          }
          handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // Student Profile
  Future<StudentProfile?> getStudentProfile() async {
    final response = await _dio.get(ApiConfig.studentProfile);
    if (response.data == null) return null;
    return StudentProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<StudentProfile> createStudentProfile(StudentProfile profile) async {
    final response = await _dio.post(
      ApiConfig.studentProfile,
      data: profile.toJson(),
    );
    return StudentProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<StudentProfile> updateStudentProfile(StudentProfile profile) async {
    final response = await _dio.put(
      ApiConfig.studentProfile,
      data: profile.toJson(),
    );
    return StudentProfile.fromJson(response.data as Map<String, dynamic>);
  }

  // Teacher Profile
  Future<TeacherProfile?> getTeacherProfile() async {
    final response = await _dio.get(ApiConfig.teacherProfile);
    if (response.data == null) return null;
    return TeacherProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TeacherProfile> createTeacherProfile(TeacherProfile profile) async {
    final response = await _dio.post(
      ApiConfig.teacherProfile,
      data: profile.toJson(),
    );
    return TeacherProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TeacherProfile> updateTeacherProfile(TeacherProfile profile) async {
    final response = await _dio.put(
      ApiConfig.teacherProfile,
      data: profile.toJson(),
    );
    return TeacherProfile.fromJson(response.data as Map<String, dynamic>);
  }

  // Dashboard
  Future<StudentDashboard> getStudentDashboard() async {
    final response = await _dio.get(ApiConfig.studentDashboard);
    return StudentDashboard.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<TeacherStudentItem>> getStudentsList() async {
    final response = await _dio.get(ApiConfig.studentsDashboard);
    final list = response.data as List<dynamic>;
    return list
        .map((e) => TeacherStudentItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<StudentDashboard> getStudentDashboardById(int userAccountId) async {
    final response =
        await _dio.get(ApiConfig.studentDashboardById(userAccountId));
    return StudentDashboard.fromJson(response.data as Map<String, dynamic>);
  }

  // Tests
  Future<TestInfo> getTestDetails(String testKey) async {
    final response = await _dio.get(ApiConfig.testDetails(testKey));
    return TestInfo.fromJson(response.data as Map<String, dynamic>);
  }

  // Scores
  Future<void> submitScore(StudentScore score) async {
    await _dio.post(ApiConfig.scores, data: score.toJson());
  }

  // Export
  Future<List<int>> exportStudentData() async {
    final response = await _dio.get(
      ApiConfig.exportStudent,
      options: Options(responseType: ResponseType.bytes),
    );
    return List<int>.from(response.data as List);
  }

  Future<List<int>> exportStudentDataById(int userAccountId) async {
    final response = await _dio.get(
      ApiConfig.exportStudentById(userAccountId),
      options: Options(responseType: ResponseType.bytes),
    );
    return List<int>.from(response.data as List);
  }

  Future<List<int>> exportAllStudentsData() async {
    final response = await _dio.get(
      ApiConfig.exportAll,
      options: Options(responseType: ResponseType.bytes),
    );
    return List<int>.from(response.data as List);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ApiService(storage);
});

final authServiceProvider = Provider<AuthService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final apiService = ref.watch(apiServiceProvider);
  return AuthService(apiService.dio, storage);
});

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isAuthenticated => user != null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  Future<void> checkStoredAuth() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = await _authService.getStoredToken();
      if (token != null) {
        final user = await _authService.getStoredUser();
        state = AuthState(user: user);
      } else {
        state = const AuthState();
      }
    } catch (_) {
      state = const AuthState();
    }
  }

  Future<bool> login(String userName, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authResponse = await _authService.login(
        userName: userName,
        password: password,
      );
      state = AuthState(user: authResponse.user);
      return true;
    } on Exception catch (e) {
      state = AuthState(error: _extractErrorMessage(e));
      return false;
    }
  }

  Future<bool> register({
    required String userName,
    required String password,
    required String confirmPassword,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.register(
        userName: userName,
        password: password,
        confirmPassword: confirmPassword,
        role: role,
      );
      state = const AuthState();
      return true;
    } on Exception catch (e) {
      state = AuthState(error: _extractErrorMessage(e));
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState();
  }

  void updateUser(User user) {
    state = state.copyWith(user: user);
  }

  String _extractErrorMessage(Exception e) {
    return e.toString().replaceFirst('Exception: ', '');
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student_score.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class ScoreState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const ScoreState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  ScoreState copyWith({bool? isLoading, bool? isSuccess, String? error}) {
    return ScoreState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}

class ScoreNotifier extends StateNotifier<ScoreState> {
  final ApiService _apiService;

  ScoreNotifier(this._apiService) : super(const ScoreState());

  Future<bool> submitScore(StudentScore score) async {
    state = const ScoreState(isLoading: true);
    try {
      await _apiService.submitScore(score);
      state = const ScoreState(isSuccess: true);
      return true;
    } on Exception catch (e) {
      state = ScoreState(error: e.toString());
      return false;
    }
  }

  void reset() {
    state = const ScoreState();
  }
}

final scoreProvider = StateNotifierProvider<ScoreNotifier, ScoreState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ScoreNotifier(apiService);
});

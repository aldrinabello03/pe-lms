import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/test_info.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class TestState {
  final TestInfo? testInfo;
  final bool isLoading;
  final String? error;

  const TestState({this.testInfo, this.isLoading = false, this.error});

  TestState copyWith({TestInfo? testInfo, bool? isLoading, String? error}) {
    return TestState(
      testInfo: testInfo ?? this.testInfo,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TestNotifier extends StateNotifier<TestState> {
  final ApiService _apiService;

  TestNotifier(this._apiService) : super(const TestState());

  Future<void> loadTest(String testKey) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final testInfo = await _apiService.getTestDetails(testKey);
      state = TestState(testInfo: testInfo);
    } on Exception catch (e) {
      state = TestState(error: e.toString());
    }
  }

  void clear() {
    state = const TestState();
  }
}

final testProvider =
    StateNotifierProvider.family<TestNotifier, TestState, String>((ref, key) {
  final apiService = ref.watch(apiServiceProvider);
  return TestNotifier(apiService);
});

// Static list of all tests (same order as MVC app)
const List<Map<String, String>> allTests = [
  {
    'key': 'Body Composition',
    'title': 'Body Composition (BMI)',
    'category': 'Body Composition',
  },
  {
    'key': 'Balance',
    'title': 'Balance (Stork Balance Stand Test)',
    'category': 'Balance',
  },
  {
    'key': 'Cardio Vascular Endurance',
    'title': 'Cardio Vascular Endurance (3-Minute Step Test)',
    'category': 'Cardio',
  },
  {
    'key': 'Coordination',
    'title': 'Coordination (Juggling)',
    'category': 'Coordination',
  },
  {
    'key': 'Flexibility1',
    'title': 'Flexibility - Zipper Test',
    'category': 'Flexibility',
  },
  {
    'key': 'Flexibility2',
    'title': 'Flexibility - Sit and Reach',
    'category': 'Flexibility',
  },
  {
    'key': 'Strength1',
    'title': 'Strength - Push Up',
    'category': 'Strength',
  },
  {
    'key': 'Strength2',
    'title': 'Strength - Basic Plank',
    'category': 'Strength',
  },
  {
    'key': 'Power',
    'title': 'Power (Standing Long Jump)',
    'category': 'Power',
  },
  {
    'key': 'Reaction Time',
    'title': 'Reaction Time (Stick Drop Test)',
    'category': 'Reaction Time',
  },
  {
    'key': 'Test for Speed',
    'title': 'Test for Speed (40-Meter Sprint)',
    'category': 'Speed',
  },
];

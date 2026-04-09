import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/test_provider.dart';
import '../../providers/score_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../models/student_score.dart';
import '../../widgets/test_input_form.dart';
import '../../utils/constants.dart';

class TestDetailScreen extends ConsumerStatefulWidget {
  final String testKey;

  const TestDetailScreen({super.key, required this.testKey});

  @override
  ConsumerState<TestDetailScreen> createState() => _TestDetailScreenState();
}

class _TestDetailScreenState extends ConsumerState<TestDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(testProvider(widget.testKey).notifier).loadTest(widget.testKey);
      ref.read(studentDashboardProvider.notifier).load();
    });
  }

  bool _isDone() {
    final d = ref.read(studentDashboardProvider).dashboard;
    if (d == null) return false;
    switch (widget.testKey) {
      case 'Body Composition':
        return d.bmi?.bmiValue != null;
      case 'Balance':
        return d.balance?.interpretation != null;
      case 'Cardio Vascular Endurance':
        return d.stepTest?.value != null;
      case 'Coordination':
        return d.juggling?.interpretation != null;
      case 'Flexibility1':
        return d.zipper?.interpretation != null;
      case 'Flexibility2':
        return d.sitAndReach?.interpretation != null;
      case 'Strength1':
        return d.pushUp?.interpretation != null;
      case 'Strength2':
        return d.plank?.interpretation != null;
      case 'Power':
        return d.longJump?.interpretation != null;
      case 'Reaction Time':
        return d.stickDrop?.interpretation != null;
      case 'Test for Speed':
        return d.sprint?.interpretation != null;
      default:
        return false;
    }
  }

  void _navigateTo(String key) {
    context.pushReplacement('/student/tests/$key');
  }

  String _getTestTitle(String key) {
    return allTests
            .firstWhere(
              (t) => t['key'] == key,
              orElse: () => {'title': key},
            )['title'] ??
        key;
  }

  @override
  Widget build(BuildContext context) {
    final testState = ref.watch(testProvider(widget.testKey));
    final scoreState = ref.watch(scoreProvider);
    final isDone = _isDone();

    final nextKey = AppConstants.nextTest(widget.testKey);
    final prevKey = AppConstants.previousTest(widget.testKey);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTestTitle(widget.testKey)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: testState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : testState.error != null
                ? _buildError(testState.error!)
                : _buildContent(context, testState, scoreState, isDone),
      ),
      bottomNavigationBar: _buildNavBar(context, prevKey, nextKey),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Failed to load test', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref
                  .read(testProvider(widget.testKey).notifier)
                  .loadTest(widget.testKey),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TestState testState,
    ScoreState scoreState,
    bool isDone,
  ) {
    final info = testState.testInfo;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Done badge
          if (isDone)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2E7D32)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Already Completed ✓',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          if (isDone) const SizedBox(height: 16),

          // Video section
          _buildVideoSection(),

          const SizedBox(height: 24),

          // Instructions
          if (info != null) ...[
            _sectionHeader('Purpose'),
            _bodyText(info.purpose),

            if (info.formula != null && info.formula!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _sectionHeader('Formula'),
              _bodyText(info.formula!),
            ],

            const SizedBox(height: 16),
            _sectionHeader('Equipment'),
            ...info.equipment.map((e) => _bulletItem(e)),

            if (info.procedureTester.isNotEmpty) ...[
              const SizedBox(height: 16),
              _sectionHeader('Procedure (For the Tester)'),
              ...info.procedureTester.asMap().entries.map(
                    (e) => _numberedItem(e.key + 1, e.value),
                  ),
            ],

            if (info.procedurePartner.isNotEmpty) ...[
              const SizedBox(height: 16),
              _sectionHeader('Procedure (For the Partner)'),
              ...info.procedurePartner.asMap().entries.map(
                    (e) => _numberedItem(e.key + 1, e.value),
                  ),
            ],

            const SizedBox(height: 16),
            _sectionHeader('Scoring'),
            _bodyText(info.scoring),
          ] else ...[
            _sectionHeader('Instructions'),
            const Text('Loading instructions...'),
          ],

          const SizedBox(height: 32),

          // Score Input
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'Record Your Score',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          if (scoreState.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  scoreState.error!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            ),

          if (scoreState.isSuccess)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Score saved successfully!'),
                  ],
                ),
              ),
            ),

          TestInputForm(
            testKey: widget.testKey,
            isSaving: scoreState.isLoading,
            onSave: _onSave,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _onSave(StudentScore score) async {
    ref.read(scoreProvider.notifier).reset();
    final success =
        await ref.read(scoreProvider.notifier).submitScore(score);
    if (success) {
      ref.read(studentDashboardProvider.notifier).refresh();
    }
  }

  Widget _buildVideoSection() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_outline,
                color: Colors.white70, size: 64),
            const SizedBox(height: 8),
            Text(
              'Video: ${_getTestTitle(widget.testKey)}',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Text(
              '(Video player — connect to API for video URL)',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context, String prevKey, String nextKey) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _navigateTo(prevKey),
              icon: const Icon(Icons.chevron_left),
              label: const Text('Previous'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _navigateTo(nextKey),
              icon: const Icon(Icons.chevron_right),
              label: const Text('Next'),
              iconAlignment: IconAlignment.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }

  Widget _bodyText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 14, height: 1.6)),
    );
  }

  Widget _bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _numberedItem(int num, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$num. ', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }
}

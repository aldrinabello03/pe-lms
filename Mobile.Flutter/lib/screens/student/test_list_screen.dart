import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/test_provider.dart';

class TestListScreen extends ConsumerStatefulWidget {
  const TestListScreen({super.key});

  @override
  ConsumerState<TestListScreen> createState() => _TestListScreenState();
}

class _TestListScreenState extends ConsumerState<TestListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(studentDashboardProvider.notifier).load();
    });
  }

  bool _isDone(String testKey, StudentDashboardState state) {
    if (state.dashboard == null) return false;
    final d = state.dashboard!;
    switch (testKey) {
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

  @override
  Widget build(BuildContext context) {
    final dashState = ref.watch(studentDashboardProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Tests')),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(studentDashboardProvider.notifier).refresh(),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: allTests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final test = allTests[index];
            final key = test['key']!;
            final title = test['title']!;
            final done = _isDone(key, dashState);

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: done
                      ? const Color(0xFF2E7D32)
                      : Colors.grey.shade200,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: done ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: done
                    ? const Icon(Icons.check_circle,
                        color: Color(0xFF2E7D32))
                    : const Icon(Icons.radio_button_unchecked,
                        color: Colors.grey),
                onTap: () =>
                    context.push('/student/tests/$key'),
              ),
            );
          },
        ),
      ),
    );
  }
}

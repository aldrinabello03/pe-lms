import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/score_card_widget.dart';

class StudentDashboardScreen extends ConsumerStatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  ConsumerState<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState
    extends ConsumerState<StudentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(studentDashboardProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashState = ref.watch(studentDashboardProvider);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(dashState.dashboard?.studentName ?? user?.name ?? 'Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(studentDashboardProvider.notifier).refresh(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(studentDashboardProvider.notifier).refresh(),
        child: _buildBody(context, dashState),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/student/tests'),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Take Tests'),
      ),
    );
  }

  Widget _buildBody(BuildContext context, StudentDashboardState state) {
    if (state.isLoading && state.dashboard == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.dashboard == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load dashboard',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(state.error!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    ref.read(studentDashboardProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.dashboard == null) {
      return const Center(child: Text('No data available'));
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Fitness Test Scorecard',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ScoreCardWidget(dashboard: state.dashboard!),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

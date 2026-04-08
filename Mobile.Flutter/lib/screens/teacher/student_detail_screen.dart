import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dashboard_provider.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/score_card_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StudentDetailScreen extends ConsumerWidget {
  final int userAccountId;

  const StudentDetailScreen({super.key, required this.userAccountId});

  Future<void> _exportStudent(BuildContext context, WidgetRef ref) async {
    try {
      final api = ref.read(apiServiceProvider);
      final bytes = await api.exportStudentDataById(userAccountId);
      final dir = await getTemporaryDirectory();
      final file =
          File('${dir.path}/student_$userAccountId.xlsx');
      await file.writeAsBytes(bytes);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export completed')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      studentDetailDashboardProvider(userAccountId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(state.dashboard?.studentName ?? 'Student Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () => _exportStudent(context, ref),
            tooltip: 'Export',
          ),
        ],
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, StudentDetailDashboardState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load student data',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(state.error!, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    if (state.dashboard == null) {
      return const Center(child: Text('No data available'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.dashboard!.studentName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Fitness Test Results (Read-only)',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ScoreCardWidget(dashboard: state.dashboard!),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

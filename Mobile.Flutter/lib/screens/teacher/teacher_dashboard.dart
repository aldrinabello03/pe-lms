import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_provider.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TeacherDashboardScreen extends ConsumerStatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  ConsumerState<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState
    extends ConsumerState<TeacherDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teacherStudentsProvider.notifier).load();
    });
  }

  Future<void> _exportAll() async {
    try {
      final api = ref.read(apiServiceProvider);
      final bytes = await api.exportAllStudentsData();
      await _saveAndOpenFile(bytes, 'all_students.xlsx');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _exportStudent(int userAccountId, String name) async {
    try {
      final api = ref.read(apiServiceProvider);
      final bytes = await api.exportStudentDataById(userAccountId);
      final fileName = '${name.replaceAll(' ', '_')}.xlsx';
      await _saveAndOpenFile(bytes, fileName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _saveAndOpenFile(List<int> bytes, String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exported: $fileName'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () async {
              // open_filex would open the file
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teacherStudentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: _exportAll,
            tooltip: 'Export All',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(teacherStudentsProvider.notifier).refresh(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search students...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (q) =>
                  ref.read(teacherStudentsProvider.notifier).setSearch(q),
            ),
          ),

          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(teacherStudentsProvider.notifier).refresh(),
              child: _buildBody(context, state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, TeacherStudentsState state) {
    if (state.isLoading && state.students.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Failed to load students',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(state.error!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    ref.read(teacherStudentsProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final students = state.filtered;

    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isNotEmpty
                  ? 'No students match your search'
                  : 'No students assigned yet',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        if (isWide) {
          return _buildGrid(context, students);
        }
        return _buildList(context, students);
      },
    );
  }

  Widget _buildList(BuildContext context, List students) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: students.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) => _buildStudentCard(context, students[i]),
    );
  }

  Widget _buildGrid(BuildContext context, List students) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: students.length,
      itemBuilder: (context, i) => _buildStudentCard(context, students[i]),
    );
  }

  Widget _buildStudentCard(BuildContext context, student) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            context.push('/teacher/student/${student.userAccountId}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF2E7D32).withOpacity(0.1),
                child: Text(
                  student.firstName.isNotEmpty
                      ? student.firstName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      student.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student.studentNumber,
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13),
                    ),
                    Text(
                      '${student.level} • ${student.section}',
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.file_download_outlined,
                    color: Color(0xFF2E7D32)),
                onPressed: () =>
                    _exportStudent(student.userAccountId, student.fullName),
                tooltip: 'Export',
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

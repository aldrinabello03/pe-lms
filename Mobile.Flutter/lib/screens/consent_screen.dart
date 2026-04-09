import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../services/storage_service.dart';

class ConsentScreen extends ConsumerWidget {
  const ConsentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Privacy Consent')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.privacy_tip_outlined,
                        size: 64,
                        color: Color(0xFF2E7D32),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Data Privacy Notice',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'PELMS (Physical Education Learning Management System) '
                        'collects and processes your personal information in '
                        'accordance with the Data Privacy Act of 2012 (Republic '
                        'Act No. 10173).',
                        style: TextStyle(fontSize: 15, height: 1.6),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Information We Collect:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBullet('Personal information (name, age, gender)'),
                      _buildBullet('Student identification (student number)'),
                      _buildBullet('Physical fitness test scores and results'),
                      _buildBullet('Body composition data (height, weight)'),
                      const SizedBox(height: 16),
                      const Text(
                        'Purpose of Collection:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBullet(
                          'To record and compute Physical Education fitness test scores'),
                      _buildBullet(
                          'To provide teachers with student performance data'),
                      _buildBullet('To generate reports and assessments'),
                      const SizedBox(height: 16),
                      const Text(
                        'By clicking "I Agree", you consent to the collection '
                        'and processing of your personal data as described above.',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final storage = ref.read(storageServiceProvider);
                  await storage.setConsentAgreed(true);
                  if (!context.mounted) return;
                  final user = ref.read(authProvider).user;
                  if (user == null) {
                    context.go('/login');
                    return;
                  }
                  if (!user.hasProfile) {
                    context.go('/profile-setup');
                  } else if (user.isStudent) {
                    context.go('/student/dashboard');
                  } else {
                    context.go('/teacher/dashboard');
                  }
                },
                child: const Text('I Agree'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (!context.mounted) return;
                  context.go('/login');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }
}

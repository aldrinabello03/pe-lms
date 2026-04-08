import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/consent_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/student/student_dashboard.dart';
import 'screens/student/test_list_screen.dart';
import 'screens/student/test_detail_screen.dart';
import 'screens/teacher/teacher_dashboard.dart';
import 'screens/teacher/student_detail_screen.dart';

void main() {
  runApp(const ProviderScope(child: PelmsApp()));
}

class PelmsApp extends ConsumerWidget {
  const PelmsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'PELMS',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: _buildRouter(ref),
    );
  }

  GoRouter _buildRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/consent',
          builder: (context, state) => const ConsentScreen(),
        ),
        GoRoute(
          path: '/profile-setup',
          builder: (context, state) => const ProfileSetupScreen(),
        ),

        // Student shell with bottom nav
        ShellRoute(
          builder: (context, state, child) {
            return StudentShell(child: child);
          },
          routes: [
            GoRoute(
              path: '/student/dashboard',
              builder: (context, state) => const StudentDashboardScreen(),
            ),
            GoRoute(
              path: '/student/tests',
              builder: (context, state) => const TestListScreen(),
            ),
            GoRoute(
              path: '/student/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),

        // Test detail is outside shell (full screen)
        GoRoute(
          path: '/student/tests/:testKey',
          builder: (context, state) {
            final testKey =
                Uri.decodeComponent(state.pathParameters['testKey'] ?? '');
            return TestDetailScreen(testKey: testKey);
          },
        ),

        // Teacher shell with bottom nav
        ShellRoute(
          builder: (context, state, child) {
            return TeacherShell(child: child);
          },
          routes: [
            GoRoute(
              path: '/teacher/dashboard',
              builder: (context, state) => const TeacherDashboardScreen(),
            ),
            GoRoute(
              path: '/teacher/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),

        // Student detail is outside shell (full screen push)
        GoRoute(
          path: '/teacher/student/:id',
          builder: (context, state) {
            final id = int.tryParse(
                    state.pathParameters['id'] ?? '') ??
                0;
            return StudentDetailScreen(userAccountId: id);
          },
        ),
      ],
    );
  }
}

// Student navigation shell
class StudentShell extends StatefulWidget {
  final Widget child;
  const StudentShell({super.key, required this.child});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _selectedIndex = 0;

  static const List<String> _routes = [
    '/student/dashboard',
    '/student/tests',
    '/student/profile',
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final idx = _routes.indexWhere((r) => location.startsWith(r));
    final currentIndex = idx >= 0 ? idx : 0;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          context.go(_routes[index]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Tests',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Teacher navigation shell
class TeacherShell extends StatefulWidget {
  final Widget child;
  const TeacherShell({super.key, required this.child});

  @override
  State<TeacherShell> createState() => _TeacherShellState();
}

class _TeacherShellState extends State<TeacherShell> {
  static const List<String> _routes = [
    '/teacher/dashboard',
    '/teacher/profile',
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final idx = _routes.indexWhere((r) => location.startsWith(r));
    final currentIndex = idx >= 0 ? idx : 0;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          context.go(_routes[index]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people),
            label: 'Students',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

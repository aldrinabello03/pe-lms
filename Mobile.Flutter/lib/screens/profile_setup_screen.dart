import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../models/student_profile.dart';
import '../models/teacher_profile.dart';
import '../utils/validators.dart';
import '../utils/constants.dart';
import '../widgets/responsive_layout.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Student fields
  final _studentNumCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _middleNameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _teacherCtrl = TextEditingController();
  final _schoolCtrl = TextEditingController();
  final _levelCtrl = TextEditingController();
  final _sectionCtrl = TextEditingController();
  String _gender = 'Male';

  // Teacher fields
  final _empNumCtrl = TextEditingController();
  String _title = 'Mr.';

  @override
  void dispose() {
    _studentNumCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _middleNameCtrl.dispose();
    _ageCtrl.dispose();
    _teacherCtrl.dispose();
    _schoolCtrl.dispose();
    _levelCtrl.dispose();
    _sectionCtrl.dispose();
    _empNumCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authProvider).user;
    if (user == null) return;

    bool success;
    if (user.isStudent) {
      final profile = StudentProfile(
        studentNumber: _studentNumCtrl.text.trim(),
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        middleName: _middleNameCtrl.text.trim(),
        age: int.parse(_ageCtrl.text.trim()),
        gender: _gender,
        teacherName: _teacherCtrl.text.trim(),
        school: _schoolCtrl.text.trim(),
        level: _levelCtrl.text.trim(),
        section: _sectionCtrl.text.trim(),
      );
      success =
          await ref.read(studentProfileProvider.notifier).save(profile);
      if (success && mounted) {
        context.go('/student/dashboard');
      }
    } else {
      final profile = TeacherProfile(
        employeeNumber: _empNumCtrl.text.trim(),
        title: _title,
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        middleName: _middleNameCtrl.text.trim(),
        school: _schoolCtrl.text.trim(),
      );
      success =
          await ref.read(teacherProfileProvider.notifier).save(profile);
      if (success && mounted) {
        context.go('/teacher/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    if (user == null) return const SizedBox.shrink();

    final studentState = user.isStudent
        ? ref.watch(studentProfileProvider)
        : null;
    final teacherState = !user.isStudent
        ? ref.watch(teacherProfileProvider)
        : null;

    final isSaving =
        (studentState?.isSaving ?? false) || (teacherState?.isSaving ?? false);
    final error =
        studentState?.error ?? teacherState?.error;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.isStudent ? 'Student Profile' : 'Teacher Profile'),
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          phone: _buildForm(context, user.isStudent, isSaving, error),
          tablet: Center(
            child: SizedBox(
              width: 600,
              child: _buildForm(context, user.isStudent, isSaving, error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    bool isStudent,
    bool isSaving,
    String? error,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Complete Your Profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please fill in your profile details to continue.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(error,
                      style: TextStyle(color: Colors.red.shade700)),
                ),
              ),
            if (isStudent) ..._studentFields() else ..._teacherFields(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSaving ? null : _save,
              child: isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _studentFields() {
    return [
      _textField('Student Number', _studentNumCtrl),
      _textField('First Name', _firstNameCtrl),
      _textField('Last Name', _lastNameCtrl),
      _textField('Middle Name', _middleNameCtrl, required: false),
      _textField('Age', _ageCtrl,
          inputType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: Validators.age),
      _dropdown<String>(
        label: 'Gender',
        value: _gender,
        items: AppConstants.genderOptions,
        onChanged: (v) => setState(() => _gender = v ?? 'Male'),
      ),
      _textField('Teacher Name', _teacherCtrl),
      _textField('School', _schoolCtrl),
      _textField('Level / Grade', _levelCtrl),
      _textField('Section', _sectionCtrl),
    ];
  }

  List<Widget> _teacherFields() {
    return [
      _textField('Employee Number', _empNumCtrl),
      _dropdown<String>(
        label: 'Title',
        value: _title,
        items: AppConstants.titleOptions,
        onChanged: (v) => setState(() => _title = v ?? 'Mr.'),
      ),
      _textField('First Name', _firstNameCtrl),
      _textField('Last Name', _lastNameCtrl),
      _textField('Middle Name', _middleNameCtrl, required: false),
      _textField('School', _schoolCtrl),
    ];
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    bool required = true,
    TextInputType? inputType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: label),
        validator: validator ??
            (required
                ? (v) => Validators.required(v, label)
                : null),
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(labelText: label),
        items: items
            .map((item) =>
                DropdownMenuItem<T>(value: item, child: Text(item.toString())))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

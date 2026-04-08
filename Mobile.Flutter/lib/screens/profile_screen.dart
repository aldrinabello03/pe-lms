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

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _editing = false;
  bool _populated = false;
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user == null) return;
      if (user.isStudent) {
        ref.read(studentProfileProvider.notifier).load();
      } else {
        ref.read(teacherProfileProvider.notifier).load();
      }
    });
  }

  void _populateFields(StudentProfile? sp, TeacherProfile? tp) {
    if (sp != null) {
      _studentNumCtrl.text = sp.studentNumber;
      _firstNameCtrl.text = sp.firstName;
      _lastNameCtrl.text = sp.lastName;
      _middleNameCtrl.text = sp.middleName;
      _ageCtrl.text = sp.age.toString();
      _gender = sp.gender;
      _teacherCtrl.text = sp.teacherName;
      _schoolCtrl.text = sp.school;
      _levelCtrl.text = sp.level;
      _sectionCtrl.text = sp.section;
    }
    if (tp != null) {
      _empNumCtrl.text = tp.employeeNumber;
      _title = tp.title;
      _firstNameCtrl.text = tp.firstName;
      _lastNameCtrl.text = tp.lastName;
      _middleNameCtrl.text = tp.middleName;
      _schoolCtrl.text = tp.school;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authProvider).user;
    if (user == null) return;

    bool success;
    if (user.isStudent) {
      final existingId =
          ref.read(studentProfileProvider).profile?.id;
      final profile = StudentProfile(
        id: existingId,
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
    } else {
      final existingId =
          ref.read(teacherProfileProvider).profile?.id;
      final profile = TeacherProfile(
        id: existingId,
        employeeNumber: _empNumCtrl.text.trim(),
        title: _title,
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        middleName: _middleNameCtrl.text.trim(),
        school: _schoolCtrl.text.trim(),
      );
      success =
          await ref.read(teacherProfileProvider.notifier).save(profile);
    }

    if (success && mounted) {
      setState(() {
        _editing = false;
        _populated = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await ref.read(authProvider.notifier).logout();
      if (mounted) context.go('/login');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    if (user == null) return const SizedBox.shrink();

    final spState =
        user.isStudent ? ref.watch(studentProfileProvider) : null;
    final tpState =
        !user.isStudent ? ref.watch(teacherProfileProvider) : null;

    final profile = spState?.profile ?? tpState?.profile;
    final isLoading = spState?.isLoading ?? tpState?.isLoading ?? false;
    final isSaving = spState?.isSaving ?? tpState?.isSaving ?? false;
    final error = spState?.error ?? tpState?.error;

    // Populate only once when entering edit mode


    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_editing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                if (profile != null && !_populated) {
                  _populateFields(
                    profile is StudentProfile ? profile : null,
                    profile is TeacherProfile ? profile : null,
                  );
                  _populated = true;
                }
                setState(() => _editing = true);
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _editing
                ? _buildEditForm(context, user.isStudent, isSaving, error)
                : _buildViewProfile(context, user, profile),
      ),
    );
  }

  Widget _buildViewProfile(BuildContext context, user, profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: const Color(0xFF2E7D32).withOpacity(0.1),
            child: Text(
              (user.name.isNotEmpty ? user.name[0] : '?').toUpperCase(),
              style: const TextStyle(
                fontSize: 40,
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user.role,
              style: const TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (profile != null) _buildProfileDetails(profile, user.isStudent),
          if (profile == null)
            const Text(
              'No profile found. Tap Edit to create one.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(profile, bool isStudent) {
    final items = <_DetailItem>[];
    if (isStudent && profile is StudentProfile) {
      items.addAll([
        _DetailItem('Student Number', profile.studentNumber),
        _DetailItem('School', profile.school),
        _DetailItem('Level', profile.level),
        _DetailItem('Section', profile.section),
        _DetailItem('Age', '${profile.age}'),
        _DetailItem('Gender', profile.gender),
        _DetailItem('Teacher', profile.teacherName),
      ]);
    } else if (!isStudent && profile is TeacherProfile) {
      items.addAll([
        _DetailItem('Employee Number', profile.employeeNumber),
        _DetailItem('Title', profile.title),
        _DetailItem('School', profile.school),
      ]);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: items
              .map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            item.label,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.value,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildEditForm(
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
                  : const Text('Save Changes'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => setState(() {
                _editing = false;
                _populated = false;
              }),
              child: const Text('Cancel'),
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
            (required ? (v) => Validators.required(v, label) : null),
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

class _DetailItem {
  final String label;
  final String value;
  const _DetailItem(this.label, this.value);
}

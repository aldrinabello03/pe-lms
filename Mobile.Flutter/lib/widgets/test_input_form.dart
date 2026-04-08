import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/student_score.dart';
import '../utils/validators.dart';

class TestInputForm extends StatefulWidget {
  final String testKey;
  final StudentScore? existingScore;
  final bool isSaving;
  final void Function(StudentScore score) onSave;

  const TestInputForm({
    super.key,
    required this.testKey,
    this.existingScore,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<TestInputForm> createState() => _TestInputFormState();
}

class _TestInputFormState extends State<TestInputForm> {
  final _formKey = GlobalKey<FormState>();

  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  final _c3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  void _prefill() {
    final s = widget.existingScore;
    if (s == null) return;
    switch (widget.testKey) {
      case 'Body Composition':
        _c1.text = s.height?.toString() ?? '';
        _c2.text = s.weight?.toString() ?? '';
        break;
      case 'Balance':
        _c1.text = s.balanceRight?.toString() ?? '';
        _c2.text = s.balanceLeft?.toString() ?? '';
        break;
      case 'Cardio Vascular Endurance':
        _c1.text = s.beforeHeartRate?.toString() ?? '';
        _c2.text = s.afterHeartRate?.toString() ?? '';
        break;
      case 'Coordination':
        _c1.text = s.jugglingHits?.toString() ?? '';
        break;
      case 'Flexibility1':
        _c1.text = s.zipperGap?.toString() ?? '';
        break;
      case 'Flexibility2':
        _c1.text = s.sitAndReachFirstTry?.toString() ?? '';
        _c2.text = s.sitAndReachSecondTry?.toString() ?? '';
        break;
      case 'Strength1':
        _c1.text = s.numberOfPushUps?.toString() ?? '';
        break;
      case 'Strength2':
        _c1.text = s.plankTime?.toString() ?? '';
        break;
      case 'Power':
        _c1.text = s.longJumpFirstTry?.toString() ?? '';
        _c2.text = s.longJumpSecondTry?.toString() ?? '';
        break;
      case 'Reaction Time':
        _c1.text = s.stickDrop1?.toString() ?? '';
        _c2.text = s.stickDrop2?.toString() ?? '';
        _c3.text = s.stickDrop3?.toString() ?? '';
        break;
      case 'Test for Speed':
        _c1.text = s.sprintTime?.toString() ?? '';
        break;
    }
  }

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    StudentScore score;
    switch (widget.testKey) {
      case 'Body Composition':
        score = StudentScore(
          testTitle: 'Body Mass Index',
          height: double.tryParse(_c1.text),
          weight: double.tryParse(_c2.text),
        );
        break;
      case 'Balance':
        score = StudentScore(
          testTitle: 'Stork Balance Stand Test',
          balanceRight: int.tryParse(_c1.text),
          balanceLeft: int.tryParse(_c2.text),
        );
        break;
      case 'Cardio Vascular Endurance':
        score = StudentScore(
          testTitle: '3-Minute Step Test',
          beforeHeartRate: int.tryParse(_c1.text),
          afterHeartRate: int.tryParse(_c2.text),
        );
        break;
      case 'Coordination':
        score = StudentScore(
          testTitle: 'Juggling',
          jugglingHits: int.tryParse(_c1.text),
        );
        break;
      case 'Flexibility1':
        score = StudentScore(
          testTitle: 'Zipper Test',
          zipperGap: double.tryParse(_c1.text),
        );
        break;
      case 'Flexibility2':
        score = StudentScore(
          testTitle: 'Sit and Reach',
          sitAndReachFirstTry: double.tryParse(_c1.text),
          sitAndReachSecondTry: double.tryParse(_c2.text),
        );
        break;
      case 'Strength1':
        score = StudentScore(
          testTitle: 'Push Up',
          numberOfPushUps: int.tryParse(_c1.text),
        );
        break;
      case 'Strength2':
        score = StudentScore(
          testTitle: 'Basic Plank',
          plankTime: int.tryParse(_c1.text),
        );
        break;
      case 'Power':
        score = StudentScore(
          testTitle: 'Standing Long Jump',
          longJumpFirstTry: int.tryParse(_c1.text),
          longJumpSecondTry: int.tryParse(_c2.text),
        );
        break;
      case 'Reaction Time':
        score = StudentScore(
          testTitle: 'Stick Drop Test',
          stickDrop1: double.tryParse(_c1.text),
          stickDrop2: double.tryParse(_c2.text),
          stickDrop3: double.tryParse(_c3.text),
        );
        break;
      case 'Test for Speed':
        score = StudentScore(
          testTitle: '40-Meter Sprint',
          sprintTime: double.tryParse(_c1.text),
        );
        break;
      default:
        return;
    }
    widget.onSave(score);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._buildFields(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: widget.isSaving ? null : _submit,
            child: widget.isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Save Score'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFields() {
    switch (widget.testKey) {
      case 'Body Composition':
        return [
          _field('Height (meters)', _c1, validator: Validators.decimal,
              isDecimal: true),
          _field('Weight (kg)', _c2, validator: Validators.decimal,
              isDecimal: true),
        ];
      case 'Balance':
        return [
          _field('Right Leg (seconds)', _c1, validator: Validators.integer),
          _field('Left Leg (seconds)', _c2, validator: Validators.integer),
        ];
      case 'Cardio Vascular Endurance':
        return [
          _field('Heart Rate Before (bpm)', _c1,
              validator: Validators.integer),
          _field('Heart Rate After (bpm)', _c2, validator: Validators.integer),
        ];
      case 'Coordination':
        return [
          _field('Number of Hits', _c1, validator: Validators.integer),
        ];
      case 'Flexibility1':
        return [
          _field('Gap Distance (cm)', _c1, validator: Validators.decimal,
              isDecimal: true),
        ];
      case 'Flexibility2':
        return [
          _field('First Try (cm)', _c1, validator: Validators.decimal,
              isDecimal: true),
          _field('Second Try (cm)', _c2, validator: Validators.decimal,
              isDecimal: true),
        ];
      case 'Strength1':
        return [
          _field('Number of Push-Ups', _c1, validator: Validators.integer),
        ];
      case 'Strength2':
        return [
          _field('Time (seconds)', _c1, validator: Validators.integer),
        ];
      case 'Power':
        return [
          _field('First Try (cm)', _c1, validator: Validators.integer),
          _field('Second Try (cm)', _c2, validator: Validators.integer),
        ];
      case 'Reaction Time':
        return [
          _field('Drop 1 (cm)', _c1, validator: Validators.decimal,
              isDecimal: true),
          _field('Drop 2 (cm)', _c2, validator: Validators.decimal,
              isDecimal: true),
          _field('Drop 3 (cm)', _c3, validator: Validators.decimal,
              isDecimal: true),
        ];
      case 'Test for Speed':
        return [
          _field('Time (seconds)', _c1, validator: Validators.decimal,
              isDecimal: true),
        ];
      default:
        return [];
    }
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
    bool isDecimal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType:
            TextInputType.numberWithOptions(decimal: isDecimal, signed: false),
        inputFormatters: [
          if (isDecimal)
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
          else
            FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(labelText: label),
        validator: validator,
      ),
    );
  }
}

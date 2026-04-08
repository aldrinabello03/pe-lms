import 'package:flutter/material.dart';
import '../models/dashboard.dart';
import 'interpretation_badge.dart';

class ScoreCardWidget extends StatelessWidget {
  final StudentDashboard dashboard;

  const ScoreCardWidget({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        if (isWide) {
          return _buildGrid(context, crossAxisCount: 2);
        }
        return _buildList(context);
      },
    );
  }

  Widget _buildGrid(BuildContext context, {required int crossAxisCount}) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      childAspectRatio: 1.6,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      padding: const EdgeInsets.all(12),
      children: _buildCards(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      children: _buildCards(context)
          .map((card) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: card,
              ))
          .toList(),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    return [
      _BmiCard(result: dashboard.bmi),
      _BalanceCard(result: dashboard.balance),
      _StepTestCard(result: dashboard.stepTest),
      _JugglingCard(result: dashboard.juggling),
      _ZipperCard(result: dashboard.zipper),
      _SitReachCard(result: dashboard.sitAndReach),
      _PushUpCard(result: dashboard.pushUp),
      _PlankCard(result: dashboard.plank),
      _LongJumpCard(result: dashboard.longJump),
      _StickDropCard(result: dashboard.stickDrop),
      _SprintCard(result: dashboard.sprint),
    ];
  }
}

class _TestCard extends StatelessWidget {
  final String title;
  final String? interpretation;
  final List<_ScoreRow> scores;

  const _TestCard({
    required this.title,
    required this.interpretation,
    required this.scores,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                InterpretationBadge(interpretation: interpretation),
              ],
            ),
            if (scores.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              ...scores.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        s.value ?? '—',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ScoreRow {
  final String label;
  final String? value;
  const _ScoreRow(this.label, this.value);
}

class _BmiCard extends StatelessWidget {
  final BmiResult? result;
  const _BmiCard({this.result});

  @override
  Widget build(BuildContext context) {
    return _TestCard(
      title: 'Body Composition (BMI)',
      interpretation: result?.classification,
      scores: result == null
          ? []
          : [
              _ScoreRow('Height', result!.height != null
                  ? '${result!.height!.toStringAsFixed(2)} m'
                  : null),
              _ScoreRow('Weight',
                  result!.weight != null ? '${result!.weight} kg' : null),
              _ScoreRow('BMI', result!.bmiValue != null
                  ? result!.bmiValue!.toStringAsFixed(2)
                  : null),
            ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final ScoreResult? result;
  const _BalanceCard({this.result});

  @override
  Widget build(BuildContext context) {
    return _TestCard(
      title: 'Balance (Stork Stand Test)',
      interpretation: result?.interpretation,
      scores: result == null
          ? []
          : [
              _ScoreRow('Right Leg',
                  result!.value != null ? '${result!.value} sec' : null),
              _ScoreRow('Left Leg',
                  result!.value2 != null ? '${result!.value2} sec' : null),
            ],
    );
  }
}

class _StepTestCard extends StatelessWidget {
  final ScoreResult? result;
  const _StepTestCard({this.result});

  @override
  Widget build(BuildContext context) {
    return _TestCard(
      title: 'Cardio (3-Min Step Test)',
      interpretation: result?.interpretation,
      scores: result == null
          ? []
          : [
              _ScoreRow('Before HR',
                  result!.value != null ? '${result!.value} bpm' : null),
              _ScoreRow('After HR',
                  result!.value2 != null ? '${result!.value2} bpm' : null),
            ],
    );
  }
}

class _JugglingCard extends StatelessWidget {
  final ScoreResult? result;
  const _JugglingCard({this.result});

  @override
  Widget build(BuildContext context) {
    return _TestCard(
      title: 'Coordination (Juggling)',
      interpretation: result?.interpretation,
      scores: result == null
          ? []
          : [
              _ScoreRow(
                  'Hits', result!.value != null ? '${result!.value}' : null),
            ],
    );
  }
}

class _ZipperCard extends StatelessWidget {
  final ScoreResult? result;
  const _ZipperCard({this.result});

  @override
  Widget build(BuildContext context) {
    return _TestCard(
      title: 'Flexibility - Zipper Test',
      interpretation: result?.interpretation,
      scores: result == null
          ? []
          : [
              _ScoreRow('Gap',
                  result!.value != null ? '${result!.value} cm' : null),
            ],
    );
  }
}

class _SitReachCard extends StatelessWidget {
  final SitReachResult? result;
  const _SitReachCard({this.result});

  @override
  Widget build(BuildContext context) {
    return _TestCard(
      title: 'Flexibility - Sit & Reach',
      interpretation: result?.interpretation,
      scores: result == null
          ? []
          : [
              _ScoreRow('Try 1',
                  result!.try1 != null ? '${result!.try1} cm' : null),
              _ScoreRow('Try 2',
                  result!.try2 != null ? '${result!.try2} cm' : null),
              _ScoreRow('Best',
                  result!.bestScore != null ? '${result!.bestScore} cm' : null),
            ],
    );
  }
}

class _PushUpCard extends StatelessWidget {
  final ScoreResult? result;
  const _PushUpCard({this.result});

  @override
  Widget build(BuildContext context) {
    return _TestCard(
      title: 'Strength - Push Up',
      interpretation: result?.interpretation,
      scores: result == null
          ? []
          : [
              _ScoreRow(
                  'Count', result!.value != null ? '${result!.value}' : null),
            ],
    );
  }
}

class _PlankCard extends StatelessWidget {
  final ScoreResult? result;
  const _PlankCard({this.result});

  @override
  Widget build(BuildContext context) {
    return _TestCard(
      title: 'Strength - Basic Plank',
      interpretation: result?.interpretation,
      scores: result == null
          ? []
          : [
              _ScoreRow('Time',
                  result!.value != null ? '${result!.value} sec' : null),
            ],
    );
  }
}

class _LongJumpCard extends StatelessWidget {
  final LongJumpResult? result;
  const _LongJumpCard({this.result});

  @override
  Widget build(BuildContext context) {
    return _TestCard(
      title: 'Power (Standing Long Jump)',
      interpretation: result?.interpretation,
      scores: result == null
          ? []
          : [
              _ScoreRow(
                  'Try 1', result!.try1 != null ? '${result!.try1} cm' : null),
              _ScoreRow(
                  'Try 2', result!.try2 != null ? '${result!.try2} cm' : null),
            ],
    );
  }
}

class _StickDropCard extends StatelessWidget {
  final StickDropResult? result;
  const _StickDropCard({this.result});

  @override
  Widget build(BuildContext context) {
    return _TestCard(
      title: 'Reaction Time (Stick Drop)',
      interpretation: result?.interpretation,
      scores: result == null
          ? []
          : [
              _ScoreRow('Drop 1',
                  result!.drop1 != null ? '${result!.drop1} cm' : null),
              _ScoreRow('Drop 2',
                  result!.drop2 != null ? '${result!.drop2} cm' : null),
              _ScoreRow('Drop 3',
                  result!.drop3 != null ? '${result!.drop3} cm' : null),
            ],
    );
  }
}

class _SprintCard extends StatelessWidget {
  final ScoreResult? result;
  const _SprintCard({this.result});

  @override
  Widget build(BuildContext context) {
    return _TestCard(
      title: 'Speed (40-Meter Sprint)',
      interpretation: result?.interpretation,
      scores: result == null
          ? []
          : [
              _ScoreRow('Time',
                  result!.value != null ? '${result!.value} sec' : null),
            ],
    );
  }
}

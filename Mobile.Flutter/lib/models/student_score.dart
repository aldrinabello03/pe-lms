class StudentScore {
  final int? id;
  final double? height;
  final double? weight;
  final int? beforeHeartRate;
  final int? afterHeartRate;
  final int? numberOfPushUps;
  final int? plankTime;
  final double? zipperGap;
  final double? sitAndReachFirstTry;
  final double? sitAndReachSecondTry;
  final int? jugglingHits;
  final double? sprintTime;
  final int? longJumpFirstTry;
  final int? longJumpSecondTry;
  final int? balanceRight;
  final int? balanceLeft;
  final double? stickDrop1;
  final double? stickDrop2;
  final double? stickDrop3;
  final String testTitle;
  final String? interpretation;
  final int? userAccountId;

  const StudentScore({
    this.id,
    this.height,
    this.weight,
    this.beforeHeartRate,
    this.afterHeartRate,
    this.numberOfPushUps,
    this.plankTime,
    this.zipperGap,
    this.sitAndReachFirstTry,
    this.sitAndReachSecondTry,
    this.jugglingHits,
    this.sprintTime,
    this.longJumpFirstTry,
    this.longJumpSecondTry,
    this.balanceRight,
    this.balanceLeft,
    this.stickDrop1,
    this.stickDrop2,
    this.stickDrop3,
    required this.testTitle,
    this.interpretation,
    this.userAccountId,
  });

  factory StudentScore.fromJson(Map<String, dynamic> json) {
    return StudentScore(
      id: json['id'] as int?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      beforeHeartRate: json['beforeHeartRate'] as int?,
      afterHeartRate: json['afterHeartRate'] as int?,
      numberOfPushUps: json['numberOfPushUps'] as int?,
      plankTime: json['plankTime'] as int?,
      zipperGap: (json['zipperGap'] as num?)?.toDouble(),
      sitAndReachFirstTry: (json['sitAndReachFirstTry'] as num?)?.toDouble(),
      sitAndReachSecondTry:
          (json['sitAndReachSecondTry'] as num?)?.toDouble(),
      jugglingHits: json['jugglingHits'] as int?,
      sprintTime: (json['sprintTime'] as num?)?.toDouble(),
      longJumpFirstTry: json['longJumpFirstTry'] as int?,
      longJumpSecondTry: json['longJumpSecondTry'] as int?,
      balanceRight: json['balanceRight'] as int?,
      balanceLeft: json['balanceLeft'] as int?,
      stickDrop1: (json['stickDrop1'] as num?)?.toDouble(),
      stickDrop2: (json['stickDrop2'] as num?)?.toDouble(),
      stickDrop3: (json['stickDrop3'] as num?)?.toDouble(),
      testTitle: json['testTitle'] as String? ?? '',
      interpretation: json['interpretation'] as String?,
      userAccountId: json['userAccountId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (beforeHeartRate != null) 'beforeHeartRate': beforeHeartRate,
      if (afterHeartRate != null) 'afterHeartRate': afterHeartRate,
      if (numberOfPushUps != null) 'numberOfPushUps': numberOfPushUps,
      if (plankTime != null) 'plankTime': plankTime,
      if (zipperGap != null) 'zipperGap': zipperGap,
      if (sitAndReachFirstTry != null)
        'sitAndReachFirstTry': sitAndReachFirstTry,
      if (sitAndReachSecondTry != null)
        'sitAndReachSecondTry': sitAndReachSecondTry,
      if (jugglingHits != null) 'jugglingHits': jugglingHits,
      if (sprintTime != null) 'sprintTime': sprintTime,
      if (longJumpFirstTry != null) 'longJumpFirstTry': longJumpFirstTry,
      if (longJumpSecondTry != null) 'longJumpSecondTry': longJumpSecondTry,
      if (balanceRight != null) 'balanceRight': balanceRight,
      if (balanceLeft != null) 'balanceLeft': balanceLeft,
      if (stickDrop1 != null) 'stickDrop1': stickDrop1,
      if (stickDrop2 != null) 'stickDrop2': stickDrop2,
      if (stickDrop3 != null) 'stickDrop3': stickDrop3,
      'testTitle': testTitle,
      if (interpretation != null) 'interpretation': interpretation,
      if (userAccountId != null) 'userAccountId': userAccountId,
    };
  }
}

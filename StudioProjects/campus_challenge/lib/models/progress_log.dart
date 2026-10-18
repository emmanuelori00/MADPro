import '../models/progress_log.dart';

class ProgressLog {
  int? id;
  int challengeId;
  int units;
  String note;
  String loggedAt;

  ProgressLog({
    this.id,
    required this.challengeId,
    required this.units,
    required this.note,
    required this.loggedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'challengeId': challengeId,
      'units': units,
      'note': note,
      'loggedAt': loggedAt,
    };
  }

  factory ProgressLog.fromMap(Map<String, dynamic> map) {
    return ProgressLog(
      id: map['id'],
      challengeId: map['challengeId'],
      units: map['units'],
      note: map['note'],
      loggedAt: map['loggedAt'],
    );
  }
}
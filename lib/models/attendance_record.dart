import 'work_mode.dart';

class AttendanceRecord {
  final DateTime date;
  final DateTime punchInTime;
  final DateTime? punchOutTime;
  final WorkMode workMode;
  final double latitude;
  final double longitude;
  final Duration? totalDuration;

  const AttendanceRecord({
    required this.date,
    required this.punchInTime,
    this.punchOutTime,
    required this.workMode,
    required this.latitude,
    required this.longitude,
    this.totalDuration,
  });

  AttendanceRecord copyWith({
    DateTime? punchOutTime,
    Duration? totalDuration,
  }) {
    return AttendanceRecord(
      date: date,
      punchInTime: punchInTime,
      punchOutTime: punchOutTime ?? this.punchOutTime,
      workMode: workMode,
      latitude: latitude,
      longitude: longitude,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }

  String get formattedTotalHours {
    if (totalDuration == null) return '--';
    final hours = totalDuration!.inHours;
    final minutes = totalDuration!.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}

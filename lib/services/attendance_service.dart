import '../models/attendance_record.dart';

class AttendanceService {
  final List<AttendanceRecord> _records = [];

  List<AttendanceRecord> get records =>
      List.unmodifiable(_records..sort((a, b) => b.date.compareTo(a.date)));

  void addRecord(AttendanceRecord record) {
    _records.add(record);
  }

  /// Get today's record (if any).
  AttendanceRecord? getTodayRecord() {
    final now = DateTime.now();
    try {
      return _records.firstWhere(
        (r) =>
            r.date.year == now.year &&
            r.date.month == now.month &&
            r.date.day == now.day &&
            r.punchOutTime == null,
      );
    } catch (_) {
      return null;
    }
  }
}

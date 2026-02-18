import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/attendance_record.dart';
import '../models/work_mode.dart';
import '../services/attendance_service.dart';
import '../services/location_service.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceService _attendanceService = AttendanceService();
  final LocationService _locationService = LocationService();

  // ── Current session state ──
  bool _isPunchedIn = false;
  DateTime? _punchInTime;
  WorkMode _selectedWorkMode = WorkMode.office;
  double? _currentLat;
  double? _currentLng;
  Duration _elapsed = Duration.zero;
  Timer? _timer;

  // ── Getters ──
  bool get isPunchedIn => _isPunchedIn;
  DateTime? get punchInTime => _punchInTime;
  WorkMode get selectedWorkMode => _selectedWorkMode;
  Duration get elapsed => _elapsed;
  double? get currentLat => _currentLat;
  double? get currentLng => _currentLng;
  List<AttendanceRecord> get attendanceHistory => _attendanceService.records;

  String get formattedElapsed {
    final hours = _elapsed.inHours.toString().padLeft(2, '0');
    final minutes = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  // ── Actions ──

  void setWorkMode(WorkMode mode) {
    _selectedWorkMode = mode;
    notifyListeners();
  }

  /// Punch in. Returns null on success, or an error message string.
  String? punchIn() {
    if (_isPunchedIn) return 'Already punched in';

    // Get mock location
    final location = _locationService.getMockLocation();
    _currentLat = location.latitude;
    _currentLng = location.longitude;

    // Validate office proximity if OFFICE mode
    if (_selectedWorkMode == WorkMode.office) {
      if (!_locationService.isWithinOfficeRadius(
          _currentLat!, _currentLng!)) {
        return 'You are outside office location';
      }
    }

    _isPunchedIn = true;
    _punchInTime = DateTime.now();
    _elapsed = Duration.zero;

    // Start live timer
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed = DateTime.now().difference(_punchInTime!);
      notifyListeners();
    });

    notifyListeners();
    return null;
  }

  /// Punch out and save the record.
  void punchOut() {
    if (!_isPunchedIn || _punchInTime == null) return;

    _timer?.cancel();
    _timer = null;

    final now = DateTime.now();
    final totalDuration = now.difference(_punchInTime!);

    final record = AttendanceRecord(
      date: _punchInTime!,
      punchInTime: _punchInTime!,
      punchOutTime: now,
      workMode: _selectedWorkMode,
      latitude: _currentLat ?? 0,
      longitude: _currentLng ?? 0,
      totalDuration: totalDuration,
    );

    _attendanceService.addRecord(record);

    // Reset state
    _isPunchedIn = false;
    _punchInTime = null;
    _elapsed = Duration.zero;
    _currentLat = null;
    _currentLng = null;

    notifyListeners();
  }

  /// Reset everything (e.g. on logout).
  void reset() {
    _timer?.cancel();
    _timer = null;
    _isPunchedIn = false;
    _punchInTime = null;
    _elapsed = Duration.zero;
    _currentLat = null;
    _currentLng = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

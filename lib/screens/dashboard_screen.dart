import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/work_mode.dart';
import '../providers/attendance_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'attendance_history_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final attendance = context.watch<AttendanceProvider>();
    final user = auth.user!;
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, dd MMM yyyy').format(now);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top Bar ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          user.name[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, ${user.name.split(' ').first} 👋',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                          ),
                          Text(
                            dateStr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    // Logout
                    IconButton(
                      onPressed: () {
                        attendance.reset();
                        auth.logout();
                      },
                      icon: const Icon(Icons.logout_rounded, size: 22),
                      tooltip: 'Logout',
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // ── Status Card ──
                      _StatusCard(attendance: attendance),
                      const SizedBox(height: 20),

                      // ── Work Mode Selector ──
                      _WorkModeSelector(attendance: attendance),
                      const SizedBox(height: 24),

                      // ── Punch Button ──
                      _PunchButton(attendance: attendance),
                      const SizedBox(height: 24),

                      // ── Today's Info ──
                      if (attendance.isPunchedIn) ...[
                        _InfoRow(
                          icon: Icons.access_time_rounded,
                          label: 'Punched in at',
                          value: DateFormat('hh:mm a')
                              .format(attendance.punchInTime!),
                        ),
                        const SizedBox(height: 10),
                        _InfoRow(
                          icon: Icons.location_on_outlined,
                          label: 'Mode',
                          value: attendance.selectedWorkMode ==
                                  WorkMode.office
                              ? '🏢 Office'
                              : '🏠 Work From Home',
                        ),
                        const SizedBox(height: 10),
                        if (attendance.currentLat != null)
                          _InfoRow(
                            icon: Icons.my_location_outlined,
                            label: 'Location',
                            value:
                                '${attendance.currentLat!.toStringAsFixed(4)}, ${attendance.currentLng!.toStringAsFixed(4)}',
                          ),
                      ],

                      const SizedBox(height: 28),

                      // ── History Button ──
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AttendanceHistoryScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.history_rounded, size: 20),
                          label: const Text('View Attendance History'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.accentTeal,
                            side: BorderSide(
                              color:
                                  AppTheme.accentTeal.withValues(alpha: 0.4),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Sub‐widgets
// ──────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.attendance});
  final AttendanceProvider attendance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: attendance.isPunchedIn
            ? const LinearGradient(
                colors: [Color(0xFF00695C), Color(0xFF004D40)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  AppTheme.cardDark,
                  AppTheme.cardDark.withValues(alpha: 0.8),
                ],
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: attendance.isPunchedIn
              ? AppTheme.accentTeal.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.06),
        ),
        boxShadow: [
          if (attendance.isPunchedIn)
            BoxShadow(
              color: AppTheme.accentTeal.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: attendance.isPunchedIn
                      ? AppTheme.accentTeal
                      : AppTheme.textSecondary,
                  shape: BoxShape.circle,
                  boxShadow: attendance.isPunchedIn
                      ? [
                          BoxShadow(
                            color: AppTheme.accentTeal.withValues(alpha: 0.6),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                attendance.isPunchedIn ? 'Currently Working' : 'Not Punched In',
                style: TextStyle(
                  color: attendance.isPunchedIn
                      ? AppTheme.accentTeal
                      : AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Timer display
          Text(
            attendance.formattedElapsed,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w300,
              color: attendance.isPunchedIn
                  ? Colors.white
                  : AppTheme.textSecondary.withValues(alpha: 0.5),
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Working hours',
            style: TextStyle(
              color: attendance.isPunchedIn
                  ? Colors.white70
                  : AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkModeSelector extends StatelessWidget {
  const _WorkModeSelector({required this.attendance});
  final AttendanceProvider attendance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: WorkMode.values.map((mode) {
          final isSelected = attendance.selectedWorkMode == mode;
          return Expanded(
            child: GestureDetector(
              onTap: attendance.isPunchedIn
                  ? null
                  : () => attendance.setWorkMode(mode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppTheme.primaryGradient : null,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                AppTheme.accentTeal.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mode == WorkMode.office ? '🏢' : '🏠',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      mode == WorkMode.office ? 'Office' : 'WFH',
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PunchButton extends StatelessWidget {
  const _PunchButton({required this.attendance});
  final AttendanceProvider attendance;

  @override
  Widget build(BuildContext context) {
    final isPunchedIn = attendance.isPunchedIn;

    return GestureDetector(
      onTap: () {
        if (isPunchedIn) {
          attendance.punchOut();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Punched out successfully!'),
              backgroundColor: AppTheme.accentTeal,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        } else {
          final error = attendance.punchIn();
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: AppTheme.errorRed,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isPunchedIn
              ? const LinearGradient(
                  colors: [Color(0xFFFF5252), Color(0xFFD32F2F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : AppTheme.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: (isPunchedIn ? AppTheme.errorRed : AppTheme.accentTeal)
                  .withValues(alpha: 0.35),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPunchedIn
                  ? Icons.stop_circle_outlined
                  : Icons.fingerprint_rounded,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 6),
            Text(
              isPunchedIn ? 'PUNCH OUT' : 'PUNCH IN',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.accentTeal),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

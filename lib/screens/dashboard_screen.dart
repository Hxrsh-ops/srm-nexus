import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'attendance_screen.dart';
import 'coming_soon_screen.dart';

class DashboardScreen extends StatefulWidget {
  final bool showDrawerButton;
  const DashboardScreen({super.key, this.showDrawerButton = false});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _entryController;
  late Animation<double> _fadeIn;

  final String studentName = "Harshanth";
  final String semester = "2nd Semester";
  final double gpa = 9.2;

  final List<Map<String, dynamic>> subjects = [
    {
      "code": "21CSC101T",
      "name": "OOP & Design",
      "present": 20,
      "total": 20,
      "color": Color(0xFF6C63FF),
    },
    {
      "code": "21CYB101J",
      "name": "Chemistry",
      "present": 38,
      "total": 39,
      "color": Color(0xFF00D4FF),
    },
    {
      "code": "21CYM101T",
      "name": "Env. Science",
      "present": 7,
      "total": 7,
      "color": Color(0xFF4ECB71),
    },
    {
      "code": "21EES101T",
      "name": "Electrical Engg",
      "present": 27,
      "total": 28,
      "color": Color(0xFFFFB347),
    },
    {
      "code": "21LEH104T",
      "name": "German",
      "present": 21,
      "total": 23,
      "color": Color(0xFFFF69B4),
    },
    {
      "code": "21LEM101T",
      "name": "Constitution",
      "present": 7,
      "total": 7,
      "color": Color(0xFFB39DDB),
    },
    {
      "code": "21MAB102T",
      "name": "Adv. Calculus",
      "present": 26,
      "total": 29,
      "color": Color(0xFFFF6B6B),
    },
    {
      "code": "21MES102L",
      "name": "Engg Graphics",
      "present": 27,
      "total": 32,
      "color": Color(0xFFFFD54F),
    },
    {
      "code": "CDC1",
      "name": "CDC1",
      "present": 4,
      "total": 4,
      "color": Color(0xFF80CBC4),
    },
  ];

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _entryController.forward(),
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  double _getAttendancePercent(int present, int total) =>
      total == 0 ? 0 : (present / total) * 100;

  Color _getAttendanceColor(double percent) {
    if (percent >= 85) return const Color(0xFF4ECB71);
    if (percent >= 75) return const Color(0xFFFFB347);
    return const Color(0xFFFF6B6B);
  }

  Map<String, dynamic> _getAttendanceStatus(double percent) {
    if (percent >= 85) {
      return {
        'label': 'Attendance Safe',
        'icon': Icons.check_circle_outline_rounded,
        'color': Color(0xFF4ECB71),
      };
    }
    if (percent >= 75) {
      return {
        'label': 'Needs Attention',
        'icon': Icons.warning_amber_rounded,
        'color': Color(0xFFFFB347),
      };
    }
    return {
      'label': 'Critical — Attend All',
      'icon': Icons.error_outline_rounded,
      'color': Color(0xFFFF6B6B),
    };
  }

  double _getOverallPercent() {
    int totalPresent = subjects.fold<int>(0, (sum, s) => sum + (s['present'] as int));
    int totalHours = subjects.fold<int>(0, (sum, s) => sum + (s['total'] as int));
    return totalHours == 0 ? 0 : (totalPresent / totalHours) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) => Stack(
          children: [
            _buildBgOrb(
              context,
              alignX: 0.9,
              alignY: -0.7,
              color: const Color(0xFF6C63FF),
              radius: 180,
              offset: math.sin(_bgController.value * 2 * math.pi) * 15,
            ),
            _buildBgOrb(
              context,
              alignX: -0.9,
              alignY: 0.5,
              color: const Color(0xFF00D4FF),
              radius: 140,
              offset: math.cos(_bgController.value * 2 * math.pi) * 12,
            ),
            child!,
          ],
        ),
        child: FadeTransition(
          opacity: _fadeIn,
          child: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Header ──────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Row(
                      children: [
                        if (widget.showDrawerButton) ...[
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Scaffold.of(context).openDrawer();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: const Icon(
                                Icons.menu_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_getGreeting()},',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.45),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                      colors: [
                                        Color(0xFF6C63FF),
                                        Color(0xFF00D4FF),
                                      ],
                                    ).createShader(bounds),
                                child: Text(
                                  studentName,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF6C63FF,
                                ).withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              studentName[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // ── GPA Card ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildGPACard(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 28)),

                // ── Quick Access Title ────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'QUICK ACCESS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white38,
                            letterSpacing: 3,
                          ),
                        ),
                        Text(
                          '4 shortcuts',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 14)),

                // ── Quick Access Grid ─────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildQuickAccess(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 28)),

                // ── Attendance Title ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ATTENDANCE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white38,
                            letterSpacing: 3,
                          ),
                        ),
                        Text(
                          'Sem 2 • 2026',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 14)),

                // ── Attendance Grid ───────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildAttendanceCard(subjects[index]),
                      childCount: subjects.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.85,
                        ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBgOrb(
    BuildContext context, {
    required double alignX,
    required double alignY,
    required Color color,
    required double radius,
    required double offset,
  }) {
    return Positioned(
      left: MediaQuery.of(context).size.width * ((alignX + 1) / 2) - radius,
      top:
          MediaQuery.of(context).size.height * ((alignY + 1) / 2) -
          radius +
          offset,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.2), Colors.transparent],
          ),
        ),
      ),
    );
  }

  Widget _buildGPACard() {
    final overallPercent = _getOverallPercent();
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C63FF).withValues(alpha: 0.15),
            const Color(0xFF00D4FF).withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF6C63FF).withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURRENT GPA',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white.withValues(alpha: 0.4),
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      gpa.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1,
                        letterSpacing: -1,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 7, left: 4),
                      child: Text(
                        '/ 10',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white38,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  semester,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 72,
            color: Colors.white.withValues(alpha: 0.08),
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AVG ATTENDANCE',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white.withValues(alpha: 0.4),
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      overallPercent.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: _getAttendanceColor(overallPercent),
                        height: 1,
                        letterSpacing: -1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7, left: 3),
                      child: Text(
                        '%',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      _getAttendanceStatus(overallPercent)['icon'] as IconData,
                      size: 12,
                      color:
                          _getAttendanceStatus(overallPercent)['color']
                              as Color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      overallPercent >= 75 ? 'On track' : 'Needs attention',
                      style: TextStyle(
                        fontSize: 12,
                        color: _getAttendanceColor(overallPercent),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccess() {
    final items = [
      {
        'icon': Icons.notifications_outlined,
        'label': 'Notifications',
        'subtitle': '3 unread',
        'color': const Color(0xFF6C63FF),
        'route': 'coming_soon',
      },
      {
        'icon': Icons.event_outlined,
        'label': 'Campus Events',
        'subtitle': '5 upcoming',
        'color': const Color(0xFF00D4FF),
        'route': 'coming_soon',
      },
      {
        'icon': Icons.assignment_late_outlined,
        'label': 'Exam Schedule',
        'subtitle': 'Next: Apr 12',
        'color': const Color(0xFF4ECB71),
        'route': 'coming_soon',
      },
      {
        'icon': Icons.bar_chart_rounded,
        'label': 'Attendance',
        'subtitle': 'Detailed view',
        'color': const Color(0xFFFFB347),
        'route': 'attendance',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final color = item['color'] as Color;
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            if (item['route'] == 'attendance') {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const AttendanceScreen(),
                  transitionsBuilder: (_, anim, __, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ComingSoonScreen(
                    featureName: item['label'] as String,
                    featureIcon: item['icon'] as IconData,
                    featureColor: color,
                  ),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withValues(alpha: 0.18)),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(item['icon'] as IconData, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['label'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: color.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> subject) {
    final percent = _getAttendancePercent(subject['present'], subject['total']);
    final color = subject['color'] as Color;
    final attendanceColor = _getAttendanceColor(percent);
    final status = _getAttendanceStatus(percent);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        color.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: percent / 100,
                      strokeWidth: 6,
                      backgroundColor: color.withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        attendanceColor,
                      ),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    '${percent.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subject['name'],
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            '${subject['present']}/${subject['total']} classes',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: (status['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (status['color'] as Color).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  status['icon'] as IconData,
                  size: 11,
                  color: status['color'] as Color,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    status['label'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: status['color'] as Color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

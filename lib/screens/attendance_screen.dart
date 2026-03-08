import 'package:flutter/material.dart';
import 'dart:math' as math;

class AttendanceScreen extends StatefulWidget {
  final bool showBackButton;
  const AttendanceScreen({super.key, this.showBackButton = true});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _bgController;
  late Animation<double> _fadeIn;
  late TabController _tabController;

  // ── Real subject-wise attendance data ─────────────────────────────────────
  final List<Map<String, dynamic>> subjectData = [
    {
      'code': '21CSC101T',
      'name': 'Object Oriented Design & Programming',
      'short': 'OOP & Design',
      'th': 20,
      'ph': 20,
      'ah': 0,
      'percent': 100.0,
      'color': Color(0xFF6C63FF),
    },
    {
      'code': '21CYB101J',
      'name': 'Chemistry',
      'short': 'Chemistry',
      'th': 39,
      'ph': 38,
      'ah': 1,
      'percent': 97.44,
      'color': Color(0xFF00D4FF),
    },
    {
      'code': '21CYM101T',
      'name': 'Environmental Science',
      'short': 'Env. Science',
      'th': 7,
      'ph': 7,
      'ah': 0,
      'percent': 100.0,
      'color': Color(0xFF4ECB71),
    },
    {
      'code': '21EES101T',
      'name': 'Electrical & Electronics Engineering',
      'short': 'Electrical Engg',
      'th': 28,
      'ph': 27,
      'ah': 1,
      'percent': 96.43,
      'color': Color(0xFFFFB347),
    },
    {
      'code': '21LEH104T',
      'name': 'German',
      'short': 'German',
      'th': 23,
      'ph': 21,
      'ah': 2,
      'percent': 91.30,
      'color': Color(0xFFFF69B4),
    },
    {
      'code': '21LEM101T',
      'name': 'Constitution of India',
      'short': 'Constitution',
      'th': 7,
      'ph': 7,
      'ah': 0,
      'percent': 100.0,
      'color': Color(0xFFB39DDB),
    },
    {
      'code': '21MAB102T',
      'name': 'Advanced Calculus & Complex Analysis',
      'short': 'Adv. Calculus',
      'th': 29,
      'ph': 26,
      'ah': 3,
      'percent': 89.66,
      'color': Color(0xFFFF6B6B),
    },
    {
      'code': '21MES102L',
      'name': 'Engineering Graphics & Design',
      'short': 'Engg Graphics',
      'th': 32,
      'ph': 27,
      'ah': 5,
      'percent': 84.38,
      'color': Color(0xFFFFD54F),
    },
    {
      'code': 'CDC1',
      'name': 'CDC1',
      'short': 'CDC1',
      'th': 4,
      'ph': 4,
      'ah': 0,
      'percent': 100.0,
      'color': Color(0xFF80CBC4),
    },
  ];

  // ── Real daily attendance data ────────────────────────────────────────────
  // Mirroring the app's hour-by-hour view.
  final List<Map<String, dynamic>> dailyData = [
    {
      'month': 'March - 2026',
      'present': 13,
      'absent': 4,
      'days': [
        {'date': '05-Mar-2026', 'hours': ['A', 'A', 'A', 'A', '-', '-', '-']},
        {'date': '04-Mar-2026', 'hours': ['P', '-', 'P', 'P', '-', '-', '-']},
        {'date': '03-Mar-2026', 'hours': ['P', 'P', 'P', 'P', '-', '-', '-']},
        {'date': '02-Mar-2026', 'hours': ['P', '-', 'P', 'P', 'P', 'P', '-']},
      ],
    },
    {
      'month': 'February - 2026',
      'present': 101,
      'absent': 4,
      'days': [
        {'date': '19-Feb-2026', 'hours': ['P', 'P', 'P', 'P', 'P', 'P', 'P']},
        {'date': '18-Feb-2026', 'hours': ['P', '-', 'P', 'P', '-', 'P', '-']},
        {'date': '17-Feb-2026', 'hours': ['P', 'P', 'P', 'P', '-', '-', '-']},
        {'date': '16-Feb-2026', 'hours': ['P', 'P', 'P', 'P', 'P', 'P', '-']},
        {'date': '13-Feb-2026', 'hours': ['P', 'P', 'P', 'P', 'P', 'P', '-']},
        {'date': '12-Feb-2026', 'hours': ['P', 'P', 'P', 'P', 'A', 'P', 'A']},
        {'date': '11-Feb-2026', 'hours': ['P', '-', 'P', 'P', '-', 'P', '-']},
        {'date': '10-Feb-2026', 'hours': ['P', 'P', 'P', 'P', '-', '-', '-']},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _entryController.forward(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bgController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  Color _getColor(double percent) {
    if (percent >= 85) return const Color(0xFF4ECB71);
    if (percent >= 75) return const Color(0xFFFFB347);
    return const Color(0xFFFF6B6B);
  }

  Map<String, dynamic> _getStatus(double percent) {
    if (percent >= 85) {
      return {
        'label': 'Safe',
        'color': Color(0xFF4ECB71),
        'icon': Icons.check_circle_outline_rounded,
      };
    }
    if (percent >= 75) {
      return {
        'label': 'Attention',
        'color': Color(0xFFFFB347),
        'icon': Icons.warning_amber_rounded,
      };
    }
    return {
      'label': 'Critical',
      'color': Color(0xFFFF6B6B),
      'icon': Icons.error_outline_rounded,
    };
  }

  // Overall computed stats
  int get totalPresent => subjectData.fold(0, (s, d) => s + (d['ph'] as int));
  int get totalHours => subjectData.fold(0, (s, d) => s + (d['th'] as int));
  int get totalAbsent => subjectData.fold(0, (s, d) => s + (d['ah'] as int));
  double get overallPercent =>
      totalHours == 0 ? 0 : (totalPresent / totalHours) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) => Stack(
          children: [
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF4ECB71).withValues(
                        alpha:
                            0.1 +
                            math.sin(_bgController.value * 2 * math.pi) * 0.04,
                      ),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF6C63FF).withValues(
                        alpha:
                            0.08 +
                            math.cos(_bgController.value * 2 * math.pi) * 0.03,
                      ),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            child!,
          ],
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: [
                      if (widget.showBackButton) ...[
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
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
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Attendance',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'Semester 2 • 2026',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.35),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Last updated badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Text(
                          '05-03-2026',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Overall Summary Card ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildOverallCard(),
                ),

                const SizedBox(height: 20),

                // ── Tab Bar ──────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4ECB71), Color(0xFF00D4FF)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: const EdgeInsets.all(4),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white38,
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: const [
                        Tab(text: 'Subject Wise'),
                        Tab(text: 'Day Order'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // ── Tab Views ────────────────────────────────────────────────
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildSubjectWise(), _buildHistory()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Overall Summary Card ──────────────────────────────────────────────────
  Widget _buildOverallCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getColor(overallPercent).withValues(alpha: 0.15),
            _getColor(overallPercent).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getColor(overallPercent).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Big ring
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 7,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getColor(overallPercent).withValues(alpha: 0.15),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: overallPercent / 100,
                    strokeWidth: 7,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getColor(overallPercent),
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${overallPercent.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    Text(
                      'overall',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                _statRow('Total Hours', '$totalHours hrs', Colors.white54),
                const SizedBox(height: 8),
                _statRow(
                  'Present',
                  '$totalPresent hrs',
                  const Color(0xFF4ECB71),
                ),
                const SizedBox(height: 8),
                _statRow('Absent', '$totalAbsent hrs', const Color(0xFFFF6B6B)),
                const SizedBox(height: 8),
                _statRow(
                  'Subjects',
                  '${subjectData.length} courses',
                  const Color(0xFF6C63FF),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  // ── Subject Wise Tab ──────────────────────────────────────────────────────
  Widget _buildSubjectWise() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 100),
      itemCount: subjectData.length,
      itemBuilder: (context, index) => _buildSubjectCard(subjectData[index]),
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> s) {
    final percent = s['percent'] as double;
    final color = s['color'] as Color;
    final statusColor = _getColor(percent);
    final status = _getStatus(percent);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            children: [
              // Color dot
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s['short'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s['code'],
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.3),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Percent badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '${percent.toStringAsFixed(percent == percent.roundToDouble() ? 0 : 2)}%',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: Colors.white.withValues(alpha: 0.07),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 14),

          // TH / PH / AH stats
          Row(
            children: [
              _hoursChip('Total Hrs', '${s['th']}', Colors.white38),
              const SizedBox(width: 8),
              _hoursChip('Present', '${s['ph']}', const Color(0xFF4ECB71)),
              const SizedBox(width: 8),
              _hoursChip('Absent', '${s['ah']}', const Color(0xFFFF6B6B)),
              const Spacer(),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    const SizedBox(width: 4),
                    Text(
                      status['label'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: status['color'] as Color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _hoursChip(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: Colors.white.withValues(alpha: 0.3),
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
            height: 1,
          ),
        ),
      ],
    );
  }

  // ── History / Day Order Tab ───────────────────────────────────────────────
  Widget _buildHistory() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 100),
      children: [
        ...dailyData.map((m) => _buildMonthHistoryCard(m)),
      ],
    );
  }

  Widget _buildMonthHistoryCard(Map<String, dynamic> m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Month Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  m['month'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00D4FF),
                  ),
                ),
                Row(
                  children: [
                    _buildBadge('P - ${m['present']}', const Color(0xFF4ECB71)),
                    const SizedBox(width: 8),
                    _buildBadge('A - ${m['absent']}', const Color(0xFFFF6B6B)),
                  ],
                ),
              ],
            ),
          ),
          
          // Table Layout
          // Header Row
          Container(
            color: const Color(0xFFFF6B6B).withValues(alpha: 0.15),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text(
                    'Date',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                ...List.generate(7, (i) => Expanded(
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),

          // Data Rows
          ...List.generate((m['days'] as List).length, (index) {
            final day = m['days'][index];
            final isEven = index % 2 == 0;
            return Container(
              color: isEven ? Colors.white.withValues(alpha: 0.02) : Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      day['date'],
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                  ...(day['hours'] as List<String>).map((h) {
                    Color c = Colors.white38;
                    if (h == 'P') c = const Color(0xFF4ECB71);
                    if (h == 'A') c = const Color(0xFFFF6B6B);
                    return Expanded(
                      child: Center(
                        child: Text(
                          h,
                          style: TextStyle(
                            color: c,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}

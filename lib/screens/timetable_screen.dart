import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/glass_card.dart';

class TimetableScreen extends StatefulWidget {
  final bool showBackButton;
  const TimetableScreen({super.key, this.showBackButton = true});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _bgController;
  late Animation<double> _fadeIn;
  late TabController _tabController;

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<String> fullDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  int get todayIndex {
    final weekday = DateTime.now().weekday;
    if (weekday >= 1 && weekday <= 6) return weekday - 1;
    return 0;
  }

  final Map<int, List<Map<String, dynamic>>> timetable = {
    0: [
      {
        'time': '08:00 - 08:50',
        'subject': 'OOP & Design',
        'code': '21CSC101T',
        'room': 'CB-301',
        'type': 'Theory',
        'color': Color(0xFF6C63FF),
      },
      {
        'time': '09:00 - 09:50',
        'subject': 'Advanced Calculus',
        'code': '21MAB102T',
        'room': 'CB-205',
        'type': 'Theory',
        'color': Color(0xFF00D4FF),
      },
      {
        'time': '10:00 - 10:50',
        'subject': 'Chemistry',
        'code': '21CYB101J',
        'room': 'Lab-12',
        'type': 'Lab',
        'color': Color(0xFFFF6B6B),
      },
      {
        'time': '11:00 - 11:50',
        'subject': 'German',
        'code': '21LEH104T',
        'room': 'LH-104',
        'type': 'Theory',
        'color': Color(0xFFFFB347),
      },
      {
        'time': '14:00 - 14:50',
        'subject': 'Electrical Engg',
        'code': '21EES101T',
        'room': 'CB-401',
        'type': 'Theory',
        'color': Color(0xFF4ECB71),
      },
    ],
    1: [
      {
        'time': '08:00 - 08:50',
        'subject': 'Environmental Science',
        'code': '21CYM101T',
        'room': 'CB-102',
        'type': 'Theory',
        'color': Color(0xFFFF69B4),
      },
      {
        'time': '09:00 - 09:50',
        'subject': 'OOP & Design',
        'code': '21CSC101T',
        'room': 'Lab-08',
        'type': 'Lab',
        'color': Color(0xFF6C63FF),
      },
      {
        'time': '11:00 - 11:50',
        'subject': 'Advanced Calculus',
        'code': '21MAB102T',
        'room': 'CB-205',
        'type': 'Theory',
        'color': Color(0xFF00D4FF),
      },
      {
        'time': '14:00 - 14:50',
        'subject': 'German',
        'code': '21LEH104T',
        'room': 'LH-104',
        'type': 'Theory',
        'color': Color(0xFFFFB347),
      },
    ],
    2: [
      {
        'time': '08:00 - 08:50',
        'subject': 'Electrical Engg',
        'code': '21EES101T',
        'room': 'CB-401',
        'type': 'Theory',
        'color': Color(0xFF4ECB71),
      },
      {
        'time': '10:00 - 10:50',
        'subject': 'Chemistry',
        'code': '21CYB101J',
        'room': 'CB-302',
        'type': 'Theory',
        'color': Color(0xFFFF6B6B),
      },
      {
        'time': '11:00 - 11:50',
        'subject': 'OOP & Design',
        'code': '21CSC101T',
        'room': 'CB-301',
        'type': 'Theory',
        'color': Color(0xFF6C63FF),
      },
      {
        'time': '14:00 - 15:50',
        'subject': 'Electrical Engg Lab',
        'code': '21EES101T',
        'room': 'EE-Lab2',
        'type': 'Lab',
        'color': Color(0xFF4ECB71),
      },
    ],
    3: [
      {
        'time': '09:00 - 09:50',
        'subject': 'Advanced Calculus',
        'code': '21MAB102T',
        'room': 'CB-205',
        'type': 'Theory',
        'color': Color(0xFF00D4FF),
      },
      {
        'time': '10:00 - 10:50',
        'subject': 'Environmental Science',
        'code': '21CYM101T',
        'room': 'CB-102',
        'type': 'Theory',
        'color': Color(0xFFFF69B4),
      },
      {
        'time': '11:00 - 11:50',
        'subject': 'German',
        'code': '21LEH104T',
        'room': 'LH-104',
        'type': 'Theory',
        'color': Color(0xFFFFB347),
      },
      {
        'time': '14:00 - 15:50',
        'subject': 'Chemistry Lab',
        'code': '21CYB101J',
        'room': 'Chem-Lab1',
        'type': 'Lab',
        'color': Color(0xFFFF6B6B),
      },
    ],
    4: [
      {
        'time': '08:00 - 08:50',
        'subject': 'OOP & Design',
        'code': '21CSC101T',
        'room': 'CB-301',
        'type': 'Theory',
        'color': Color(0xFF6C63FF),
      },
      {
        'time': '09:00 - 09:50',
        'subject': 'Electrical Engg',
        'code': '21EES101T',
        'room': 'CB-401',
        'type': 'Theory',
        'color': Color(0xFF4ECB71),
      },
      {
        'time': '11:00 - 11:50',
        'subject': 'Chemistry',
        'code': '21CYB101J',
        'room': 'CB-302',
        'type': 'Theory',
        'color': Color(0xFFFF6B6B),
      },
      {
        'time': '14:00 - 14:50',
        'subject': 'Environmental Science',
        'code': '21CYM101T',
        'room': 'CB-102',
        'type': 'Theory',
        'color': Color(0xFFFF69B4),
      },
    ],
    5: [
      {
        'time': '09:00 - 09:50',
        'subject': 'Advanced Calculus',
        'code': '21MAB102T',
        'room': 'CB-205',
        'type': 'Theory',
        'color': Color(0xFF00D4FF),
      },
      {
        'time': '10:00 - 10:50',
        'subject': 'OOP & Design',
        'code': '21CSC101T',
        'room': 'Lab-08',
        'type': 'Lab',
        'color': Color(0xFF6C63FF),
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: days.length,
      vsync: this,
      initialIndex: todayIndex,
    );
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

  bool _isCurrentClass(String timeStr) {
    try {
      final now = DateTime.now();
      final startStr = timeStr.split(' - ')[0].trim();
      final parts = startStr.split(':');
      final classStart = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      final classEnd = classStart.add(const Duration(minutes: 50));
      return now.isAfter(classStart) && now.isBefore(classEnd);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12141D),
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) => Stack(
          children: [
            Positioned(
              top: -100,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF6C63FF).withValues(
                        alpha:
                            0.1 +
                            math.sin(_bgController.value * 2 * math.pi) * 0.05,
                      ),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00D4FF).withValues(
                        alpha:
                            0.08 +
                            math.cos(_bgController.value * 2 * math.pi) * 0.04,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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
                              'Timetable',
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF6C63FF,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(
                              0xFF6C63FF,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'Today: ${days[todayIndex]}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6C63FF),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Day Tab Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    borderRadius: 14,
                    padding: EdgeInsets.zero,
                    child: SizedBox(
                      height: 44,
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: false,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding: const EdgeInsets.all(4),
                        labelPadding: EdgeInsets.zero,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white38,
                        labelStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: days.map((d) {
                          final isToday = days.indexOf(d) == todayIndex;
                          return Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(d),
                                if (isToday) ...[
                                  const SizedBox(width: 3),
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4ECB71),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, _) {
                    final dayIdx = _tabController.index;
                    final classes = timetable[dayIdx] ?? [];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Text(
                            '${classes.length} classes',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            fullDays[dayIdx],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 14),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: List.generate(days.length, (dayIdx) {
                      final classes = timetable[dayIdx] ?? [];
                      if (classes.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.wb_sunny_outlined,
                                size: 48,
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No classes today!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Enjoy your day 🎉',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                        itemCount: classes.length,
                        itemBuilder: (context, index) {
                          final cls = classes[index];
                          final isCurrent =
                              dayIdx == todayIndex &&
                              _isCurrentClass(cls['time']);
                          return _buildClassCard(cls, isCurrent);
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> cls, bool isCurrent) {
    final color = cls['color'] as Color;
    final isLab = cls['type'] == 'Lab';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cls['time'].toString().split(' - ')[0],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isCurrent
                          ? color
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  Text(
                    cls['time'].toString().split(' - ')[1],
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: isCurrent ? 14 : 10,
                height: isCurrent ? 14 : 10,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? color
                      : Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 8,
                          ),
                        ]
                      : [],
                ),
              ),
              Container(
                width: 1,
                height: 70,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: GlassCard(
                borderRadius: 16,
                padding: const EdgeInsets.all(16),
                baseColor: isCurrent ? color : Colors.white,
                borderGlow: isCurrent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cls['subject'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isLab
                                ? const Color(
                                    0xFFFFB347,
                                  ).withValues(alpha: 0.15)
                                : color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            cls['type'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isLab ? const Color(0xFFFFB347) : color,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          cls['room'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.tag,
                          size: 13,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          cls['code'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                    if (isCurrent) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Happening now',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

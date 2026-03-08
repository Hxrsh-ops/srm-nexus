import 'package:flutter/material.dart';

class MarksScreen extends StatefulWidget {
  final bool showBackButton;
  const MarksScreen({super.key, this.showBackButton = true});

  @override
  State<MarksScreen> createState() => _MarksScreenState();
}

class _MarksScreenState extends State<MarksScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _fadeIn;

  final List<Map<String, dynamic>> subjects = [
    {
      'code': '21CSC101T',
      'name': 'Object Oriented Design & Programming',
      'shortName': 'OOP & Design',
      'credit': 4,
      'cat1': 42.0,
      'cat2': 38.0,
      'cat1Max': 50.0,
      'cat2Max': 50.0,
      'assignment': 9.0,
      'assignmentMax': 10.0,
      'color': Color(0xFF6C63FF),
    },
    {
      'code': '21MAB102T',
      'name': 'Advanced Calculus & Complex Analysis',
      'shortName': 'Adv. Calculus',
      'credit': 4,
      'cat1': 35.0,
      'cat2': 40.0,
      'cat1Max': 50.0,
      'cat2Max': 50.0,
      'assignment': 8.0,
      'assignmentMax': 10.0,
      'color': Color(0xFF00D4FF),
    },
    {
      'code': '21CYB101J',
      'name': 'Chemistry',
      'shortName': 'Chemistry',
      'credit': 3,
      'cat1': 28.0,
      'cat2': 32.0,
      'cat1Max': 50.0,
      'cat2Max': 50.0,
      'assignment': 7.0,
      'assignmentMax': 10.0,
      'color': Color(0xFFFF6B6B),
    },
    {
      'code': '21EES101T',
      'name': 'Electrical & Electronics Engineering',
      'shortName': 'Electrical Engg',
      'credit': 3,
      'cat1': 45.0,
      'cat2': 44.0,
      'cat1Max': 50.0,
      'cat2Max': 50.0,
      'assignment': 10.0,
      'assignmentMax': 10.0,
      'color': Color(0xFF4ECB71),
    },
    {
      'code': '21LEH104T',
      'name': 'German',
      'shortName': 'German',
      'credit': 2,
      'cat1': 30.0,
      'cat2': 28.0,
      'cat1Max': 50.0,
      'cat2Max': 50.0,
      'assignment': 6.0,
      'assignmentMax': 10.0,
      'color': Color(0xFFFFB347),
    },
    {
      'code': '21CYM101T',
      'name': 'Environmental Science',
      'shortName': 'Env. Science',
      'credit': 2,
      'cat1': 40.0,
      'cat2': 43.0,
      'cat1Max': 50.0,
      'cat2Max': 50.0,
      'assignment': 9.0,
      'assignmentMax': 10.0,
      'color': Color(0xFFFF69B4),
    },
  ];

  int _expandedIndex = -1;

  @override
  void initState() {
    super.initState();
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
    _entryController.dispose();
    super.dispose();
  }

  double _getTotal(Map<String, dynamic> s) =>
      s['cat1'] + s['cat2'] + s['assignment'];
  double _getMaxTotal(Map<String, dynamic> s) =>
      s['cat1Max'] + s['cat2Max'] + s['assignmentMax'];
  double _getPercent(Map<String, dynamic> s) =>
      (_getTotal(s) / _getMaxTotal(s)) * 100;

  String _getGrade(double percent) {
    if (percent >= 91) return 'O';
    if (percent >= 81) return 'A+';
    if (percent >= 71) return 'A';
    if (percent >= 61) return 'B+';
    if (percent >= 51) return 'B';
    if (percent >= 45) return 'C';
    return 'F';
  }

  Color _getGradeColor(double percent) {
    if (percent >= 81) return const Color(0xFF4ECB71);
    if (percent >= 61) return const Color(0xFFFFB347);
    return const Color(0xFFFF6B6B);
  }

  double _getOverallPercent() =>
      subjects.fold<double>(0, (sum, s) => sum + _getPercent(s)) /
      subjects.length;

  @override
  Widget build(BuildContext context) {
    final overallPercent = _getOverallPercent();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Internal Marks',
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
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6C63FF).withValues(alpha: 0.18),
                          const Color(0xFF00D4FF).withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                _getGradeColor(
                                  overallPercent,
                                ).withValues(alpha: 0.2),
                                _getGradeColor(
                                  overallPercent,
                                ).withValues(alpha: 0.05),
                              ],
                            ),
                            border: Border.all(
                              color: _getGradeColor(
                                overallPercent,
                              ).withValues(alpha: 0.5),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _getGrade(overallPercent),
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: _getGradeColor(overallPercent),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'OVERALL PERFORMANCE',
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
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      color: _getGradeColor(overallPercent),
                                      height: 1,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 4,
                                      left: 3,
                                    ),
                                    child: Text(
                                      '%',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${subjects.length} subjects • Sem 2',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.35),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'SUBJECT WISE BREAKDOWN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.35),
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 14)),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                    child: _buildSubjectCard(index),
                  ),
                  childCount: subjects.length,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectCard(int index) {
    final s = subjects[index];
    final percent = _getPercent(s);
    final grade = _getGrade(percent);
    final gradeColor = _getGradeColor(percent);
    final color = s['color'] as Color;
    final isExpanded = _expandedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _expandedIndex = isExpanded ? -1 : index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isExpanded
                ? color.withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.07),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
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
                        s['shortName'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s['code'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.3),
                          letterSpacing: 0.5,
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
                    color: gradeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: gradeColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    grade,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: gradeColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white38,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percent / 100,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(gradeColor),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${_getTotal(s).toStringAsFixed(0)}/${_getMaxTotal(s).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 18),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.06)),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildMarkChip(
                    'CAT 1',
                    s['cat1'],
                    s['cat1Max'],
                    const Color(0xFF6C63FF),
                  ),
                  const SizedBox(width: 10),
                  _buildMarkChip(
                    'CAT 2',
                    s['cat2'],
                    s['cat2Max'],
                    const Color(0xFF00D4FF),
                  ),
                  const SizedBox(width: 10),
                  _buildMarkChip(
                    'ASSIGN',
                    s['assignment'],
                    s['assignmentMax'],
                    const Color(0xFF4ECB71),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${s['credit']} Credits',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${percent.toStringAsFixed(1)}% overall',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: gradeColor,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMarkChip(String label, double marks, double max, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: color.withValues(alpha: 0.7),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              marks.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
                height: 1,
              ),
            ),
            Text(
              '/ ${max.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

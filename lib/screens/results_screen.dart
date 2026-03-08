import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/repositories/results_repository.dart';
import '../core/models/results_model.dart';

class ResultsScreen extends StatefulWidget {
  final bool showBackButton;
  const ResultsScreen({super.key, this.showBackButton = true});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _fadeIn;

  List<SemesterResult>? _semesters;
  bool _isLoading = true;
  int _expandedSem = 0;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _loadResults();
  }

  Future<void> _loadResults() async {
    final results = await Provider.of<ResultsRepository>(context, listen: false).getResults();
    if (!mounted) return;
    setState(() {
      _semesters = results;
      _isLoading = false;
    });
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'O':  return const Color(0xFF4ECB71);
      case 'A+': return const Color(0xFF6C63FF);
      case 'A':  return const Color(0xFF00D4FF);
      case 'B+': return const Color(0xFFFFB347);
      default:   return const Color(0xFFFF6B6B);
    }
  }

  double _calcCGPA(List<SemesterResult> sems) {
    double totalPoints = 0;
    int totalCredits = 0;
    for (final sem in sems.where((s) => !s.isPending)) {
      for (final sub in sem.subjects) {
        if (sub.credit > 0) {
          totalPoints += sub.credit * sub.gradePoints;
          totalCredits += sub.credit;
        }
      }
    }
    return totalCredits == 0 ? 0 : totalPoints / totalCredits;
  }

  int _totalEarnedCredits(List<SemesterResult> sems) =>
      sems.where((s) => !s.isPending).fold(0, (sum, s) => sum + s.totalCredits);

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              const Color(0xFF6C63FF).withValues(alpha: 0.8),
            ),
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    final sems = _semesters!;
    final cgpa = _calcCGPA(sems);
    final earnedCredits = _totalEarnedCredits(sems);

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
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.white, size: 16),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Results',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                                  color: Colors.white, letterSpacing: -0.5)),
                          Text('Provisional Grades',
                              style: TextStyle(fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.35))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ─ CGPA Hero Card ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6C63FF).withValues(alpha: 0.2),
                          const Color(0xFF00D4FF).withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFF6C63FF).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CGPA', style: TextStyle(fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.4),
                                  letterSpacing: 3, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              ShaderMask(
                                shaderCallback: (b) => const LinearGradient(
                                  colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
                                ).createShader(b),
                                child: Text(cgpa.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 52,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white, height: 1, letterSpacing: -2)),
                              ),
                              const SizedBox(height: 4),
                              Text('${sems.where((s) => !s.isPending).length} semester completed',
                                  style: TextStyle(fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.35))),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 80,
                            color: Colors.white.withValues(alpha: 0.08),
                            margin: const EdgeInsets.symmetric(horizontal: 20)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CREDITS EARNED', style: TextStyle(fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.4),
                                  letterSpacing: 2, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text('$earnedCredits',
                                  style: const TextStyle(fontSize: 52,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white, height: 1, letterSpacing: -2)),
                              const SizedBox(height: 4),
                              Text('of 160 total', style: TextStyle(fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.35))),
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
                  child: Text('SEMESTER WISE RESULTS',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.35), letterSpacing: 3)),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 14)),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                    child: sems[i].isPending
                        ? _buildPendingCard(i)
                        : _buildSemCard(i, sems[i]),
                  ),
                  childCount: sems.length,
                ),
              ),

              // Disclaimer
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded, size: 16,
                            color: Colors.white.withValues(alpha: 0.25)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'These are provisional results for indicative purposes only. '
                            'Contact the exam cell for official transcripts.',
                            style: TextStyle(fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.25), height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 60)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingCard(int index) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Center(
              child: Text('S${index + 1}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900,
                      color: Colors.white.withValues(alpha: 0.25))),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Semester ${index + 1}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.35))),
                Text('Results not yet published',
                    style: TextStyle(fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.2))),
              ],
            ),
          ),
          Icon(Icons.lock_outline_rounded, size: 18,
              color: Colors.white.withValues(alpha: 0.15)),
        ],
      ),
    );
  }

  Widget _buildSemCard(int index, SemesterResult sem) {
    final isExpanded = _expandedSem == index;
    return GestureDetector(
      onTap: () => setState(() => _expandedSem = isExpanded ? -1 : index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isExpanded
                ? const Color(0xFF6C63FF).withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.07),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF6C63FF).withValues(alpha: 0.25)),
                  ),
                  child: Center(child: Text('S${index + 1}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900,
                          color: Color(0xFF6C63FF)))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sem.semester, style: const TextStyle(fontSize: 16,
                          fontWeight: FontWeight.w700, color: Colors.white)),
                      Text(sem.month, style: TextStyle(fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.35))),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(sem.sgpa.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900,
                            color: Color(0xFF4ECB71), letterSpacing: -0.5)),
                    Text('SGPA', style: TextStyle(fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.3),
                        letterSpacing: 2, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(width: 10),
                Icon(isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                    color: Colors.white38),
              ],
            ),

            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: sem.totalCredits / 160,
                      backgroundColor: Colors.white.withValues(alpha: 0.06),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                      minHeight: 5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text('${sem.totalCredits} credits',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.4))),
              ],
            ),

            if (isExpanded) ...[
              const SizedBox(height: 18),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.06)),
              const SizedBox(height: 16),
              // Header row
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(child: Text('SUBJECT', style: TextStyle(fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.3), letterSpacing: 2))),
                    SizedBox(width: 40, child: Text('CR', textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.3), letterSpacing: 2))),
                    SizedBox(width: 50, child: Text('GRADE', textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.3), letterSpacing: 2))),
                  ],
                ),
              ),
              ...sem.subjects.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.name, style: const TextStyle(fontSize: 12,
                              fontWeight: FontWeight.w600, color: Colors.white),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(s.code, style: TextStyle(fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.3))),
                        ],
                      ),
                    ),
                    SizedBox(width: 40, child: Text('${s.credit}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.5)))),
                    SizedBox(
                      width: 50,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getGradeColor(s.grade).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _getGradeColor(s.grade).withValues(alpha: 0.3)),
                          ),
                          child: Text(s.grade, style: TextStyle(fontSize: 12,
                              fontWeight: FontWeight.w800, color: _getGradeColor(s.grade))),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}

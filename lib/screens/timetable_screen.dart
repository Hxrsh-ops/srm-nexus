import 'package:flutter/material.dart';
import 'dart:math' as math;

class TimetableScreen extends StatefulWidget {
  final bool showBackButton;
  const TimetableScreen({super.key, this.showBackButton = true});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _pulseController;
  late Animation<double> _fadeIn;
  late Animation<double> _pulse;

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fadeIn = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _pulse = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);

    Future.delayed(
      const Duration(milliseconds: 120),
      () => _entryController.forward(),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Header ────────────────────────────────────────────────────
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
                      ] else ...[
                        GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                            ),
                            child: const Icon(Icons.menu_rounded, color: Colors.white, size: 18),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Schedule',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                                  color: Colors.white, letterSpacing: -0.5)),
                          Text('Class Timetable',
                              style: TextStyle(fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.35))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Day pills (decorative, greyed out) ────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: days.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) => AnimatedBuilder(
                        animation: _pulse,
                        builder: (context, _) => Opacity(
                          opacity: 0.2 + (i == 1 ? _pulse.value * 0.15 : 0),
                          child: Container(
                            width: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                            ),
                            child: Center(
                              child: Text(days[i],
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                                      color: Colors.white.withValues(alpha: 0.2))),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),

              // ── Main pending card ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AnimatedBuilder(
                    animation: _pulse,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF6C63FF).withValues(alpha: 0.12 + _pulse.value * 0.04),
                              const Color(0xFF00D4FF).withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF6C63FF).withValues(alpha: 0.2 + _pulse.value * 0.08),
                          ),
                        ),
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        // Orbit icon
                        _OrbitIcon(pulse: _pulse),
                        const SizedBox(height: 28),
                        const Text(
                          'Timetable Pending',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                              color: Colors.white, letterSpacing: -0.3),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Your class timetable will be available once\nSRM portal access is connected.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13.5,
                              color: Colors.white.withValues(alpha: 0.45), height: 1.6),
                        ),
                        const SizedBox(height: 28),
                        // Status pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB347).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFFFB347).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6, height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFB347),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Awaiting Server Access',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                                      color: Color(0xFFFFB347), letterSpacing: 0.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 28)),

              // ── What you'll see section ───────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('WHAT YOU\'LL GET',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.3), letterSpacing: 3)),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 14)),

              SliverList(
                delegate: SliverChildListDelegate([
                  _featureRow(Icons.access_time_rounded,   'Real-time class schedule',  'Track today\'s and upcoming classes',    const Color(0xFF6C63FF)),
                  _featureRow(Icons.notifications_rounded,  'Class reminders',            '5-min alerts before each class',        const Color(0xFF00D4FF)),
                  _featureRow(Icons.map_outlined,           'Classroom navigation',       'Find your class room on campus map',    const Color(0xFF4ECB71)),
                  _featureRow(Icons.swap_horiz_rounded,     'Substitution alerts',        'Know when a class is cancelled/moved',  const Color(0xFFFFB347)),
                ]),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureRow(IconData icon, String title, String sub, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(sub, style: TextStyle(fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.35))),
                ],
              ),
            ),
            Icon(Icons.lock_outline_rounded, size: 16,
                color: Colors.white.withValues(alpha: 0.12)),
          ],
        ),
      ),
    );
  }
}

// ── Animated orbit icon ────────────────────────────────────────────────────
class _OrbitIcon extends StatefulWidget {
  final Animation<double> pulse;
  const _OrbitIcon({required this.pulse});
  @override
  State<_OrbitIcon> createState() => _OrbitIconState();
}

class _OrbitIconState extends State<_OrbitIcon> with SingleTickerProviderStateMixin {
  late AnimationController _orbitCtrl;

  @override
  void initState() {
    super.initState();
    _orbitCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() {
    _orbitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110, height: 110,
      child: AnimatedBuilder(
        animation: Listenable.merge([_orbitCtrl, widget.pulse]),
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.12 + widget.pulse.value * 0.1),
                    width: 1.5,
                  ),
                ),
              ),
              // Inner ring
              Container(
                width: 76, height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF6C63FF).withValues(alpha: 0.2 + widget.pulse.value * 0.08),
                      Colors.transparent,
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.calendar_month_rounded,
                      color: Color(0xFF6C63FF), size: 30),
                ),
              ),
              // Orbiting dot
              Transform.rotate(
                angle: _orbitCtrl.value * 2 * math.pi,
                child: Transform.translate(
                  offset: const Offset(0, -44),
                  child: Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4FF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D4FF).withValues(alpha: 0.6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

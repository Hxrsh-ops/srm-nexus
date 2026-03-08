import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'dart:math' as math;
import 'dart:typed_data';
import 'screens/main_scaffold.dart';
import 'screens/srm_webview_login_screen.dart';

import 'package:provider/provider.dart';
import 'core/repositories/auth_repository.dart';
import 'core/repositories/attendance_repository.dart';
import 'core/repositories/timetable_repository.dart';
import 'core/services/mock_auth_service.dart';
import 'core/services/mock_attendance_service.dart';
import 'core/services/mock_timetable_service.dart';
import 'core/repositories/results_repository.dart';
import 'core/services/mock_results_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FlutterDisplayMode.setHighRefreshRate();
  } catch (e) {
    // Ignore if not supported (e.g., iOS or older Android)
  }
  
  runApp(
    MultiProvider(
        providers: [
          Provider<AuthRepository>(create: (_) => MockAuthService()),
          Provider<AttendanceRepository>(create: (_) => MockAttendanceService()),
        Provider<TimetableRepository>(create: (_) => MockTimetableService()),
        Provider<ResultsRepository>(create: (_) => MockResultsService()),
      ],
      child: const SRMNexusApp(),
    ),
  );
}

class SRMNexusApp extends StatelessWidget {
  const SRMNexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SRM Nexus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFF00D4FF),
        ),
      ),
      home: const MainScaffold(),
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

// ─── Animated Background Painter ───────────────────────────────────────────
class BackgroundPainter extends CustomPainter {
  final double animation;
  BackgroundPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Deep background
    paint.color = const Color(0xFF0A0A0F);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Glowing orb 1 — top right
    final orb1 =
        RadialGradient(
          colors: [
            const Color(0xFF6C63FF).withValues(alpha: 0.25),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(
            center: Offset(
              size.width * 0.85,
              size.height * 0.15 + math.sin(animation * 2 * math.pi) * 20,
            ),
            radius: 200,
          ),
        );
    paint.shader = orb1;
    canvas.drawCircle(
      Offset(
        size.width * 0.85,
        size.height * 0.15 + math.sin(animation * 2 * math.pi) * 20,
      ),
      200,
      paint,
    );

    // Glowing orb 2 — bottom left
    final orb2 =
        RadialGradient(
          colors: [
            const Color(0xFF00D4FF).withValues(alpha: 0.15),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(
            center: Offset(
              size.width * 0.1,
              size.height * 0.8 + math.cos(animation * 2 * math.pi) * 15,
            ),
            radius: 180,
          ),
        );
    paint.shader = orb2;
    canvas.drawCircle(
      Offset(
        size.width * 0.1,
        size.height * 0.8 + math.cos(animation * 2 * math.pi) * 15,
      ),
      180,
      paint,
    );

    paint.shader = null;

    // Subtle grid lines
    paint.color = Colors.white.withValues(alpha: 0.025);
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) =>
      oldDelegate.animation != animation;
}

// ─── Login Screen ────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _entryController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  final _regController = TextEditingController();
  final _passController = TextEditingController();
  final _captchaController = TextEditingController();
  bool _obscurePass = true; // Obscure password field
  bool _isLoading = false;
  Uint8List? _captchaBytes;

  @override
  void initState() {
    super.initState();
    // Only try to fetch CAPTCHA if the auth service supports it (non-null response)
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchCaptcha());

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slideUp = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entryController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );

    Future.delayed(const Duration(milliseconds: 200), () {
      _entryController.forward();
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _entryController.dispose();
    _regController.dispose();
    _passController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  Future<void> _fetchCaptcha() async {
    setState(() => _captchaBytes = null);
    final bytes = await Provider.of<AuthRepository>(context, listen: false).fetchCaptcha();
    if (mounted) setState(() => _captchaBytes = bytes);
  }

  void _handleLogin() async {
    // Drop the keyboard immediately to prevent Android window resize ghosting
    FocusScope.of(context).unfocus();
    
    // Require CAPTCHA code only when a real CAPTCHA image is loaded
    if (_regController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your credentials'),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    if (_captchaBytes != null && _captchaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter the verification code shown in the image'),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final authRepo = Provider.of<AuthRepository>(context, listen: false);
    final success = await authRepo.login(_regController.text, _passController.text, _captchaController.text);
    
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScaffold(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login Failed. Please check your credentials or CAPTCHA.'),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      _captchaController.clear();
      _fetchCaptcha();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return CustomPaint(
            painter: BackgroundPainter(_bgController.value),
            child: child,
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: size.height,
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideUp,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),

                        // ── Logo & Title ──────────────────────────────────
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6C63FF),
                                    Color(0xFF00D4FF),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF6C63FF,
                                    ).withValues(alpha: 0.5),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.school_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFF6C63FF),
                                          Color(0xFF00D4FF),
                                        ],
                                      ).createShader(bounds),
                                  child: const Text(
                                    'SRM NEXUS',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                ),
                                Text(
                                  'RAMAPURAM',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withValues(alpha: 0.4),
                                    letterSpacing: 4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 64),

                        // ── Headline ──────────────────────────────────────
                        Text(
                          'Welcome\nBack.',
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.05,
                            letterSpacing: -1.5,
                            shadows: [
                              Shadow(
                                color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                                blurRadius: 30,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in with your SRM credentials',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withValues(alpha: 0.45),
                            letterSpacing: 0.3,
                          ),
                        ),

                        const SizedBox(height: 52),

                        // ── Registration Field ────────────────────────────
                        _buildLabel('REGISTRATION NUMBER'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _regController,
                          hint: 'RA2411XXXXXXX',
                          icon: Icons.badge_outlined,
                          keyboardType: TextInputType.text,
                        ),

                        const SizedBox(height: 24),

                        // ── Password Field ────────────────────────────────
                        _buildLabel('PASSWORD'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _passController,
                          hint: '••••••••••',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscurePass,
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePass
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white38,
                              size: 20,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePass = !_obscurePass),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── CAPTCHA Field & Image ────────────────────────
                        _buildLabel('VERIFICATION CODE'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildTextField(
                                controller: _captchaController,
                                hint: 'Enter code',
                                icon: Icons.security_rounded,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: _fetchCaptcha,
                                child: Container(
                                  height: 58,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: _captchaBytes == null 
                                      ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white.withValues(alpha: 0.5)))
                                      : Image.memory(_captchaBytes!, fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ── Forgot Password ───────────────────────────────
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: const Color(0xFF6C63FF).withValues(alpha: 0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // ── Login Button ──────────────────────────────────
                        GestureDetector(
                          onTap: _isLoading ? null : _handleLogin,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _isLoading
                                    ? [
                                        const Color(
                                          0xFF6C63FF,
                                        ).withValues(alpha: 0.5),
                                        const Color(
                                          0xFF00D4FF,
                                        ).withValues(alpha: 0.5),
                                      ]
                                    : const [
                                        Color(0xFF6C63FF),
                                        Color(0xFF00D4FF),
                                      ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: _isLoading
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF6C63FF,
                                        ).withValues(alpha: 0.45),
                                        blurRadius: 25,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'SIGN IN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 3,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── OR Divider ─────────────────────────────────────
                        Row(
                          children: [
                            Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.07))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.25),
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.07))),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ── SRM Portal WebView Button ──────────────────────
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => SizedBox(
                                height: MediaQuery.of(context).size.height * 0.93,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                  child: SrmWebViewLoginScreen(
                                    onLoginSuccess: (cookies) {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (_) => const MainScaffold()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.open_in_browser_rounded, color: const Color(0xFF6C63FF), size: 20),
                                const SizedBox(width: 10),
                                const Text(
                                  'SIGN IN WITH SRM PORTAL',
                                  style: TextStyle(
                                    color: Color(0xFF6C63FF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ── Bottom disclaimer ─────────────────────────────
                        Center(
                          child: Text(
                            'SRM Institute of Science and Technology\nRamapuram, Chennai',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.2),
                              fontSize: 11,
                              letterSpacing: 0.5,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.white.withValues(alpha: 0.35),
        letterSpacing: 2.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.2),
            fontSize: 15,
          ),
          prefixIcon: Icon(icon, color: Colors.white38, size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}

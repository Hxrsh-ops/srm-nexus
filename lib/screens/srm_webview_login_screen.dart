import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SrmWebViewLoginScreen extends StatefulWidget {
  final Function(String cookies) onLoginSuccess;

  const SrmWebViewLoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<SrmWebViewLoginScreen> createState() => _SrmWebViewLoginScreenState();
}

class _SrmWebViewLoginScreenState extends State<SrmWebViewLoginScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _loginDetected = false;

  static const String _loginUrl =
      'https://sp.srmist.edu.in/srmiststudentportal/students/loginManager/youLogin.jsp';
  static const String _successPath = 'HRDSystem';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (url) async {
            if (mounted) setState(() => _isLoading = false);
            if (!_loginDetected && url.contains(_successPath)) {
              _loginDetected = true;
              await _captureAndReturn();
            }
          },
          onNavigationRequest: (req) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_loginUrl));
  }

  Future<void> _captureAndReturn() async {
    try {
      // Extract cookies from the WebView via JavaScript
      final rawCookies = await _controller.runJavaScriptReturningResult(
        'document.cookie',
      ) as String;

      // Also attempt to store them
      const storage = FlutterSecureStorage();
      await storage.write(
        key: 'srm_cookies',
        value: rawCookies.replaceAll('"', ''),
      );

      if (mounted) {
        widget.onLoginSuccess(rawCookies.replaceAll('"', ''));
      }
    } catch (_) {
      // Even if cookie capture fails, we detected success URL — proceed
      if (mounted) {
        widget.onLoginSuccess('');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      resizeToAvoidBottomInset: true,
      body: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0F),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SRM Student Portal',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Sign in with your SRM credentials',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Security badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECB71).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF4ECB71).withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_rounded,
                          size: 11,
                          color: Color(0xFF4ECB71),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'HTTPS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4ECB71),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Loading bar ────────────────────────────────────────────────
            if (_isLoading)
              LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFF6C63FF).withValues(alpha: 0.7),
                ),
                minHeight: 2,
              )
            else
              const SizedBox(height: 2),

            // ── WebView ────────────────────────────────────────────────────
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),

            // ── Footer hint ────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: const Color(0xFF0A0A0F),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'The app will automatically continue after you sign in',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.2),
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

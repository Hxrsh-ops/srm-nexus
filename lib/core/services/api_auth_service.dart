import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/student_model.dart';
import '../repositories/auth_repository.dart';

class ApiAuthService implements AuthRepository {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final Map<String, String> _cookies = {};
  String? _hdnCSRF;

  void _updateCookies(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      String cookieContext = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      var parts = cookieContext.split('=');
      if (parts.length >= 2) {
        _cookies[parts[0]] = parts[1];
      }
    }
  }

  String get _cookieString {
    return _cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
  }

  @override
  Future<Uint8List?> fetchCaptcha() async {
    try {
      // 1. Fetch login page to get tokens
      final response = await _client.get(Uri.parse('https://sp.srmist.edu.in/srmiststudentportal/students/loginManager/youLogin.jsp'));
      _updateCookies(response);

      final document = parser.parse(response.body);
      
      // Extract CSRF token
      final csrfInput = document.querySelector('input[name="hdnCSRF"]');
      if (csrfInput != null) {
        _hdnCSRF = csrfInput.attributes['value'];
      }

      // Extract Captcha URL from script
      String? captchaUrl;
      final scripts = document.querySelectorAll('script');
      for (var script in scripts) {
        if (script.text.contains('CAPTCHA_URL')) {
          final match = RegExp(r'''CAPTCHA_URL\s*=\s*["']([^"']+)["']''').firstMatch(script.text);
          if (match != null) {
            captchaUrl = match.group(1);
            break;
          }
        }
      }

      if (captchaUrl == null) return null;
      if (!captchaUrl.startsWith('http')) {
        captchaUrl = 'https://sp.srmist.edu.in' + captchaUrl;
      }

      // 2. Fetch Base64 Captcha
      final captchaRes = await _client.get(
        Uri.parse(captchaUrl),
        headers: {
          'Cookie': _cookieString,
          'X-Requested-With': 'XMLHttpRequest',
        },
      );

      _updateCookies(captchaRes);
      
      // The response is pure base64 text
      final base64String = captchaRes.body.trim();
      return base64Decode(base64String);

    } catch (e) {
      print('Fetch Captcha Error: $e');
      return null;
    }
  }

  @override
  Future<bool> login(String username, String password, [String? captcha]) async {
    if (captcha == null || _hdnCSRF == null) return false;

    try {
      final response = await _client.post(
        Uri.parse('https://sp.srmist.edu.in/srmiststudentportal/students/loginManager/youLogin.jsp'),
        headers: {
          'Cookie': _cookieString,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'txtAN': Uri.encodeComponent(username),
          'txtSK': Uri.encodeComponent(password),
          'hdnCaptcha': captcha,
          'csrfPreventionSalt': _hdnCSRF!,
          'txtPageAction': '1',
          'login': 'iamalsouser', // SRM's weird hardcoded override
          'passwd': 'password',   // SRM's weird hardcoded override
          'ccode': captcha,
        },
      );

      _updateCookies(response);

      // Verify if login was successful; usually a redirect or a specific token
      // If we see HRDSystem.jsp in the response or redirect, it's successful
      if (response.statusCode == 302 || 
          response.headers['location']?.contains('HRDSystem') == true ||
          response.body.contains('HRDSystem')) {
        
        // Save cookies for future runs
        await _storage.write(key: 'srm_cookies', value: _cookieString);
        await _storage.write(key: 'srm_csrf', value: _hdnCSRF!);
        return true;
      }
      
      // Fallback check: If the page doesn't contain the login form anymore
      final doc = parser.parse(response.body);
      if (doc.querySelector('input[name="passwd"]') == null) {
        await _storage.write(key: 'srm_cookies', value: _cookieString);
        await _storage.write(key: 'srm_csrf', value: _hdnCSRF!);
        return true;
      }

      return false;
    } catch (e) {
      print('Login Error: $e');
      return false;
    }
  }

  @override
  Future<StudentModel> getStudentProfile() async {
    // We will implement this next step
    return const StudentModel(
      name: 'Real User', registerNumber: 'N/A', department: 'N/A', semester: 1, section: 'N/A'
    );
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'srm_cookies');
    await _storage.delete(key: 'srm_csrf');
    _cookies.clear();
  }
}

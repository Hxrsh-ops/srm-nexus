import 'dart:typed_data';
import '../models/student_model.dart';
import '../repositories/auth_repository.dart';

class MockAuthService implements AuthRepository {
  @override
  Future<StudentModel> getStudentProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const StudentModel(
      name: 'Harshanth',
      registerNumber: 'RA2511026020400',
      department: 'B.Tech Computer Science (AIML)',
      semester: 2,
      section: 'D',
    );
  }

  @override
  Future<Uint8List?> fetchCaptcha() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return null; // Mock doesn't return a real CAPTCHA
  }

  @override
  Future<bool> login(String username, String password, [String? captcha]) async {
    await Future.delayed(const Duration(seconds: 1));
    // Accept any valid-looking password to simulate a bypass for prototyping
    return username.isNotEmpty && password.length >= 6;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Simulated logout
  }
}

import 'dart:typed_data';
import '../models/student_model.dart';

abstract class AuthRepository {
  Future<StudentModel> getStudentProfile();
  Future<Uint8List?> fetchCaptcha();
  Future<bool> login(String username, String password, [String? captcha]);
  Future<void> logout();
}

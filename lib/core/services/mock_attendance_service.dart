import 'dart:ui';
import '../models/attendance_model.dart';
import '../repositories/attendance_repository.dart';

class MockAttendanceService implements AttendanceRepository {
  @override
  Future<List<SubjectAttendance>> getSubjectAttendance() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network payload
    
    return const [
      SubjectAttendance(
        code: '21CSC101T',
        subject: 'OOP & Design',
        attended: 28,
        total: 28,
        type: 'Theory',
        color: Color(0xFF6C63FF),
      ),
      SubjectAttendance(
        code: '21CYB101J',
        subject: 'Chemistry',
        attended: 38,
        total: 39,
        type: 'Theory',
        color: Color(0xFF00D4FF),
      ),
      SubjectAttendance(
        code: '21CYM101T',
        subject: 'Env. Science',
        attended: 7,
        total: 7,
        type: 'Theory',
        color: Color(0xFF4ECB71),
      ),
      SubjectAttendance(
        code: '21EES101T',
        subject: 'Electrical Engg',
        attended: 27,
        total: 28,
        type: 'Theory',
        color: Color(0xFFFFB347),
      ),
      SubjectAttendance(
        code: '21LEH104T',
        subject: 'German',
        attended: 21,
        total: 23,
        type: 'Theory',
        color: Color(0xFFFF69B4),
      ),
      SubjectAttendance(
        code: '21LEM101T',
        subject: 'Constitution',
        attended: 7,
        total: 7,
        type: 'Theory',
        color: Color(0xFFB39DDB),
      ),
      SubjectAttendance(
        code: '21MAB102T',
        subject: 'Adv. Calculus',
        attended: 26,
        total: 29,
        type: 'Theory',
        color: Color(0xFFFF6B6B),
      ),
      SubjectAttendance(
        code: '21MES102L',
        subject: 'Engg Graphics',
        attended: 27,
        total: 32,
        type: 'Lab',
        color: Color(0xFFFFD54F),
      ),
    ];
  }

  @override
  Future<double> getOverallAttendance() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 93.75;
  }
}

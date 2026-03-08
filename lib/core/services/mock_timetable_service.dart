import 'dart:ui';
import '../models/class_model.dart';
import '../repositories/timetable_repository.dart';

class MockTimetableService implements TimetableRepository {
  @override
  Future<Map<int, List<ClassModel>>> getWeeklyTimetable() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return const {
      1: [
        ClassModel(time: '08:00 - 08:50', subject: 'OOP & Design', code: '21CSC101T', room: 'CB-301', type: 'Theory', color: Color(0xFF6C63FF)),
        ClassModel(time: '09:00 - 09:50', subject: 'Advanced Calculus', code: '21MAB102T', room: 'CB-205', type: 'Theory', color: Color(0xFF00D4FF)),
        ClassModel(time: '10:00 - 10:50', subject: 'Chemistry', code: '21CYB101J', room: 'Lab-12', type: 'Lab', color: Color(0xFFFF6B6B)),
        ClassModel(time: '11:00 - 11:50', subject: 'German', code: '21LEH104T', room: 'LH-104', type: 'Theory', color: Color(0xFFFFB347)),
        ClassModel(time: '14:00 - 14:50', subject: 'Electrical Engg', code: '21EES101T', room: 'CB-401', type: 'Theory', color: Color(0xFF4ECB71)),
      ],
      2: [
        ClassModel(time: '09:00 - 09:50', subject: 'Electrical Engg', code: '21EES101T', room: 'CB-401', type: 'Theory', color: Color(0xFF4ECB71)),
        ClassModel(time: '10:00 - 10:50', subject: 'OOP & Design', code: '21CSC101T', room: 'CB-301', type: 'Theory', color: Color(0xFF6C63FF)),
        ClassModel(time: '14:00 - 15:50', subject: 'Engg Graphics', code: '21MES102L', room: 'Mech-Lib', type: 'Lab', color: Color(0xFFFFD54F)),
      ],
      3: [
        ClassModel(time: '08:00 - 08:50', subject: 'German', code: '21LEH104T', room: 'LH-104', type: 'Theory', color: Color(0xFFFFB347)),
        ClassModel(time: '09:00 - 09:50', subject: 'Advanced Calculus', code: '21MAB102T', room: 'CB-205', type: 'Theory', color: Color(0xFF00D4FF)),
        ClassModel(time: '10:00 - 10:50', subject: 'Environmental Science', code: '21CYM101T', room: 'CB-102', type: 'Theory', color: Color(0xFFFF69B4)),
        ClassModel(time: '14:00 - 15:50', subject: 'Chemistry Lab', code: '21CYB101J', room: 'Chem-Lab1', type: 'Lab', color: Color(0xFFFF6B6B)),
      ],
      4: [
        ClassModel(time: '08:00 - 08:50', subject: 'OOP & Design', code: '21CSC101T', room: 'CB-301', type: 'Theory', color: Color(0xFF6C63FF)),
        ClassModel(time: '09:00 - 09:50', subject: 'Electrical Engg', code: '21EES101T', room: 'CB-401', type: 'Theory', color: Color(0xFF4ECB71)),
        ClassModel(time: '11:00 - 11:50', subject: 'Chemistry', code: '21CYB101J', room: 'CB-302', type: 'Theory', color: Color(0xFFFF6B6B)),
        ClassModel(time: '14:00 - 14:50', subject: 'Environmental Science', code: '21CYM101T', room: 'CB-102', type: 'Theory', color: Color(0xFFFF69B4)),
      ],
      5: [
        ClassModel(time: '09:00 - 09:50', subject: 'Advanced Calculus', code: '21MAB102T', room: 'CB-205', type: 'Theory', color: Color(0xFF00D4FF)),
        ClassModel(time: '10:00 - 10:50', subject: 'OOP & Design', code: '21CSC101T', room: 'Lab-08', type: 'Lab', color: Color(0xFF6C63FF)),
      ],
    };
  }
}

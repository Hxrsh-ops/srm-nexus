import '../models/attendance_model.dart';

abstract class AttendanceRepository {
  Future<List<SubjectAttendance>> getSubjectAttendance();
  Future<double> getOverallAttendance();
}

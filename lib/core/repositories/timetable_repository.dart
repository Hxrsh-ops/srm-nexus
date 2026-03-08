import '../models/class_model.dart';

abstract class TimetableRepository {
  Future<Map<int, List<ClassModel>>> getWeeklyTimetable();
}

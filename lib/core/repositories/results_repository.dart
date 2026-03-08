import '../models/results_model.dart';

abstract class ResultsRepository {
  /// Fetch all semester results for the logged-in student.
  Future<List<SemesterResult>> getResults();
}

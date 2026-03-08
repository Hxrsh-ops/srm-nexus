import '../models/results_model.dart';
import '../repositories/results_repository.dart';

class MockResultsService implements ResultsRepository {
  @override
  Future<List<SemesterResult>> getResults() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      SemesterResult(
        semester: 'Semester 1',
        month: 'December 2025',
        sgpa: 9.2,
        totalCredits: 22,
        subjects: [
          SubjectResult(code: '21LEH101T', name: 'Communicative English',       credit: 3, grade: 'O',  gradePoints: 10),
          SubjectResult(code: '21MAB101T', name: 'Calculus & Linear Algebra',   credit: 4, grade: 'A+', gradePoints: 9),
          SubjectResult(code: '21BTB102T', name: 'Intro to Computational Bio',  credit: 2, grade: 'A',  gradePoints: 8),
          SubjectResult(code: '21CSS101J', name: 'Programming for Problem Solving', credit: 4, grade: 'O', gradePoints: 10),
          SubjectResult(code: '21GNH101J', name: 'Philosophy of Engineering',   credit: 2, grade: 'O',  gradePoints: 10),
          SubjectResult(code: '21PYB102J', name: 'Semiconductor Physics',       credit: 5, grade: 'A+', gradePoints: 9),
          SubjectResult(code: '21MES101L', name: 'Basic Civil & Mech. Workshop',credit: 2, grade: 'O',  gradePoints: 10),
        ],
      ),
      SemesterResult(
        semester: 'Semester 2',
        month: 'May 2026',
        sgpa: 0,
        totalCredits: 0,
        subjects: [],
        isPending: true,
      ),
    ];
  }
}

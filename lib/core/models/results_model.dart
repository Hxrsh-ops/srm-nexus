class SubjectResult {
  final String code;
  final String name;
  final int credit;
  final String grade;
  final int gradePoints;

  const SubjectResult({
    required this.code,
    required this.name,
    required this.credit,
    required this.grade,
    required this.gradePoints,
  });
}

class SemesterResult {
  final String semester;
  final String month;
  final double sgpa;
  final int totalCredits;
  final List<SubjectResult> subjects;
  final bool isPending;

  const SemesterResult({
    required this.semester,
    required this.month,
    required this.sgpa,
    required this.totalCredits,
    required this.subjects,
    this.isPending = false,
  });
}

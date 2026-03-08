import 'package:flutter/material.dart';

class SubjectAttendance {
  final String subject;
  final String code;
  final int attended;
  final int total;
  final String type;
  final Color color;

  double get percentage => total > 0 ? (attended / total) * 100 : 0.0;

  const SubjectAttendance({
    required this.subject,
    required this.code,
    required this.attended,
    required this.total,
    required this.type,
    required this.color,
  });
}

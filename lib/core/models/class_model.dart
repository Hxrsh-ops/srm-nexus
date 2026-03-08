import 'package:flutter/material.dart';

class ClassModel {
  final String time;
  final String subject;
  final String code;
  final String room;
  final String type;
  final Color color;

  const ClassModel({
    required this.time,
    required this.subject,
    required this.code,
    required this.room,
    required this.type,
    required this.color,
  });
}

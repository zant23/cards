import 'dart:math';

import 'package:flutter/material.dart';

class Question {
  final int? id;
  final String side1;
  final String side2;

  final DateTime lastLearned;
  final int wasCorrectCount;
  DateTime get learnableFrom =>
      lastLearned.add(Duration(days: max(wasCorrectCount, 1)));

  Question.withAllFields(
      {required this.id,
      required this.side1,
      required this.side2,
      required this.lastLearned,
      required this.wasCorrectCount});

  Question({required this.side1, required this.side2})
      : id = null,
        lastLearned =
            DateUtils.dateOnly(DateTime.now().subtract(Duration(days: 1))),
        wasCorrectCount = 0;

  static Question fromMap(Map map) {
    return Question.withAllFields(
        id: map[QuestionFields.columnId],
        side1: map[QuestionFields.columnSide1],
        side2: map[QuestionFields.columnSide2],
        wasCorrectCount: map[QuestionFields.columnWasCorrectCount],
        lastLearned: DateTime.fromMillisecondsSinceEpoch(
            map[QuestionFields.columnLastLearned]));
  }

  Map<String, dynamic> toMap() => {
        QuestionFields.columnId: id,
        QuestionFields.columnSide1: side1,
        QuestionFields.columnSide2: side2,
        QuestionFields.columnWasCorrectCount: wasCorrectCount,
        QuestionFields.columnLastLearned: lastLearned.millisecondsSinceEpoch
      };

  Question copyWith(
      {int? id,
      String? side1,
      String? side2,
      DateTime? lastLearned,
      int? wasCorrectCount}) {
    return Question.withAllFields(
        id: id ?? this.id,
        side1: side1 ?? this.side1,
        side2: side2 ?? this.side2,
        lastLearned: lastLearned ?? this.lastLearned,
        wasCorrectCount: wasCorrectCount ?? this.wasCorrectCount);
  }
}

class QuestionFields {
  static const String tableName = 'questions';
  static const String columnId = '_id';
  static const String columnSide1 = 'side1';
  static const String columnSide2 = 'side2';
  static const String columnLastLearned = 'last_learned';
  static const String columnWasCorrectCount = 'correct_count';

  static const String queryCreateTable = '''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY,
            $columnSide1 TEXT NOT NULL,
            $columnSide2 TEXT NOT NULL,
            $columnWasCorrectCount INTEGER NOT NULL,
            $columnLastLearned INTEGER NOT NULL
          )
          ''';
}

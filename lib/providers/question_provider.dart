import 'dart:math';

import 'package:cards/models/question.dart';
import 'package:cards/services/question_service.dart';
import 'package:flutter/material.dart';

const maxCorrectCount = 40;

class QuestionProvider with ChangeNotifier {
  bool _isReady = false;
  List<Question> _questions = [];

  bool get isReady => _isReady;
  List<Question> get questions => List.unmodifiable(_questions);
  List<Question> get learnableQuestions => questions
      .where((question) => question.learnableFrom.isBefore(DateTime.now()))
      .toList();

  Future<void> _init() async {
    List<Question> questions = await QuestionService.questions;
    _questions.addAll(questions);
    _isReady = true;

    notifyListeners();
  }

  QuestionProvider() {
    _init();
  }

  Future<void> isCorrectAnswered(Question question) async {
    Question newQuestion = question.copyWith(
        lastLearned: DateTime.now(),
        wasCorrectCount: min(question.wasCorrectCount + 1, maxCorrectCount));

    await QuestionService.update(newQuestion);

    int index = _questions.indexOf(question);
    _questions.removeAt(index);
    _questions.insert(index, newQuestion);

    notifyListeners();
  }

  Future<void> isWrongAnswered(Question question) async {
    print('answered wrong');
    Question newQuestion = question.copyWith(
        lastLearned: DateTime.now(),
        wasCorrectCount: max(question.wasCorrectCount - 1, 0));

    await QuestionService.update(newQuestion);

    int index = _questions.indexOf(question);
    _questions.removeAt(index);
    _questions.insert(index, newQuestion);

    notifyListeners();
  }

  Future<void> editContent(
      {required Question question,
      required String side1,
      required String side2}) async {
    Question newQuestion = question.copyWith(side1: side1, side2: side2);
    await QuestionService.update(newQuestion);

    int index = _questions.indexOf(question);
    _questions.removeAt(index);
    _questions.insert(index, newQuestion);

    notifyListeners();
  }

  Future<void> add(Question question) async {
    int id = await QuestionService.insert(question);
    _questions.add(question.copyWith(id: id));
    notifyListeners();
  }

  Future<void> delete(Question question) async {
    await QuestionService.delete(question);
    _questions.remove(question);
    notifyListeners();
  }
}

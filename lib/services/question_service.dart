import 'package:cards/models/question.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String databaseName = 'questions.db';

class QuestionService {
  static Future<void> get isReady async => _db;
  static late Future<Database> _db = _getDB();

  static Future<Database> _getDB() async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), databaseName),
        onCreate: _onCreate,
        version: 1);

    return db;
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute(QuestionFields.queryCreateTable);
  }

  static bool _questionMatchesQuery(Question question,
      {required String query}) {
    if (query.isEmpty) return true;
    if (question.side1.toLowerCase().contains(query.toLowerCase())) return true;
    if (question.side2.toLowerCase().contains(query.toLowerCase())) return true;
    return false;
  }

  static Future<int> insert(Question question) async {
    Database db = await _db;

    return db.insert(QuestionFields.tableName, question.toMap());
  }

  static Future<void> update(Question question) async {
    Database db = await _db;

    await db.update(QuestionFields.tableName, question.toMap(),
        where: '${QuestionFields.columnId} = ?', whereArgs: [question.id]);
  }

  static Future<void> delete(Question question) async {
    Database db = await _db;

    await db.delete(QuestionFields.tableName,
        where: '${QuestionFields.columnId} = ?', whereArgs: [question.id]);
  }

  static Future<List<Question>> all() async {
    Database db = await _db;

    List<Map<String, dynamic>> maps = await db.query(QuestionFields.tableName);

    return List.generate(maps.length, (index) => Question.fromMap(maps[index]));
  }

  static Future<List<Question>> filtered({required String query}) async {
    Database db = await _db;

    List<Map<String, dynamic>> maps = await db.query(QuestionFields.tableName,
        where:
            '${QuestionFields.columnSide1} LIKE ? OR ${QuestionFields.columnSide2} like ?',
        whereArgs: [query, query]);

    return List.generate(maps.length, (index) => Question.fromMap(maps[index]));
  }

  static List<Question> filterLocally(List<Question> questions,
      {required String query}) {
    return query.isNotEmpty
        ? questions
            .where((question) => _questionMatchesQuery(question, query: query))
            .toList()
        : questions;
  }
}

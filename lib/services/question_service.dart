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

  static Future<List<Question>> get questions async {
    Database db = await _db;
    List<Map<String, dynamic>> maps = await db.query(QuestionFields.tableName);
    return List.generate(maps.length, (index) => Question.fromMap(maps[index]));
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
}

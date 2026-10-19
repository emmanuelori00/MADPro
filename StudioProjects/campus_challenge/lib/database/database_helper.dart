import 'dart:ffi';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/challenge.dart';
import '../models/progress_log.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
  DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    _database =
    await _initDB('campus_challenge.db');

    return _database!;
  }

  Future<Database> _initDB(
      String filePath) async {

    final dbPath =
    await getDatabasesPath();

    final path =
    join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(
      Database db,
      int version) async {

    await db.execute('''
      CREATE TABLE Challenge(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        targetUnits INTEGER NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ProgressLog(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        challengeId INTEGER NOT NULL,
        loggedAt TEXT NOT NULL,
        units INTEGER NOT NULL,
        note TEXT,
        FOREIGN KEY(challengeId)
        REFERENCES Challenge(id)
        ON DELETE CASCADE
      )
    ''');
  }

  // ==========================
  // CHALLENGE CRUD
  // ==========================

  Future<int> insertChallenge(
      Map<String, dynamic> challenge) async {

    final db = await instance.database;

    return await db.insert(
      'Challenge',
      challenge,
    );
  }

  Future<List<Challenge>>
  getAllChallenges() async {

    final db = await instance.database;

    final result =
    await db.query('Challenge');

    return result
        .map(
          (json) =>
          Challenge.fromMap(json),
    )
        .toList();
  }

  Future<int> updateChallenge(
      Map<String, dynamic> challenge) async {

    final db = await instance.database;

    return await db.update(
      'Challenge',
      challenge,
      where: 'id = ?',
      whereArgs: [challenge['id']],
    );
  }

  Future<int> deleteChallenge(
      int id) async {

    final db = await instance.database;

    return await db.delete(
      'Challenge',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================
  // PROGRESS LOG CRUD
  // ==========================

  Future<int> insertProgressLog(
      Map<String, dynamic> log) async {

    final db = await instance.database;

    return await db.insert(
      'ProgressLog',
      log,
    );
  }

  Future<List<ProgressLog>>
  getProgressLogs(
      int challengeId) async {

    final db = await instance.database;

    final result = await db.query(
      'ProgressLog',
      where: 'challengeId = ?',
      whereArgs: [challengeId],
    );

    return result
        .map(
          (json) =>
          ProgressLog.fromMap(json),
    )
        .toList();
  }

  Future<int> updateProgressLog(
      Map<String, dynamic> log) async {

    final db = await instance.database;

    return await db.update(
      'ProgressLog',
      log,
      where: 'id = ?',
      whereArgs: [log['id']],
    );
  }

  Future<int> deleteProgressLog(
      int id) async {

    final db = await instance.database;

    return await db.delete(
      'ProgressLog',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================
  // AGGREGATE FUNCTIONS
  // ==========================

  Future<int> getTotalProgress(
      int challengeId) async {

    final logs =
    await getProgressLogs(
      challengeId,
    );

    int total = 0;

    for (var log in logs) {
      total += log.units;
    }

    return total;
  }
  Future<bool> isChallengeComplete(
    Challenge challenge) async {

  if (challenge.id == null) {
    return false;
  }

  final total =
      await getTotalProgress(
    challenge.id!,
  );

  return total >=
      challenge.targetUnits;
}

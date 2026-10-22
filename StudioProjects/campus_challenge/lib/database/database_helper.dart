import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/challenge.dart';
import '../models/progress_log.dart';
import '../models/workout_plan.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
  DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database =
    await _initDB('campus_challenge.db');

    return _database!;
  }

  Future<Database> _initDB(
      String filePath,
      ) async {
    final dbPath =
    await getDatabasesPath();

    final path =
    join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(
      Database db,
      int version,
      ) async {
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

    await db.execute('''
      CREATE TABLE workout_plans(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        goal TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // ==========================
  // CHALLENGE CRUD
  // ==========================

  Future<int> insertChallenge(
      Map<String, dynamic> challenge,
      ) async {
    final db = await database;

    return await db.insert(
      'Challenge',
      challenge,
    );
  }

  Future<List<Challenge>>
  getAllChallenges() async {
    final db = await database;

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
      Map<String, dynamic> challenge,
      ) async {
    final db = await database;

    return await db.update(
      'Challenge',
      challenge,
      where: 'id = ?',
      whereArgs: [challenge['id']],
    );
  }

  Future<int> deleteChallenge(
      int id,
      ) async {
    final db = await database;

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
      Map<String, dynamic> log,
      ) async {
    final db = await database;

    return await db.insert(
      'ProgressLog',
      log,
    );
  }

  Future<List<ProgressLog>>
  getProgressLogs(
      int challengeId,
      ) async {
    final db = await database;

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
      Map<String, dynamic> log,
      ) async {
    final db = await database;

    return await db.update(
      'ProgressLog',
      log,
      where: 'id = ?',
      whereArgs: [log['id']],
    );
  }

  Future<int> deleteProgressLog(
      int id,
      ) async {
    final db = await database;

    return await db.delete(
      'ProgressLog',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================
  // WORKOUT PLAN CRUD
  // ==========================

  Future<int> insertWorkoutPlan(
      WorkoutPlan plan,
      ) async {
    final db = await database;

    return await db.insert(
      'workout_plans',
      plan.toMap(),
    );
  }

  Future<List<WorkoutPlan>>
  getWorkoutPlans() async {
    final db = await database;

    final maps =
    await db.query('workout_plans');

    return maps
        .map(
          (map) =>
          WorkoutPlan.fromMap(map),
    )
        .toList();
  }

  Future<WorkoutPlan?>
  getWorkoutPlan(
      int id,
      ) async {
    final db = await database;

    final maps = await db.query(
      'workout_plans',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return WorkoutPlan.fromMap(
        maps.first,
      );
    }

    return null;
  }

  Future<int> updateWorkoutPlan(
      WorkoutPlan plan,
      ) async {
    final db = await database;

    return await db.update(
      'workout_plans',
      plan.toMap(),
      where: 'id = ?',
      whereArgs: [plan.id],
    );
  }

  Future<int> deleteWorkoutPlan(
      int id,
      ) async {
    final db = await database;

    return await db.delete(
      'workout_plans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================
  // AGGREGATE FUNCTIONS
  // ==========================

  Future<int> getTotalProgress(
      int challengeId,
      ) async {
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

  Future<bool>
  isChallengeComplete(
      Challenge challenge,
      ) async {
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
}
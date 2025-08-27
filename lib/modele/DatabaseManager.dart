import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modele/Redacteur.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  Database? _database;
  static const String tableName = 'redacteurs';

  DatabaseManager._internal();

  factory DatabaseManager() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'redacteurs.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDatabase,
        onOpen: (db) {
          print('Base de données ouverte avec succès');
        },
      );
    } catch (e) {
      print('Erreur lors de l\'initialisation de la base de données: $e');
      rethrow;
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nom TEXT NOT NULL,
          prenom TEXT NOT NULL,
          email TEXT NOT NULL
        )
      ''');
      print('Table $tableName créée avec succès');
    } catch (e) {
      print('Erreur lors de la création de la table: $e');
      rethrow;
    }
  }

  Future<List<Redacteur>> getAllRedacteurs() async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(tableName);
      print('${maps.length} rédacteurs récupérés de la base de données');
      return List.generate(maps.length, (i) {
        return Redacteur.fromMap(maps[i]);
      });
    } catch (e) {
      print('Erreur lors de la récupération des rédacteurs: $e');
      return [];
    }
  }

  Future<int> insertRedacteur(Redacteur redacteur) async {
    try {
      final Database db = await database;
      final int id = await db.insert(tableName, redacteur.toMap());
      print('Rédacteur inséré avec l\'ID: $id');
      return id;
    } catch (e) {
      print('Erreur lors de l\'insertion du rédacteur: $e');
      return -1;
    }
  }

  Future<int> updateRedacteur(Redacteur redacteur) async {
    try {
      final Database db = await database;
      final int count = await db.update(
        tableName,
        redacteur.toMap(),
        where: 'id = ?',
        whereArgs: [redacteur.id],
      );
      print('$count rédacteur(s) mis à jour');
      return count;
    } catch (e) {
      print('Erreur lors de la mise à jour du rédacteur: $e');
      return -1;
    }
  }

  Future<int> deleteRedacteur(int id) async {
    try {
      final Database db = await database;
      final int count = await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      print('$count rédacteur(s) supprimé(s)');
      return count;
    } catch (e) {
      print('Erreur lors de la suppression du rédacteur: $e');
      return -1;
    }
  }
}
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/academic_model.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // Membuka atau membuat database SQLite.
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'nabila_akademik.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  // Membuat tabel akun dan tabel informasi akademik.
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        full_name TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE academic_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        image TEXT NOT NULL,
        additional_info TEXT NOT NULL
      )
    ''');

    // Data contoh agar Dashboard tidak kosong saat pertama dibuka.
    final sampleData = [
      {
        'title': 'Jadwal Kuliah',
        'description':
            'Informasi jadwal perkuliahan mahasiswa untuk membantu '
            'mengatur kegiatan belajar setiap minggu.',
        'category': 'Jadwal',
        'image': 'assets/images/jadwal_kuliah.png',
        'additional_info': 'Semester berjalan',
      },
      {
        'title': 'Mata Kuliah',
        'description':
            'Daftar mata kuliah yang dipelajari selama semester '
            'berjalan dalam program studi.',
        'category': 'Mata Kuliah',
        'image': 'assets/images/mata_kuliah.png',
        'additional_info': 'Program Studi Sistem Informasi',
      },
      {
        'title': 'Nilai Akademik',
        'description':
            'Informasi nilai akademik mahasiswa untuk memantau '
            'hasil pembelajaran.',
        'category': 'Nilai',
        'image': 'assets/images/nilai_akademik.png',
        'additional_info': 'Rekap nilai semester',
      },
      {
        'title': 'Informasi Kampus',
        'description':
            'Informasi umum seputar kegiatan dan layanan akademik '
            'yang dapat membantu mahasiswa.',
        'category': 'Informasi',
        'image': 'assets/images/kampus.png',
        'additional_info': 'Layanan akademik mahasiswa',
      },
    ];

    for (final item in sampleData) {
      await db.insert('academic_items', item);
    }
  }

  // =========================
  // REGISTRASI PENGGUNA
  // =========================

  Future<int> registerUser({
    required String username,
    required String fullName,
    required String password,
  }) async {
    final db = await database;

    return await db.insert(
      'users',
      {
        'username': username.trim(),
        'full_name': fullName.trim(),
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // =========================
  // MEMERIKSA LOGIN
  // =========================

  Future<Map<String, dynamic>?> loginUser({
    required String username,
    required String password,
  }) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username.trim(), password],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  // Memeriksa apakah username sudah digunakan.
  Future<bool> usernameExists(String username) async {
    final db = await database;

    final result = await db.query(
      'users',
      columns: ['id'],
      where: 'username = ?',
      whereArgs: [username.trim()],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // =========================
  // READ: MEMBACA DATA AKADEMIK
  // =========================

  Future<List<AcademicModel>> getAcademicItems() async {
    final db = await database;

    final result = await db.query(
      'academic_items',
      orderBy: 'id DESC',
    );

    return result.map((row) => AcademicModel.fromMap(row)).toList();
  }

  Future<AcademicModel?> getAcademicById(int id) async {
    final db = await database;

    final result = await db.query(
      'academic_items',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return AcademicModel.fromMap(result.first);
  }

  // =========================
  // CREATE: MENAMBAHKAN DATA
  // =========================

  Future<int> insertAcademic(AcademicModel item) async {
    final db = await database;
    final data = item.toMap();

    data.remove('id');

    return await db.insert('academic_items', data);
  }

  // =========================
  // UPDATE: MENGUBAH DATA
  // =========================

  Future<int> updateAcademic(AcademicModel item) async {
    if (item.id == null) {
      throw ArgumentError('ID data akademik tidak boleh kosong.');
    }

    final db = await database;
    final data = item.toMap();

    data.remove('id');

    return await db.update(
      'academic_items',
      data,
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  // =========================
  // DELETE: MENGHAPUS DATA
  // =========================

  Future<int> deleteAcademic(int id) async {
    final db = await database;

    return await db.delete(
      'academic_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

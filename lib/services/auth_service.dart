import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuthService {
  static const String authTable = 'admin_auth';
  static Database? _database;

  // التجزئة الآمنة لكلمة المرور الافتراضية
  // يمكن تغييرها لاحقًا من التطبيق
  static const String defaultPasswordHash = 'admin123'; // سيتم تجزئتها عند الاستخدام

  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'rafiq_auth.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $authTable (
        id TEXT PRIMARY KEY,
        adminEmail TEXT NOT NULL,
        passwordHash TEXT NOT NULL,
        isLoggedIn INTEGER NOT NULL DEFAULT 0,
        lastLoginTime TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Initialize with default admin credentials
    await _initializeDefaultAdmin(db);
  }

  static Future<void> _initializeDefaultAdmin(Database db) async {
    final hashedPassword = _hashPassword('admin@rafiq123');
    
    await db.insert(
      authTable,
      {
        'id': 'admin_primary',
        'adminEmail': 'admin@rafiqstudent.app',
        'passwordHash': hashedPassword,
        'isLoggedIn': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // تجزئة كلمة المرور باستخدام SHA-256
  static String _hashPassword(String password) {
    return sha256.convert(password.codeUnits).toString();
  }

  // التحقق من بيانات الدخول
  static Future<bool> authenticate(String email, String password) async {
    try {
      final db = await database;
      final hashedPassword = _hashPassword(password);

      final result = await db.query(
        authTable,
        where: 'adminEmail = ? AND passwordHash = ?',
        whereArgs: [email, hashedPassword],
      );

      if (result.isNotEmpty) {
        // تحديث وقت آخر تسجيل دخول
        await db.update(
          authTable,
          {
            'isLoggedIn': 1,
            'lastLoginTime': DateTime.now().toIso8601String(),
          },
          where: 'adminEmail = ?',
          whereArgs: [email],
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Authentication error: $e');
      return false;
    }
  }

  // التحقق من حالة تسجيل الدخول
  static Future<bool> isAdminLoggedIn() async {
    try {
      final db = await database;
      final result = await db.query(
        authTable,
        where: 'isLoggedIn = ?',
        whereArgs: [1],
      );
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // تسجيل الخروج
  static Future<void> logout() async {
    try {
      final db = await database;
      await db.update(
        authTable,
        {'isLoggedIn': 0},
        where: 'isLoggedIn = ?',
        whereArgs: [1],
      );
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // تغيير كلمة المرور
  static Future<bool> changePassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final isAuthenticated = await authenticate(email, oldPassword);
      if (!isAuthenticated) {
        return false;
      }

      final db = await database;
      final newPasswordHash = _hashPassword(newPassword);

      await db.update(
        authTable,
        {
          'passwordHash': newPasswordHash,
          'updatedAt': DateTime.now().toIso8601String(),
        },
        where: 'adminEmail = ?',
        whereArgs: [email],
      );
      return true;
    } catch (e) {
      print('Change password error: $e');
      return false;
    }
  }

  // الحصول على بيانات المسؤول الحالي
  static Future<Map<String, dynamic>?> getAdminData() async {
    try {
      final db = await database;
      final result = await db.query(
        authTable,
        where: 'isLoggedIn = ?',
        whereArgs: [1],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      return null;
    }
  }
}

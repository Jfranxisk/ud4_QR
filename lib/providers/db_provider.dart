import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();
  Future<Database> get database async { 
    if(_database == null) _database = await initDB(); 
    return _database!;
  }

  Future<Database> initDB () async {
    //Obtenir PATH
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'Scans.db');
    print(path);

    //Creacio de BBDD
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipus TEXT,
            valor TEXT
          )
        ''');
      }
    );
  }

  Future<int> insertRawScan(ScanModel nowScan) async {
    final id = nowScan.id;
    final tipus = nowScan.tipus;
    final valor = nowScan.valor;

    final db = await database;
    final res = await db.rawInsert('''
      INSERT INTO Scans(id, tipus, valor)
        VALUES ($id, $tipus, $valor)
    ''');
    return res;
  }
  
  Future<int> insertScan(ScanModel nouScan) async {
    final db = await database;
    final res = await db.insert('Scans', nouScan.toMap());
    print('insert ${res}');
    return res;
  }

  Future<List<ScanModel>> getScans() async {
    final db = await database;
    final res = await db.query('Scans');
    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db.query(
      'Scans', 
      where: 'id = ?', 
      whereArgs: [id]
    );
    print(res.isNotEmpty ? ScanModel.fromMap(res.first) : null);
    return res.isNotEmpty ? ScanModel.fromMap(res.first) : null;
  }

  //TODO: Select per tipus
  Future<List<ScanModel>> getScanByTipus(String tipus) async {
    final db = await database;
    final res = await db.query(
      'Scans', 
      where: 'tipus = ?', 
      whereArgs: [tipus]
    );
    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  Future<int> updateScan(ScanModel nouScan) async {
    final db = await database;
    final res = await db.update(
      'Scans', 
      nouScan.toMap(), 
      where: 'id = ?', 
      whereArgs: [nouScan.id]
    );
    return res;
  }

  Future<int> deleteScans() async { 
    final db = await database;
    final res = await db.rawDelete('''
      DELETE FROM Scans
    ''');
    print('delete: ${res} registres');
    return res;
  }

  //TODO: Delete per ID
  Future<int> deleteScanById(int id) async {
    final db = await database;
    final res = await db.delete(
      'Scans',
      where: 'id = ?',
      whereArgs: [id]
    );
    print('delete ID: ${res}');
    return res;
  }
}
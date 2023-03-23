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
            id INTEGER PRYMARY KEY,
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

}
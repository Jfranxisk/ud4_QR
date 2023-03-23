import 'package:flutter/cupertino.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipusSeleccionat = 'http';

  Future<ScanModel> nouScan(String valor) async {
    final nouScan = ScanModel(valor: valor);
    final id = await DBProvider.db.insertScan(nouScan);
    nouScan.id = id;
    if(nouScan.tipus == tipusSeleccionat) {
      this.scans.add(nouScan);
      notifyListeners();
    }
    return nouScan;
  }

  printScans() async {
    final scans = await DBProvider.db.getScans();
    this.scans = [...scans];
    notifyListeners();
  }

  //TODO: 
  printScansTipus(String tipus) async {
    final scans = await DBProvider.db.getScanByTipus(tipus);
    this.scans = [...scans]; 
    this.tipusSeleccionat = tipus;
    notifyListeners();
  }

  deleteAllScans() async {
    final scans = await DBProvider.db.deleteScans();
    if(scans != 0) this.scans = [];
    notifyListeners();
  }

  deleteScanId(int id) async{
    await DBProvider.db.deleteScanById(id);
    scans.removeWhere((scan) => scan.id == id);
    notifyListeners();
  }
}
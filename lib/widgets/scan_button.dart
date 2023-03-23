import 'package:flutter/material.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';
import '../models/scan_model.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      foregroundColor: Colors.white,
      child: Icon(
        Icons.filter_center_focus,
      ),
      onPressed: () {
        //Poner async el metodo en caso de usar el barcode Scanner.
        print('Botó polsat!');
        String barcodeScanRes = "https://paucasesnovescifp.cat/";
        //String barcodeScanRes = "geo:39.71888888787184,2.8669785598792794";
        //String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#3D8BEF', 'Cancelar', false, ScanMode.QR);

        final scanListProvider = Provider.of<ScanListProvider>(context, listen:false);
        ScanModel nouScan = ScanModel(valor: barcodeScanRes);
        scanListProvider.nouScan(barcodeScanRes);
        goURL(context, nouScan);
      },
    );
  }
}

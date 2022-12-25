

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tex_app/Components/custom_appbar_scan.dart';
import 'package:tex_app/Models/order.dart';
import 'package:tex_app/Screens/order_screen.dart';
import 'package:tex_app/constans.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key, required this.scanResult, required this.orden});
  final String scanResult;
  final Order orden;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
 String? scanResult;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppBar().preferredSize.height),
            child:  CustomAppBarScan(              
              press: () => goOrden(), titulo: const Text(''),    image: const AssetImage('assets/newPedidoAppBar.png'),
            ),
          ),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: kContrastColor, backgroundColor: kPrimaryColor,
              ),
             icon: const Icon(Icons.camera_alt_outlined),
             label: const Text('Escanear Codigo', style: TextStyle(fontSize: 25),),
             onPressed: scanBarCode, 
             ),
          ),
           Text(scanResult==null ? 'Codigo' : 'Codigo: $scanResult',
            style: const TextStyle(fontSize: 18),
           ),
              Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: kContrastColor, backgroundColor: kPrimaryColor,
              ),
             icon: const Icon(Icons.arrow_back),
             label: const Text('Enter', style: TextStyle(fontSize: 25),),
             onPressed: scanBarCode, 
             ),
          ),


          ]
        ),
      ),

    );
  }

  Future scanBarCode() async {
  try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
  } on PlatformException{
    scanResult='Fallo al obtener la versin de plataforma.';
  }
  if(!mounted) return;

  setState(() {
   scanResult=scanResult;
     });
    
  }
  
  goOrden() {
      var scan = scanResult??'';
     if(scan.isNotEmpty){
     }
      Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) =>  OrderScreen(orden: widget.orden, codigo: scan,)
      )
    );
  }
}
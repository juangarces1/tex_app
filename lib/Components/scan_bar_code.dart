import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tex_app/constans.dart';

class ScanBarCode extends StatelessWidget {
   final Function? press;
  const ScanBarCode({super.key, this.press});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press as void Function()?,
      child: Padding(
        padding: const EdgeInsets.only(left: 45, right: 45, top: 35, bottom: 10),
        child: Container(
        
        height: 50,
        decoration:  const BoxDecoration(
          borderRadius:  BorderRadius.all(Radius.circular(10)),
          gradient: kGradientTexApp,
          
        ),
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                const Icon(Icons.camera_alt_outlined, size: 30, color: Colors.white,),
                const SizedBox(width: 10,),
                Text('Escanear Codigo', style:  GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
            ]),                                           
      
          ),
        ),
      ),
    );          
  }
}
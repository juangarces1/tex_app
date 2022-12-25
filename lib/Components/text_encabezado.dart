import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:tex_app/constans.dart';

class TextEncabezado extends StatelessWidget {
  const TextEncabezado({super.key, required this.texto});
  final String texto;

  @override
  Widget build(BuildContext context) {
     return Text(
      texto,
       style: GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 15, fontWeight: FontWeight.bold, color: kPrimaryColor),
    );
  }
}
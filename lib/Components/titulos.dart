
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitulosText extends StatelessWidget {
  const TitulosText({super.key, required this.color, required this.fontSize, required this.text});
  final Color color;
  final double fontSize;
  final String text;
  
  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: fontSize, fontWeight: FontWeight.w500, color: color));
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tex_app/constans.dart';


class AppBarHome extends StatelessWidget {
  const AppBarHome({super.key});
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return Container(
     
     padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        
        gradient: kGradientHome,
      
      ),
      child: Center(child: Text('TexAPP' , style:  GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))),
    );
  }
}
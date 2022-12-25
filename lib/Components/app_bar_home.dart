import 'package:flutter/material.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';


class AppBarHome extends StatelessWidget {
  const AppBarHome({super.key});
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return Container(
     // color: kColorHomeBar,
      decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/AppBarBack.png"),
                  fit: BoxFit.cover,
                ),),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20), vertical: getProportionateScreenHeight(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           
           
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:  const [
                  Text('TexApp' , style:  TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kPrimaryColor),),
                  SizedBox(width: 5),
                
                ],
              ),
            )
          ],
        ),
      ),
      );
  }
}
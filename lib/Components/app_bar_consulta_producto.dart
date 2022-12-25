import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constans.dart';
import '../../../sizeconfig.dart';

class AppBarProducto extends StatefulWidget {
  final Function? press;
  final Text titulo;
  final Function? btnPress; 
  final AssetImage image;
<<<<<<< HEAD
=======

>>>>>>> 8045f2a4496db0d44227c02c2305c6b3a7e1fb03
  const AppBarProducto({super.key, 
    this.press, required this.titulo,  required this.image, this.btnPress
  });

  @override
  State<AppBarProducto> createState() => _AppBarProductoState();
}

class _AppBarProductoState extends State<AppBarProducto> {

  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override

  Widget build(BuildContext context) {
    return Container(
       decoration:  BoxDecoration(
               image: DecorationImage(
                 image: widget.image,
                 fit: BoxFit.cover,
               ),),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20), vertical: getProportionateScreenHeight(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(40),
              width: getProportionateScreenWidth(40),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: kPrimaryColor, shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  backgroundColor:  Colors.white,
                  padding: EdgeInsets.zero,
                ),
                onPressed: widget.press as void Function()?,             
                                          
                child: SvgPicture.asset(
                  "assets/Back ICon.svg",
                  height: 15,
                  color: kPrimaryColor,
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  widget.titulo,
                  const SizedBox(width: 5),
                
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
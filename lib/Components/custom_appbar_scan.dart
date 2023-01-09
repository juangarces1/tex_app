
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constans.dart';
import '../../../sizeconfig.dart';

class CustomAppBarScan extends StatefulWidget { 
 
  final Function? press;
  final Text titulo;
 
  final AssetImage image;
  // ignore: use_key_in_widget_constructors
  const CustomAppBarScan({
    this.press, required this.titulo,  required this.image
  });

  @override
  State<CustomAppBarScan> createState() => _CustomAppBarScanState();
}

class _CustomAppBarScanState extends State<CustomAppBarScan> {
  // AppBar().preferredSize.height provide us the height that appy on our app bar
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return Container(
     
    
        decoration:  const BoxDecoration(
          gradient: kGradientAppBarHome,
                ),
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
          
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 39, 38, 38).withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child:   Center(child: widget.titulo),
                 
            )
          ],
        ),
      ),
    );
  }

 
}
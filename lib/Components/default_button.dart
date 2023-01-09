

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constans.dart';




class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
          
          onPressed: press as void Function()?,
          style: ElevatedButton.styleFrom(
             elevation: 8,
              shadowColor: Colors.black,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Ink(
            decoration: BoxDecoration(
                gradient:
                   kGradientTexApp,
                borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: 170,
              height: 50,
              alignment: Alignment.center,
              child:  Text(
                text!,
                style:
                     GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)
              ),
            ),
          ),
        );      
  }
}
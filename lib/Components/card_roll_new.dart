
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:tex_app/Models/roll.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

class CardRollNew extends StatefulWidget {
  const CardRollNew({super.key, required this.roll,  this.press});
  final Roll roll;
  final Function()?  press;

  @override
  State<CardRollNew> createState() => _CardRollNewState();
}

class _CardRollNewState extends State<CardRollNew> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
    padding: EdgeInsets.only(left: getProportionateScreenWidth(20), bottom: 10),
    child:  Stack(
      children: [
       Card(
          color:kContrastColor,
          shadowColor: kPrimaryColor,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 50, bottom: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Row(children: [
                  Text(
                    'Producto: ',
                     style:  TextStyle(
                      color: kPrimaryColor,
                      fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                    ),                      
                    ),
                  Text(
                       //aqui deberia ir la descripcion 
                    //pero por algun motivo se pierde cuando
                    //refresca el estado
                    widget.roll.medida!.toString(),
                    style:  TextStyle(
                      color: kTextColorBlack,
                      fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w500,
                    ),                      
                  ),
                 ],
                ),  

                  Row(children: [
                  Text(
                    'Color: ',
                    style:  TextStyle(
                      color: kPrimaryColor,
                      fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                    ),                      
                    ),
                  Text(
                    widget.roll.product!.color!.toString(),
                    style:  TextStyle(
                      color: kTextColorBlack,
                      fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w500,
                    ),                      
                  ),
                 ],
                ),  

                Row(children: [
                  Text(
                    'Cantidad: ',
                    style:  TextStyle(
                      color: kPrimaryColor,
                      fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                    ),                      
                    ),
                  Text(
                    widget.roll.cantidad.toString(),
                    style:  TextStyle(
                      color: kTextColorBlack,
                      fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w500,
                    ),                      
                  ),
                 ],
                ),
              
                Row(children: [
                  Text(
                    'Precio: ',
                    style:  TextStyle(
                      color: kPrimaryColor,
                      fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                    ),        
                  ),
                  Text(
                    widget.roll.precio.toString(),
                    style:  TextStyle(
                      color: kTextColorBlack,
                      fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w500,
                    ),                  
                   ),
                  ],
                ),  
              ],                  
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: widget.press,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: kContrastColorMedium,
                  height: 40,
                  width: 40,
                  child: const 
                    Icon(FontAwesome5.trash_alt,
                    size: 20,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ),
        ],
      ),    
  );
  }
}
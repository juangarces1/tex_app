import 'package:flutter/material.dart';
import 'package:tex_app/Components/card_roll.dart';
import 'package:tex_app/Components/text_derecha.dart';
import 'package:tex_app/Components/text_encabezado.dart';
import 'package:tex_app/Models/compra.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

class CardCompra extends StatefulWidget {
  const CardCompra({super.key, required this.compra});
  final Compra compra;
 

  @override
  State<CardCompra> createState() => _CardCompraState();
}

class _CardCompraState extends State<CardCompra> {
  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.only(left: getProportionateScreenWidth(20), bottom: 10),
    child: 
      Card(
        color:kContrastColor,
          shadowColor: kPrimaryColor,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding
        (
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
          
            Row(children: [
                  const TextEncabezado(texto: 'Compra # '),
                  TextDerecha(texto: widget.compra.facturaNumero.toString()),                 
                ],
              ),

               Row(children: [
                  const TextEncabezado(texto: 'Proveedor: '),
                  TextDerecha(texto: widget.compra.supplier!.name!),                 
                ],
              ),

               Row(children: [
                  const TextEncabezado(texto: 'Fecha Factura: '),
                  TextDerecha(texto: widget.compra.fechafactura.toString()),                 
                ],
              ),

               Row(children: [
                  const TextEncabezado(texto: 'Total: '),
                  TextDerecha(texto: widget.compra.total.toString()),                 
                ],
              ),
              
               Row(children: [
                  const TextEncabezado(texto: 'Rollos: '),
                  TextDerecha(texto: widget.compra.rolls!.length.toString()),                 
                ],
              ),
                  const Center(
                    child: TextEncabezado(texto: 'Lista de Rollos',)
                    ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                         ...List.generate(
                        widget.compra.rolls!.length,
                          (index) {      
                              return CardRoll(roll: widget.compra.rolls![index]);          
                          },
                        ),
                        ],
                    ),
                  ),
            ],                  
          ),
        ),
      ),                 
   );
  }
  
  goMovs() {}

  
}
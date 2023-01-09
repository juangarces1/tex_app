import 'package:flutter/material.dart';
import 'package:tex_app/Components/text_derecha.dart';
import 'package:tex_app/Components/text_encabezado.dart';
import 'package:tex_app/Models/product.dart';
import 'package:tex_app/constans.dart';

class CardProduct extends StatelessWidget {
  final Product product;
  const CardProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
      child: Card(
        color:Colors.white,
        shadowColor: kPrimaryColor,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding:  const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,      
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TextEncabezado(texto: 'Producto: '),
                  TextDerecha(texto: product.descripcion!)
                ],
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TextEncabezado(texto:'Color: '),
                  TextDerecha(texto:product.color!),
                ]
              ),                          
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TextEncabezado(texto:'Stock: '),
                  TextDerecha(texto:product.stock.toString()),
                  const SizedBox(width: 10,),
                    const TextEncabezado(texto:'Stock Bodega: '),
                  TextDerecha(texto:product.stockEnBodega.toString()),
              ],),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    const TextEncabezado(texto:'Stock Almacen: '),
                  TextDerecha(texto:product.stockEnAlmacen.toString()),
                    const SizedBox(width: 10,),
                    const TextEncabezado(texto:'Unidad: '),
                  TextDerecha(texto:product.medida!), 
              ],),
                
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [    
                    const TextEncabezado(texto:'Rollos: '),
                  TextDerecha(texto:product.totalEntradas.toString()),
                    const SizedBox(width: 10,),          
              ],),
          ]),
        ),
      ),
    );
  }
}
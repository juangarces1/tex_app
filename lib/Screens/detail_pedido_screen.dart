
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tex_app/Models/orderview.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

class DetailPedidoScreen extends StatelessWidget {
  const DetailPedidoScreen({super.key, required this.pedido});
  final OrderView pedido;
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
        backgroundColor: kColorAlternativo,
        title:  Text('Pedido ${pedido.id}'),
        
      ),
      body: Container(
        color: kContrastColor,
        child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(10)),
        child: ListView.builder(          
          itemCount: pedido.detalles!.length,
          itemBuilder: (context, index)  
          { 
           
            return 
            Card(
              color: Colors.white,
               shadowColor: Colors.blueGrey,
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding              (
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 88,
                      child: AspectRatio(
                        aspectRatio: 0.88,
                        child: Container(
                          padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                             borderRadius: BorderRadius.only(topLeft: Radius.circular(15) , bottomLeft: Radius.circular(15))
                          ),
                          child: const Image(image: AssetImage('assets/telas.png'),)
                                  
                        ),
                      ),
                    ),                         
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                           '${pedido.detalles![index].producto.toString()} ${pedido.detalles![index].color.toString()}',
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                          ),
                           Text(
                           'Cantidad: ${pedido.detalles![index].cantidad.toString()}',
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                          ),
                    
                          Text(
                           'Precio: \$${NumberFormat("###,000", "es_CO").format(pedido.detalles![index].price)}',
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                          ),

                             Text(
                           'Total: \$${NumberFormat("###,000", "es_CO").format(pedido.detalles![index].total)}',
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                          ),
                                             
                        ],
                      ),
                    )                
                  ],
                ),
              ),
            );
          }        
        ),
        ),
      ),
      ),
    );
  }
}
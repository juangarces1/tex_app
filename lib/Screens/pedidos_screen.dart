import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tex_app/Components/custom_appbar_scan.dart';
import 'package:tex_app/Components/loader_component.dart';
import 'package:tex_app/Helpers/api_helper.dart';
import 'package:tex_app/Models/detalle.dart';
import 'package:tex_app/Models/order.dart';
import 'package:tex_app/Models/orderview.dart';
import 'package:tex_app/Models/response.dart';
import 'package:tex_app/Models/user.dart';
import 'package:tex_app/Screens/detail_pedido_screen.dart';
import 'package:tex_app/Screens/edit_order_screem.dart';
import 'package:tex_app/Screens/home_screen.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

import '../Components/text_derecha.dart';
import '../Components/text_encabezado.dart';


class PedidosScreen extends StatefulWidget {
 
  final User user;

  const PedidosScreen({ Key? key, required this.user }) : super(key: key);

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  List<OrderView> pedidos = [];
  bool showLoader = false;
  
  @override

  void initState() {
    super.initState();
    _getOrdenes();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                child:  CustomAppBarScan(              
                  press: () => goMenu(),
                   titulo:  Text('Listado de Ordenes',
                 style:  GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                       image: const AssetImage('assets/ImgAddPro.png'),
                ),
              ),       
       
        body:  Center(
          child: showLoader ? const LoaderComponent(text: 'Por favor espere...') : _getContent()),
        bottomNavigationBar: BottomAppBar(
          color: kPrimaryColor,
          shape: const CircularNotchedRectangle(),
          child: IconTheme(
           data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
           child: SizedBox(
            height: 50,
             child: Row(
               mainAxisSize: MainAxisSize.max,
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              
            
                 Text(
                   pedidos.isNotEmpty ? 'Pedidos: ${pedidos.length.toString()}  --  Total: ${NumberFormat("###,000", "es_CO").format(pedidos.map((item)=>item.total!).reduce((value, element) => value + element))}' : '', style:  GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),

                 ],          
               ),
           ),
          ),
         ), 
       
      ),
    );
  }

  Widget _getContent() {
    return pedidos.isEmpty 
      ? _noContent()
      : _getList();
  }

  Future<void> _getOrdenes() async {
    setState(() {
      showLoader = true;
    });

   
    
    Response response = await ApiHelper.getOrdersByUser(widget.user.document??'');

    setState(() {
      showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }    

    setState(() {
      pedidos= response.result;
    });
  }
 
  _noContent() {
        return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: const Text(
          'No hay pedidos registrados.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  _getList() {
    return Container(
        color: kContrastColor,
        child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(10)),
        child: ListView.builder(          
          itemCount: pedidos.length,
          itemBuilder: (context, index)  
          {    
             final item = pedidos[index].id.toString();
            return 
            Card(
              color: Colors.white,
               shadowColor: Colors.blueGrey,
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding              (
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Dismissible(            
                  key: Key(item),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) {
                    return showDialog(
                      context: context,
                       builder: (_) =>  AlertDialog(
                        title: const Text('Eliminar'),
                        content: const Text('Desea eliminar la Orden?'),
                        actions: [
                          TextButton(onPressed: () {
                             Navigator.of(context).pop(false);
                          }, child: const Text('No')),
                            TextButton(onPressed: (){
                              if( pedidos[index].estado!="Creada"){
                                  Fluttertoast.showToast(
                                    msg: "La Orden  no de puede borrar\nya fue Procesada",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                  );    
                                 Navigator.of(context).pop(false);
                              }
                              else{
                                   Navigator.of(context).pop(true);
                              }
                              
                            },
                           child: const Text('Sí')),
                        ],    
                       ));
                  },
                  onDismissed: (direction) { 
                        
                      goDelete(pedidos[index]);         
                  },
                  background: Container(              
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 231, 216, 216),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Spacer(),
                        SvgPicture.asset("assets/Trash.svg"),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                         onTap: () => goDetail(pedidos[index]),
                        child: SizedBox(
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
                      ),                         
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Row(children: [
                              const TextEncabezado(texto:'Numero: '),                              
                               TextDerecha(texto: pedidos[index].id.toString()),
                            ],),
                            Row(children: [
                              const TextEncabezado(texto:'Estado: '),                             
                               TextDerecha(texto: pedidos[index].estado.toString()),
                            ],),
                          
                             Row(children: [
                              const TextEncabezado(texto:'Hora: '),                            
                               TextDerecha(texto: pedidos[index].hora.toString()),
                            ],),
                              Row(children: [
                              const TextEncabezado(texto:'Productos: '),                             
                               TextDerecha(texto: pedidos[index].productos.toString()),
                            ],),

                               Row(children: [
                              const TextEncabezado(texto:'Total: '),                             
                               TextDerecha(texto: NumberFormat("###,000", "es_CO").format(pedidos[index].total)),
                            ],),                      
                                                 
                                               
                          ],
                        ),
                      ),
                      pedidos[index].estado =="Creada" ? Padding(
                     padding: const EdgeInsets.only(top: 3, bottom: 3),
                     child: RawMaterialButton(
                        onPressed: () => goEdit(pedidos[index]),
                        elevation: 2.0,
                        fillColor: const Color.fromARGB(255, 228, 198, 67),
                        padding: const EdgeInsets.all(12.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.edit,
                          size: 25.0,
                        ),
                      ),
                   ): Container(),              
                    ],
                  ),
                ),
              ),
            );
          }        
        ),
        ),
      );
  }
  
  goDetail(OrderView pedido) {
     Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => DetailPedidoScreen(pedido: pedido,)
      )
    );
  }
  
   goEdit(OrderView order) async {
    bool flag = false;
    Detalle det = order.detalles!.first;
    if(det.codigoRollo==0){
      flag=true;
    }
    Order editOrder = Order(detalles: order.detalles!, id: order.id, documentUser: widget.user.document);
    Navigator.of(context).pushReplacement(  
      MaterialPageRoute(
        builder: (context) => EditOrderScreen(user: widget.user, orden: editOrder, isOld: flag,)
      )
    );
   
  }
  
  Future<void> goDelete(OrderView pedido) async {
    setState(() {
      showLoader = true;
    });       
    Response response = await ApiHelper.delete('/api/Kilos/DeleteOrder/', pedido.id.toString());
    setState(() {
      showLoader = false;
    });
    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );   
     setState(() {
       pedidos= pedidos;
      }); 
      return;
    }    

    setState(() {
      pedidos.remove(pedido);
    });

  }
  
  goMenu() async {
   
     Navigator.of(context).pushReplacement(  
      MaterialPageRoute(
        builder: (context) => HomeScreen(user: widget.user,)
    )); 
  }
}
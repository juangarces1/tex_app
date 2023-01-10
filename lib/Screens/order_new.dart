

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tex_app/Components/custom_appbar_scan.dart';
import 'package:tex_app/Components/text_derecha.dart';
import 'package:tex_app/Components/text_encabezado.dart';
import 'package:tex_app/Helpers/api_helper.dart';
import 'package:tex_app/Models/detalle.dart';
import 'package:tex_app/Models/order.dart';
import 'package:tex_app/Models/response.dart';
import 'package:tex_app/Models/user.dart';
import 'package:tex_app/Screens/add_product_old.dart';
import 'package:tex_app/Screens/add_product_screen.dart';
import 'package:tex_app/Screens/home_screen.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';


class OrderNewScreen extends StatefulWidget {
  const OrderNewScreen({super.key, required this.orden, required this.user, required this.isOld });
  final Order orden;
  final User user;
  final bool isOld;
  @override
  State<OrderNewScreen> createState() => _OrderNewScreenState();
}

class _OrderNewScreenState extends State<OrderNewScreen> {
  List<Detalle> detalles = [];
  bool showLoader = false;
  String _precio='';
  String _cantidad='';
 
 
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(      
        appBar:  PreferredSize(
              preferredSize: Size.fromHeight(AppBar().preferredSize.height),
              child:  CustomAppBarScan(              
                press: () => goMenu(),
                 titulo:  Text(widget.isOld ? 'Nueva Orden' : 'Nuevo Pedido',
                  style:  GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  image: const AssetImage("assets/AppBar.png"),
              ),
            ),
        body:  Center(
          child:  _getContent(),),
           bottomNavigationBar: BottomAppBar(
          color: kNewPedidoColor,
          shape: const CircularNotchedRectangle(),
          child: IconTheme(
           data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
           child: Container(
            decoration: const BoxDecoration(
              gradient: kGradientHome,
            ),
            height: 70,
             child: Row(
               mainAxisSize: MainAxisSize.max,
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                   padding: const EdgeInsets.only(top: 3, bottom: 3),
                   child: RawMaterialButton(
                      onPressed: _goAdd,
                      elevation: 2.0,
                      fillColor: const Color.fromARGB(255, 184, 13, 118),
                      padding: const EdgeInsets.all(12.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.add,
                        size: 30.0,
                      ),
                    ),
                 ),
                Text(widget.orden.detalles.isNotEmpty ? 'Prod: ${widget.orden.detalles.length.toString()} -  \$${NumberFormat("###,000", "es_CO").format(widget.orden.detalles.map((item)=>item.total!).reduce((value, element) => value + element))}' : '', style:  GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white)),
                 Padding(
                   padding: const EdgeInsets.only(top: 3, bottom: 3),
                   child: RawMaterialButton(
                      onPressed: goSave,
                      elevation: 2.0,
                      fillColor: const Color.fromARGB(255, 3, 52, 158),
                      padding: const EdgeInsets.all(12.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.save,
                        size: 30.0,
                      ),
                    ),
                 ),
                 ],          
               ),
           ),
          ),
         ),  
      ),
    );
  }

  void  goSave()  async {
      if(widget.orden.detalles.isEmpty){
       await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Agregue un Producto.',
        actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }    
     setState(() {
      showLoader = true;
    });    
  
   widget.orden.documentUser=widget.user.document;
   widget.orden.id=0;

   

   Map<String, dynamic> request = widget.orden.toJson();

   Response response = Response(isSuccess: false);
    if(widget.isOld){
       response = await ApiHelper.post(
      'api/Kilos/PostOrderOld/', 
       request,       
     );
    }
    else{
       response = await ApiHelper.post(
      'api/Kilos/PostOrder/', 
       request,       
      );
    }
 

    setState(() {
      showLoader = false;
    });

    if (!response.isSuccess) {
     await  Fluttertoast.showToast(
          msg: 'Error: ${response.message}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );     
      return;
    }    

    setState(() {
      widget.orden.detalles.clear();       
    });

    
      
   

      await  Fluttertoast.showToast(
          msg: 'Orden Guardada Correcatemente',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 14, 131, 29),
          textColor: Colors.white,
          fontSize: 16.0
      );     
      return;
  }

  Widget _getContent() {
    return widget.orden.detalles.isEmpty 
      ? _noContent()
      : _getList();
  }
  
  void _goAdd() {
    if(widget.isOld==false){
      Navigator.of(context).pushReplacement(  
      MaterialPageRoute(
        builder: (context) => AddProductScreen(user: widget.user,      
          orden: widget.orden,
          ruta: "New",
          )
        )
      );
    }
    else{
      Navigator.of(context).pushReplacement(  
      MaterialPageRoute(
        builder: (context) => AddOldProduct(user: widget.user,      
          orden: widget.orden,
          ruta: "Old",
        )
      ));
    }
  }
 
  _noContent() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  const [
          SizedBox(
           
            height: 400,
            width: 400,
            child: Image(image: AssetImage('assets/cart_empty.png'))),
        
          Text(
            'Agregue algun producto al Carrito.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      );
  }

  _getList() {
    return Container(
        color: kContrastColor,
        child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(10)),
        child: ListView.builder(          
          itemCount: widget.orden.detalles.length,
          itemBuilder: (context, index)  
          { 
            final item = widget.orden.detalles[index].codigoRollo.toString();
            return 
            Card(
              color: Colors.white,
               shadowColor: Colors.blueGrey,
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
                        content: const Text('Desea eliminar el Producto?'),
                        actions: [
                          TextButton(onPressed: () {
                             Navigator.of(context).pop(false);
                          }, child: const Text('No')),
                            TextButton(onPressed: (){
                               Navigator.of(context).pop(true);
                            },
                           child: const Text('Sí')),
                        ],    
                       ));
                  },
                  onDismissed: (direction) { 
                        
                      setState(() {
                            widget.orden.detalles.removeAt(index); 
                      });          
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
                            child:  const Image(image: AssetImage('assets/rollostela.png')),
                                    
                          ),
                        ),
                      ),                         
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          TextEncabezado(texto: widget.orden.detalles[index].producto.toString()),
                          TextEncabezado(texto: widget.orden.detalles[index].color.toString()),
                             Row(children: [
                              const TextEncabezado(texto:'Cantidad: '),
                            
                               TextDerecha(texto: widget.orden.detalles[index].cantidad.toString()),
                            ],),
                             Row(children: [
                              const TextEncabezado(texto:'Precio: '),
                           
                               TextDerecha(texto: NumberFormat("###,000", "es_CO").format(widget.orden.detalles[index].price)),
                            ],),
                             Row(children: [
                              const TextEncabezado(texto:'Total: '),
                            
                               TextDerecha(texto: NumberFormat("###,000", "es_CO").format(widget.orden.detalles[index].total)),
                            ],),             
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3, bottom: 3),
                        child: RawMaterialButton(
                          onPressed: () => _showFilter(widget.orden.detalles[index]),
                          elevation: 2.0,
                          fillColor: const Color.fromARGB(255, 228, 198, 67),
                          padding: const EdgeInsets.all(12.0),
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.edit,
                            size: 25.0,
                          ),
                        ),
                      ),                      
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
  
  void goMenu() async {
   
  if(widget.orden.detalles.isEmpty){
    Navigator.of(context).pushReplacement( 
      MaterialPageRoute(
        builder: (context) => HomeScreen(user: widget.user,)
      ));       
    }
        
  }

 
  Future  _showFilter(Detalle detalle) => showDialog(
     context: context,
     builder: (context) => StatefulBuilder(
       builder: (context, setState) => AlertDialog(
         shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title:  Text('${detalle.producto} ${detalle.color}'),         
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[           
             const Divider(color: Colors.black, height: 11,),            
            Container(
                  padding: const EdgeInsets.only(left: 50.0, right: 50),      
                  child:  TextField(
                    onChanged: (value) {
                      _cantidad = value;
                    },
                    keyboardType: TextInputType.number,
                    decoration:  const InputDecoration(
                      
                      labelText: 'Cantidad',
                                        
                      suffixIcon:  Icon(Icons.numbers),
                  ),
                ),
              ),
             Container(
                  padding: const EdgeInsets.only(left: 50.0, right: 50),      
                  child:  TextField(
                    onChanged: (value) {
                      _precio = value;
                    },
                    keyboardType: TextInputType.number,
                    decoration:  const InputDecoration(
                      
                      labelText: 'Precio',
                                        
                      suffixIcon:  Icon(Icons.money),
                  ),
                ),
              ),
             const SizedBox(height: 10,),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text(
                'Cancelar',
               )
            ),
            TextButton(
              onPressed: () => _editar(detalle), 
              child: const Text(
                'Cambiar',
               )
            ),
          ],
        ),
       ),
   );

    _editar(Detalle detalle) {
        setState(() {
         for (var item in widget.orden.detalles){
          if(item.codigoRollo==detalle.codigoRollo){
            if(_precio != ''){
                 item.price = double.parse(_precio);
            }
             if(_cantidad != ''){
                 item.cantidad = double.parse(_cantidad);
            }
             item.total= item.price! * item.cantidad!;
          }
        }
        });
         Navigator.of(context).pop();
       
     }
 
}
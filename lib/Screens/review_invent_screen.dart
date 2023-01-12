import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tex_app/Components/card_product.dart';
import 'package:tex_app/Components/loader_component.dart';
import 'package:tex_app/Components/text_derecha.dart';
import 'package:tex_app/Components/text_encabezado.dart';
import 'package:tex_app/Helpers/api_helper.dart';
import 'package:tex_app/Models/invent_detail.dart';
import 'package:tex_app/Models/invent_review.dart';
import 'package:tex_app/Models/invert.dart';
import 'package:tex_app/Models/product.dart';
import 'package:tex_app/Models/response.dart';
import 'package:tex_app/Models/roll.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

import '../Models/user.dart';

class ReviewInventScreen extends StatefulWidget {
  final User user;
  const ReviewInventScreen({super.key, required this.user});

  @override
  State<ReviewInventScreen> createState() => _ReviewInventScreenState();
}

class _ReviewInventScreenState extends State<ReviewInventScreen> {
  InventReview inventReview = InventReview(products: []);
  String? scanResult;
  bool showLoader=false;
  List<Roll> rollos = [];
  bool showInvent = false;

  @override
  Widget build(BuildContext context) {
     return WillPopScope(
       onWillPop: () async {
          bool willLeave = false;
          // show the confirm dialog
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Esta seguro que quiere salir?'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            willLeave = true;
                            Navigator.of(context).pop();
                          },
                          child: const Text('Sí')),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('No'))
                    ],
                  ));
          return willLeave;
        },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
         backgroundColor: kContrastColorMedium,
        appBar: AppBar(
           backgroundColor:  const Color.fromARGB(255, 8, 44, 107),
          title:   Text(
            'Revisar Inventario',
              style: GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
           actions: <Widget>[         
            IconButton(
              onPressed: scanBarCode, 
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.white,)
            )          
        ],
         
        ),
        body:  Stack(
          children: [
             showInvent == false ? newList() : showInventario(),
            showLoader ? const LoaderComponent(text: 'Cargando') : Container(),
          ],
        ),

          bottomNavigationBar: BottomAppBar(
          color:  const Color.fromARGB(255, 8, 44, 107),
          shape: const CircularNotchedRectangle(),
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
             mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(             
                icon: showInvent==false ? const Icon(Icons.switch_right, color: Colors.white, size: 35,): const Icon(Icons.switch_left, color: Colors.white, size: 35,),
                onPressed: () => setState(() {
                  showInvent=!showInvent;
                }),
              ),
              const SizedBox(width: 20,),
              Text(
               rollos.isNotEmpty ? 'Productos: ${inventReview.products.length.toString()}  -  Rollos: ${rollos.length}' : '', style:  GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),

               ],          
             ),
          ),
         ), 
        
         floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
       
        floatingActionButton: FloatingActionButton(
          
          backgroundColor: kColorAlternativo,
          onPressed: () => goSave(),
          
          child: const Icon(Icons.save),
          
        ), 
      ),
    );
  }

  Widget newList() {
   return  Container(
        color: kContrastColorMedium,
        child: Stack(
          children: [ Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(10)),
          child: ListView.builder(            
            itemCount: rollos.length,
            itemBuilder: (context, index)  
            {             
              return 
              Card(
                color: kContrateFondoOscuro,
                 shadowColor: Colors.blueGrey,
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding
                (
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
                            child:  const Image(
                                        image: AssetImage('assets/iconNuevo.png'),
                                    ),
                          ),
                        ),
                      ),                         
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [                        
                            TextEncabezado(texto:'${rollos[index].product!.descripcion.toString()} ${rollos[index].product!.color!.toString()}'),
                            TextDerecha(texto: 'CodBarras: ${rollos[index].codigoBarras}') ,                  
                             TextEncabezado(texto: 'Cantidad ${rollos[index].cantidad.toString()}'),
                            TextDerecha(texto: 'Stock ${rollos[index].inventario}'),     
                          ],
                        ),
                      ),
                       InkWell(
                        onTap: () => {
                           showDialog(
                            context: context,
                            builder: (_) =>  AlertDialog(
                              title: const Text('Eliminar'),
                              content: const Text('Desea eliminar el producto?'),
                              actions: [
                                TextButton(onPressed: () {
                                  Navigator.of(context).pop(false);
                                }, child: const Text('No')),
                                  TextButton(onPressed: (){
                                   Roll  aux =rollos.firstWhere((element) => element.id == rollos[index].id);
                                    goRemove(aux);
                                    setState(() {
                                     
                                      rollos.remove(aux);
                                   
                                    });
                                   
                                    Navigator.of(context).pop(true);

                                  },
                                child: const Text('Sí')),
                              ],    
                            )),
                        },     
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
                      ),
                      const SizedBox(width: 5,),                
                    ],
                  ),
                ),
              );
            }        
          ),
        ),
        showLoader ? const LoaderComponent(text: 'Cargando..,',) :Container()
          ]
        ),
      );
  }

  Future scanBarCode() async {
    try {
        scanResult = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException{
      scanResult='Fallo al obtener la versin de plataforma.';
    }
    if(!mounted) return;

    setState(() {
      scanResult=scanResult;
    });
    _getRoll();
  }

  Future _getRoll() async {    
    var cides=scanResult??'';
      if(cides.isEmpty){
      return;
    }
      if(cides=='-1'){
      return;
  }   
  
  //quitamos los extremos del codigo 
  // y lo convertimos a int

  String code1 = cides.substring(1,9);
  int code = int.parse(code1);

  //Miramos que no este en la lista
  //antes de mandarlo a buscar

   for (var element in rollos) {
    if(element.id == code){
       await Fluttertoast.showToast(
        msg: "El Rollo ya se agrego",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0
      );    
      return;
    }
  }

  setState(() {
      showLoader=true;
  });
 
  Response response = await ApiHelper.getRoll(code);

  setState(() {
      showLoader=false;
  });

    if (!response.isSuccess) {
    await Fluttertoast.showToast(
        msg: "El Rollo no EXISTE",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );     
    return;
  }    
  Roll roll = response.result; 
  
  setState(() {
    rollos.insert(0, roll);
  });  
  goProductAdd(roll);
   
}

  Future goSave() async {
     if(inventReview.products.isEmpty){
      await Fluttertoast.showToast(
        msg: "No hay productos para guardar",
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
      showLoader=true;
    });

   DateFormat formatter = DateFormat('yyyy-MM-dd');
   String date1 = formatter.format(DateTime.now());

  Invent invet = Invent(
    id: 0,
    total: 0,
    fecha: date1,
    rollos: 0,
    metros: 0,
    kilos: 0,
    items: [],
   
  );
    
   for (var element in inventReview.products) {  
      InventDetail item= InventDetail(
        id: 0,
        categoria: element.category!.name,
        producto: element.descripcion,
        cantidad: element.stock,
        medida: element.rolls!.first.medida,
        color: element.color,
        precio: element.rolls!.first.precio,
      );
      invet.items!.add(item);
    
   }
   invet.rollos= invet.items!.length;

    Map<String, dynamic> request = invet.toJson();

   Response response = await ApiHelper.post(
    'api/Kilos/PostInventario/',
     request
   );

    setState(() {
        showLoader=false;
      });
  
      if (!response.isSuccess) {
        showErrorFromDialog(response.message);
        return; 
      } 
      await Fluttertoast.showToast(
          msg: "Inventario guardado",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );    
        setState(() {
          inventReview.products.clear();
          rollos.clear();
        });
          
  }
  
  showInventario() {
    return Container(color: kContrastColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(child: TextEncabezado(texto: 'Resumen Inventario')),
          ),
        ...List.generate(
            inventReview.products.length,
              (index) { return CardProduct(product: inventReview.products[index]); 
              }),
         const SizedBox(height: 10,),     
        ]),
      ),
    );
  }
  
  goProductAdd(Roll roll) {
   
    Product pro = inventReview.products.firstWhere((element) => element.id == roll.product?.id, orElse: () => Product());

    if(pro.id==null){
      Product pro = roll.product!;
      pro.totalEntradas=1;
      pro.stock=roll.inventario;
      if(roll.status=='EnBodega'){
        pro.stockEnBodega=roll.inventario;
      }
      else{
        pro.stockEnAlmacen=roll.inventario;
      }
      inventReview.products.add(pro);
      
    }
    else{
      for (var element in inventReview.products) {
        if(element.id==roll.product?.id){         
          element.totalEntradas = element.totalEntradas!+1;
          element.stock=  element.stock! + roll.inventario!;
          if(roll.status=='EnBodega'){
            element.stockEnBodega= element.stockEnBodega! + roll.inventario!;
          }
          else{
              element.stockEnAlmacen= element.stockEnAlmacen! + roll.inventario!;
          }
        }
      }
    }
    
    setState(() {
      inventReview;
   }); 


  }
  
  void goRemove(Roll roll) { 
      bool elimited=false;
      for (var element in inventReview.products) {
        if(element.id==roll.product?.id){         
          element.totalEntradas= element.totalEntradas!-1;
          element.stock =  element.stock! - roll.inventario!;
          if(roll.status=='EnBodega'){
            element.stockEnBodega= element.stockEnBodega! - roll.inventario!;
          }
          else{
              element.stockEnAlmacen= element.stockEnAlmacen! - roll.inventario!;
          }
          if(element.stock==0){
            elimited=true;
          }
          
        }

      }   
      if(elimited){
        var pro = inventReview.products.firstWhere((element) => element.id==roll.product!.id);
        inventReview.products.remove(pro);
      }

    
    setState(() {
      inventReview;
   }); 

  }

 void showErrorFromDialog(String msg) async {
    await showAlertDialog(
        context: context,
        title: 'Error', 
        message: msg,
        actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );       
    }


}


 
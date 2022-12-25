

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tex_app/Components/loader_component.dart';
import 'package:tex_app/Helpers/api_helper.dart';
import 'package:tex_app/Models/changestateroll.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

import '../Models/response.dart';
import '../Models/roll.dart';

class OrdenEntradaScreen extends StatefulWidget {
  const OrdenEntradaScreen({super.key, required this.status});
  final String status;

  @override
  State<OrdenEntradaScreen> createState() => _OrdenEntradaScreenState();
}

class _OrdenEntradaScreenState extends State<OrdenEntradaScreen> {
  List<Roll> rollos = [];
    String? scanResult;
    bool showLoader=false;
 

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
         backgroundColor: kColorFondoOscuro,
        appBar: AppBar(
           backgroundColor: Colors.orangeAccent,
          title:  const Text(
            'Orden de Entrada Alamcen',
              style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
          ),
           actions: <Widget>[
         
            IconButton(
              onPressed: scanBarCode, 
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.black,)
            )
          
        ],
         
        ),
        body:  Stack(
          children: [
          newList(),
            showLoader ? const LoaderComponent(text: 'Cargando') : Container(),
          ],
        ),

          bottomNavigationBar: BottomAppBar(
          color:  Colors.orangeAccent,
          shape: const CircularNotchedRectangle(),
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
             mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(             
                icon: const Icon(Icons.menu, color: Colors.black,),
                onPressed: () {},
              ),
              Text(
               rollos.isNotEmpty ? 'Prod: ${rollos.length.toString()}  -  Total: ${NumberFormat("###,000", "es_CO").format(rollos.map((item)=>item.cantidad!).reduce((value, element) => value + element))}' : '', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 19),),

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
        color: kColorFondoOscuro,
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
                            Text(
                              ' ${rollos[index].product!.descripcion.toString()} ${rollos[index].product!.color!.toString()}',
                              style:const TextStyle(
                                    fontWeight: FontWeight.w700, color: kPrimaryColor),
                              maxLines: 2,
                            ),
                           
                            Text('CodBarras: ${rollos[index].codigoBarras}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, color: kPrimaryColor),
                                                          
                              ),
                            
                               Text(
                              'Cantidad ${rollos[index].cantidad.toString()} ${rollos[index].product!.color!.toString()}',
                              style: const TextStyle(
                                    fontWeight: FontWeight.w700, color: kPrimaryColor),
                            
                            ),
                          
                            Text('Stock ${rollos[index].inventario}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, color: kPrimaryColor),
                                                          
                              ),
                                                       
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

    setState(() {
        showLoader=true;
    });
  
    String code1 = cides.substring(1,9);
    int code = int.parse(code1);
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

    for (var element in rollos) {
      if(element.id == roll.id){
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

    if(roll.status=='EnBodega')   {
        setState(() {
      rollos.insert(0, roll);
     });
    }
    else{
      await Fluttertoast.showToast(
          msg: "El Rollo no esta en Bodega",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );     
     
    }
    
   
  }
  
   void  goSave()  async {
      if(rollos.isEmpty){
       await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Agregue un rollo.',
        actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }
    
     setState(() {
      showLoader = true;
    });

    ChageStateRoll order = ChageStateRoll(rollos: rollos, estado: widget.status);
  

   Map<String, dynamic> request = order.toJson();

    Response response = await ApiHelper.post(
      'api/kilos/ChangeRoll/', 
      request, 
      
    );

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
      rollos.clear();
       
      });
      
    showAlertDialog(
        context: context,
        title: 'Ok', 
        message: 'Orden Guardada Correcatemente',
        actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      ); 

  }

  
}
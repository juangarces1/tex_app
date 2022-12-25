

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:intl/intl.dart';
import 'package:tex_app/Components/loader_component.dart';
import 'package:tex_app/Helpers/api_helper.dart';
import 'package:tex_app/Models/detalle.dart';
import 'package:tex_app/Models/order.dart';
import 'package:tex_app/Models/roll.dart';
import 'package:tex_app/Screens/scanner_screen.dart';
import 'package:tex_app/constans.dart';

import '../Models/response.dart';
import '../sizeconfig.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({ Key? key,   this.codigo, required this.orden }) : super(key: key);
  final Order orden;
  final String? codigo;



  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? scanResult;
  bool showLoader=false;
  TextEditingController precioController = TextEditingController();
  TextEditingController codigoController = TextEditingController();
  String codigoError = '';
  bool codigoShowError = false; 
  TextEditingController scanController = TextEditingController();
  String precioError = '';
  bool precioShowError = false; 
  TextEditingController cantidadController = TextEditingController();
  String cantidadError = '';
  bool cantidadShowError = false; 
  Roll rollAux = Roll(); 

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
           backgroundColor: kPrimaryColor,
          title:  const Text(
            'Nuevo Pedido',
              style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
          ),
           actions: <Widget>[
           IconButton(
              onPressed: scanBarCode, 
              icon: const Icon(Icons.camera_alt_outlined)
            )
          
        ],
         
        ),
        body:  Stack(
          children: [
            Container(
              color: kColorFondoOscuro,
              child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [                    
                   
                  
                    const Divider(
                      height: 40,
                      thickness: 2,
                      color: kContrastColor,
                    ), 

                    product(),

                     const Divider(
                      height: 40,
                      thickness: 2,
                      color: kContrastColor,
                    ), 
                      
                      _showListNew(),
                      const Divider(
                      height: 40,
                      thickness: 2,
                      color: kContrastColor,
                    ), 
                  ],
                  ),
                 ),
              ),
            ),
            showLoader ? const LoaderComponent(text: 'Cargando') : Container(),
          ],
        ),

          bottomNavigationBar: BottomAppBar(
          color: kPrimaryColor,
          shape: const CircularNotchedRectangle(),
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
             mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(             
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
              Text(
               widget.orden.detalles.isNotEmpty ? 'Productos: ${widget.orden.detalles.length.toString()}  --  Total: ${NumberFormat("###,000", "es_CO").format(widget.orden.detalles.map((item)=>item.total!).reduce((value, element) => value + element))}' : '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

               ],          
             ),
          ),
         ), 
        
         floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
       
        floatingActionButton: FloatingActionButton(
          
          backgroundColor: kColorMyLogo,
          onPressed: () => goSave(),
          
          child: const Icon(Icons.save),
          
        ), 
      ),
    );
  }

   Widget _showInfo() {     
     return Container(  
           decoration:  const BoxDecoration(
              color: kContrastColorMedium,             
            ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                 
                  children: [
                    Column(
                       crossAxisAlignment: CrossAxisAlignment.start,    
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [ 
                         

                        rollAux.cantidad != null ?  Text(
                          'Producto: ${rollAux.product!.descripcion.toString()}',
                           style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                           
                          ) 
                        : Container(),
                        

                      ],
                    ),
                    Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                          rollAux.cantidad != null ?  Text(
                          'Color: ${rollAux.product!.color!.toString()}',
                           style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                          ) : Container(),
                           rollAux.cantidad != null ?  Text(
                          'Stock: ${rollAux.product!.stock.toString()}',
                           style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                          ) : Container(),
                      ],
                    )
                  ]),
              ),
          );
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
      rollAux= response.result;
      codigoController.text=rollAux.id.toString();
    });
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

  void goScan() {
 
     Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) =>  ScannerScreen(scanResult: '', orden: widget.orden,)
      )
    );
  }

  Widget _showListNew() {
       return  Container(
        color: kColorFondoOscuro,
         child: Column( 
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                    child: Center(
                      child: Text(
                        "Lista de Productos",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(23),
                          color: kContrateFondoOscuro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                 SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: 
                    [
                      ...List.generate(
                      widget.orden.detalles.length,
                        (index) {      
                            return detailCard(widget.orden.detalles[index]);          
                        },
                      ),
                      SizedBox(width: getProportionateScreenWidth(20)),
                    ],
                  ),
                  )
                ],
              ),
       );
  }

  Widget product() {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(10),right: getProportionateScreenWidth(10)),
      child: Card(
        color: Colors.white
        ,
        shadowColor: Colors.blueGrey,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(             
              children: [

                _showCodigo(),
     
                  const SizedBox(height: 10,),
                 _showInfo(),
                _showCantidad(),
                _showPrecio(),
                const SizedBox(height: 10,),
                SizedBox(
                 child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       
                        shape: const CircleBorder(), backgroundColor: kPrimaryColor, 
                        padding: const EdgeInsets.all(8),
                        
                     ),
                                onPressed: _addProduct,
                            child: const Icon(
                            
                              Icons.add,
                              size: 30,
                            ),
                      ),
              ),
              ],
          ),
        ),
      ),
    );
  }

  Widget _showPrecio() {
    return Container(
      padding: const EdgeInsets.only(left: 50.0, right: 50),      
      child: TextField(
        controller: precioController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Ingresa el precio...',
          labelText: 'Precio',
          errorText: precioShowError ? precioError : null,
          suffixIcon: const Icon(Icons.money),
         
        ),
    
      ),
    );
  }

  Widget _showCodigo() {
    return Container(
      padding: const EdgeInsets.only(left: 50.0, right: 50),      
      child: TextField(
        controller: codigoController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Ingresa el codigo...',
          labelText: 'Codigo',
          errorText: codigoShowError ? codigoError : null,
          suffixIcon: IconButton(onPressed:  goGetProduct, icon: const Icon(Icons.search_outlined),)
         
        ),
    
      ),
    );
  }

  Widget _showCantidad() {
    return Container(
      padding: const EdgeInsets.only(left: 50.0, right: 50),      
      child: TextField(
        controller: cantidadController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Ingresa la Cantidad...',
          labelText: 'Cantidad',
          errorText: cantidadShowError ? cantidadError : null,
          suffixIcon: const Icon(Icons.numbers),
         
        ),
    
      ),
    );
  }

  Widget detailCard(Detalle detail) {
  return Padding(
    padding: EdgeInsets.only(left: getProportionateScreenWidth(20), bottom: 10),
    child: SizedBox(
      width: getProportionateScreenWidth(160),
      child:  Column(
           crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.25,
                      child: Container(
                         padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                        decoration: BoxDecoration(
                          color: kSecondaryColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Image(image: AssetImage('assets/telas.png')) 
                      ),
                    ),
                     

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
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
                                   Detalle  aux =widget.orden.detalles.firstWhere((element) => element.codigoRollo == detail.codigoRollo);
                                    setState(() {
                                     
                                      widget.orden.detalles.remove(aux);
                                   
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
                      )
                    ),
                  ],
                ),         
               const SizedBox(height: 10),
                Text(
                  detail.producto.toString(),
                  style:  TextStyle(
                    color: kContrateFondoOscuro,
                     fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                ),     
                  Text(
                  detail.color.toString(),
                  style:  TextStyle(
                    color: kContrateFondoOscuro,
                     fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                ),                
                Text(
                  'Cantidad: ${NumberFormat("##.0#", "es_CO").format(detail.cantidad)}',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.w300,
                    color: kContrateFondoOscuro,
                  ),
                ),
                 Text(
                  'Precio: ${NumberFormat("###,000", "es_CO").format(detail.price)}',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.w300,
                    color: kContrateFondoOscuro,
                  ),
                ),
                 Text(
                  'Total: ${NumberFormat("###,000", "es_CO").format(detail.total)}',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.w300,
                    color: kContrateFondoOscuro,
                  ),
                )
            ],
       ),      
      )
    );

  }

  bool _validateFields() {
    bool isValid = true;

    if (cantidadController.text.isEmpty) {
      isValid = false;
      cantidadShowError = true;
      cantidadError = 'Debes ingresar la Cantidad.';
    } else {
      cantidadShowError = false;
    }   
    
    if(double.tryParse(cantidadController.text) == null){
        isValid = false;
        cantidadShowError = true;
        cantidadError = 'Debes ingresar un numero correcto.';
    } else {
      cantidadShowError = false;
    }

   


   if (precioController.text.isEmpty) {
     isValid = false;
      precioShowError = true;
      precioError = 'Debes ingresar el Precio.';
    } else {
      precioShowError = false;
    }   
    
    if(double.tryParse(precioController.text) == null){
        isValid = false;
        precioShowError = true;
        precioError = 'Debes ingresar un numero correcto.';
    } else {
      precioShowError = false;
    }
    
   

    setState(() {});
    return isValid;
  }

  bool _validateCodigo() {
    bool isValid = true;

    if (codigoController.text.isEmpty) {
      isValid = false;
      codigoShowError = true;
      codigoError = 'Debes el Codigo.';
    } else {
      codigoShowError = false;
    }   
    
    if(int.tryParse(codigoController.text) == null){
        isValid = false;
        codigoShowError = true;
        codigoError = 'Debes ingresar un numero correcto.';
    } else {
      codigoShowError = false;
    }
 
    setState(() {});
    return isValid;
  }

  void  _addProduct() async  {
   FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
   
    var  pId = rollAux.product?.id;
    if(pId==null){
       await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Selecciona un Producto.',
        actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    if (!_validateFields()) {
      return;

    }
      Detalle detailAux =  Detalle();
 
    detailAux.producto=rollAux.product!.descripcion;
    detailAux.cantidad=double.parse(cantidadController.text);
    detailAux.price=double.parse(precioController.text);
    detailAux.codigoRollo=rollAux.id??0;
    detailAux.color=rollAux.product!.color!;
    double var2 =detailAux.cantidad ?? 0;
     double var3 =detailAux.price ?? 0;
     detailAux.total=var3*var2;
     
     setState(() {
       widget.orden.detalles.insert(0, detailAux);
     });

  }
 
  void goGetProduct() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (!_validateCodigo()) {
      return;
    }
    int code22 = int.parse(codigoController.text);
     _getRollCodigo(code22);
  }
 
  Future _getRollCodigo(int codigo) async {
    setState(() {
        showLoader=true;
    });
    Response response = await ApiHelper.getRoll(codigo);
    setState(() {
        showLoader=false;
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
      rollAux= response.result;
    });
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

    
  

   Map<String, dynamic> request = widget.orden.toJson();

    Response response = await ApiHelper.post(
      'api/Orders/PostOrder/', 
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
       widget.orden.detalles.clear();
       
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
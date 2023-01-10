

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tex_app/Components/custom_appbar_scan.dart';
import 'package:tex_app/Components/default_button.dart';
import 'package:tex_app/Components/loader_component.dart';
import 'package:tex_app/Components/text_derecha.dart';
import 'package:tex_app/Components/text_encabezado.dart';
import 'package:tex_app/Helpers/api_helper.dart';
import 'package:tex_app/Models/detalle.dart';
import 'package:tex_app/Models/order.dart';
import 'package:tex_app/Models/response.dart';
import 'package:tex_app/Models/roll.dart';
import 'package:tex_app/Models/user.dart';
import 'package:tex_app/Screens/edit_order_screem.dart';
import 'package:tex_app/Screens/order_new.dart';
import 'package:tex_app/constans.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, required this.orden, required this.user, required this.ruta, });
  final String ruta;
  final Order orden;
  final User user;
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
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
    return SafeArea(
      
      child: Scaffold(
        backgroundColor: kColorFondoOscuro,
        appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppBar().preferredSize.height),
              child:  CustomAppBarScan(              
                press: () => goBack(),
                 titulo:  Text('Agregue un Producto', style: GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                 image: const AssetImage('assets/ImgAddPro.png'),
              ),
            ),
        body:  Stack(
          children: [
            Container(
              color: kContrastColorMedium,
              child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children:  [ 
                     InkWell(
                       onTap: scanBarCode,
                       child: Padding(
                         padding: const EdgeInsets.only(left: 45, right: 45, top: 10, bottom: 10),
                         child: Container(
                          
                          height: 50,
                          decoration:  const BoxDecoration(
                            borderRadius:  BorderRadius.all(Radius.circular(10)),
                            gradient: kGradientTexApp,
                           
                          ),
                           child: Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:  [
                                  const Icon(Icons.camera_alt_outlined, size: 30, color: Colors.white,),
                                  const SizedBox(width: 10,),
                                  Text('Escanear Codigo', style:  GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
                              ]),
                                            
                            // child: ElevatedButton.icon(
                            //   style: ElevatedButton.styleFrom(
                            //     foregroundColor: kContrastColor, gradient: kGradientTexApp,
                            //   ),
                            //   icon: const Icon(Icons.camera_alt_outlined),
                            //   label: const Text('Escanear Codigo', style: TextStyle(fontSize: 30),),
                            //   onPressed: scanBarCode, 
                            // ),
                           ),
                         ),
                       ),
                     ),                
                    Container(                    
                      color: kContrastColorMedium,
                      child: _showCodigo()),     
                   Container(height: 15, color: kContrastColor,),
                  rollAux.cantidad != null ?  _showInfo() : Container(),
                   _showCantidad(),
                  _showPrecio(),
                  const SizedBox(height: 15,),
             
                      DefaultButton(text: 'Agregar', press: _addProduct),  
                      const SizedBox(height: 50,),
                
                     
                  ],
                  ),
                 ),
              ),
            ),
            showLoader ? const LoaderComponent(text: 'Cargando') : Container(),
          ],
        ),
        )
    );
  }

  void  _addProduct() async  {
   FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
   
    var  pId = rollAux.product?.id;
    if(pId==null){
       await Fluttertoast.showToast(
          msg: "Seleccione un Producto",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
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
    detailAux.codigoProducto=rollAux.product!.id??0;
    detailAux.color=rollAux.product!.color!;
    double var2 =detailAux.cantidad ?? 0;

    
     double var3 =detailAux.price ?? 0;
     detailAux.total=var3*var2;

     if(var2 > var3){
      await Fluttertoast.showToast(
          msg: "Por favor revise los valores\nCantidad y Precio.",
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
       widget.orden.detalles.insert(0, detailAux);
     });

      if(widget.ruta=="Edit")
      {
          Navigator.of(context).pushReplacement(            
            MaterialPageRoute(
              builder: (context) => EditOrderScreen(orden: widget.orden, user: widget.user, isOld: true,)
            )
          );
      }
      else
      {
          Navigator.of(context).pushReplacement(  
            MaterialPageRoute(
              builder: (context) => OrderNewScreen(orden: widget.orden, user: widget.user, isOld: false,)
            )
          );
      }

       

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
      color: kContrastColor,
      padding: const EdgeInsets.only(left: 50.0, right: 50, top:20),      
      child: TextField(
        controller: codigoController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          
          filled: true,
          hoverColor: const Color.fromARGB(255, 19, 47, 70),
          border:   const OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 5)),
          hintText: 'Ingresa el codigo...',
          labelText: 'Codigo',
          errorText: codigoShowError ? codigoError : null,
          suffixIcon: IconButton(iconSize: 40, onPressed:  goGetProduct, icon: const Icon(Icons.search_sharp, color: Color.fromARGB(255, 35, 145, 39),),)
         
        ),
    
      ),
    );
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
      await Fluttertoast.showToast(
          msg: "El rollo no existe",
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
      rollAux= response.result;
    });
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
      rollAux= response.result;
      codigoController.text=rollAux.id.toString();
    });
  }
  
  Widget _showInfo() {     
     return Container( 
      decoration:  const
      BoxDecoration(             
        color: kContrastColorMedium,             
      ),
        child: Padding(
          padding:  const EdgeInsets.only(left: 50.0, right: 50, top:10, bottom: 10),  
          child: Card(
                color:kContrastColor,
                shadowColor: kPrimaryColor,
                elevation: 8,
            child: Padding(
              padding:  const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,                     
                children: [
                  Row(
                    children: [
                      const TextEncabezado(texto: 'Producto: '),
                      TextDerecha(texto: rollAux.product!.descripcion!),
                    ],
                  ),
                    Row(
                    children: [
                      const TextEncabezado(texto: 'Color: '),
                      TextDerecha(texto: rollAux.product!.color!),
                    ],
                  ),
                    Row(
                    children: [
                      const TextEncabezado(texto: 'Stock: '),
                      TextDerecha(texto: rollAux.product!.stock!.toString()),
                    ],
                  ),
                ]),
            ),
          ),
        ),
    );
  }
  
  goBack() async {
    if(widget.ruta=="Edit"){
      Navigator.of(context).pushReplacement(  
      MaterialPageRoute(
        builder: (context) => EditOrderScreen(user: widget.user, orden: widget.orden,isOld: false,)
    ));  
    }
    else{
       Navigator.of(context).pushReplacement(  
       MaterialPageRoute(
        builder: (context) => OrderNewScreen(user: widget.user, orden: widget.orden, isOld: false,)
    ));  
    }
    
  }


}
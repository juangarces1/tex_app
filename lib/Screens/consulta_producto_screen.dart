import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tex_app/Components/card_movs.dart';
import 'package:tex_app/Components/card_roll.dart';
import 'package:tex_app/Components/combo_colores.dart';
import 'package:tex_app/Components/combo_products.dart';
import 'package:tex_app/Components/default_button.dart';
import 'package:tex_app/Components/loader_component.dart';
import 'package:tex_app/Components/text_derecha.dart';
import 'package:tex_app/Components/text_encabezado.dart';
import 'package:tex_app/Helpers/api_helper.dart';
import 'package:tex_app/Models/descuento.dart';
import 'package:tex_app/Models/product.dart';
import 'package:tex_app/Models/response.dart';
import 'package:tex_app/Models/user.dart';
import 'package:tex_app/Screens/home_screen.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

class ConsultaProductoScreen extends StatefulWidget {
  const ConsultaProductoScreen({super.key, required this.user});
  final User user;
  @override
  State<ConsultaProductoScreen> createState() => _ConsultaProductoScreenState();
}

class _ConsultaProductoScreenState extends State<ConsultaProductoScreen> {
  String? scanResult;
  TextEditingController codigoController = TextEditingController();
  String codigoError = '';
  bool codigoShowError = false; 

  TextEditingController codProController = TextEditingController();
  String codProError = '';
  bool codProShowError = false; 

  bool showLoader=false;
  Product product=Product();
  List<Descuento> movs=[];

  bool swicht =true;

  List<Product> products = [];
  List<Product> colores = [];

  Product auxProduct = Product();
  Product auxColor = Product();
  
 @override
  void initState() {
    super.initState();   
    _getProducts(); 
  }
 
 @override 
 Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: kColorAlternativo,
        appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppBar().preferredSize.height),
              child:  Container(
                decoration:  const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/ImgAddPro.png'),
                          fit: BoxFit.cover,
                        ),),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20), vertical: getProportionateScreenHeight(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(40),
                        width: getProportionateScreenWidth(40),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: kPrimaryColor, shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                            backgroundColor:  Colors.white,
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: goBack,             
                                                    
                          child: SvgPicture.asset(
                            "assets/Back ICon.svg",
                            height: 15,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:   const [
                            Text('Consulta Producto', style: TextStyle(color: Colors.white, fontSize: 20),),
                            SizedBox(width: 5),                         
                          ],
                        ),
                      ),
                       !swicht ? IconButton(onPressed: () => refrescar(), icon: const Icon(Icons.filter_alt, size: 20, color: Colors.white,),)  : const SizedBox(width: 50,)
                    ],
                  ),
                ),
              ),
            ),
        body:  swicht ? formProduct() : _showProductResult()
        )
    );
  }

 Widget formProduct(){
    return Stack(
          children: [
            Container(
              color: kContrastColor,
              child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children:  [ 
                     Container(
                      color: kColorAlternativo,
                       child: Padding(
                         padding:  const EdgeInsets.only(top: 20.0, bottom: 20),
                         child: Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: kContrastColor, backgroundColor: kPrimaryColor,
                            ),
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: const Text('Escanear Codigo Rollo', style: TextStyle(fontSize: 20),),
                            onPressed: scanBarCode, 
                          ),
                         ),
                       ),
                     ),                
                    Container(                    
                      color: kColorAlternativo,
                      child: _showCodigo()),  
                       Container(                    
                      color: kColorAlternativo,
                      child: _showCodigoProducto()),     
                     Container(height: 15, color: kContrastColor,),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: Container(
                        color: kContrastColor,
                        child: Card(
                          color:Colors.white,
                          shadowColor: kPrimaryColor,
                          elevation: 8,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Column(children: [
                             ComboProducts(onChanged: _goChange, backgroundColor: Colors.white, products: products, titulo: 'Productos'),          
                             ComboColores(onChanged: _goChangeColor, backgroundColor: Colors.white, products: colores, titulo: 'Color'),
                             DefaultButton(text: 'Buscar', press:  goBuscarSelect,) ,
                             const SizedBox(height: 20,)
                          ]),
                        ),
                       ),
                     ),  
                   ],
                  ),
                 ),
              ),
            ),
            showLoader ? const LoaderComponent(text: 'Cargando') : Container(),
          ],
        );
  }

 Future<void> _getProducts() async {
   setState(() {
      
      showLoader = true;
    });   

    Response response = await ApiHelper.getProducts();

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
          ]);
      return;
    }
   
      setState(() {
        products = response.result;       
      });
  } 

 Future<void> _getColors() async {
    if(auxProduct.descripcion==null){
      return;
    }
    
    setState(() {
      colores.clear();
      showLoader = true;     
    }); 

    Map<String, dynamic> request = 
    {
      'supId': 1,
      'descripcion' : auxProduct.descripcion, 
    };

    Response response = await ApiHelper.getProductColors(request);

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
          ]);
      return;
    }
   
    setState(() {
      colores = response.result;       
    });
  } 

 Widget _showProductResult(){
  return SafeArea(
    child:  SingleChildScrollView(
      child: Column(
        children: [
          product.descripcion != null ?  _showInfo() : Container(),              
                 
          product.rolls != null  ? _showListRolls(): Container(),
                 
          movs.isEmpty ? Container() : _showListMovs(),
        ],
      ) 
    ),
  );
 } 

 Widget _showListRolls() {
  return  Container(
    color: kColorAlternativo,
      child: Column( 
        children: [
        const SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
            child: Center(
              child: Text(
                "Rollos",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(20),
                  color: kContrateFondoOscuro,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        const Divider(
            height: 10,
            thickness: 2,
            color: kContrastColor,
          ), 
          
          SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: 
            [
              ...List.generate(
              product.rolls!.length,
                (index) {      
                    return CardRoll(roll: product.rolls![index],);          
                },
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
          ),
            const Divider(
          height: 10,
          thickness: 2,
          color: kContrastColor,
          ), 
        ],
      ),
    );
  } 

 Widget _showListMovs() {
  return  Container(
    
    color: kColorAlternativo,
      child: Column( 
      
        children: [
        const SizedBox(height: 10,),
          Center(
            child: Text(
              "Movimientos",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(20),
                color: kContrateFondoOscuro,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        const Divider(
            height: 10,
            thickness: 2,
            color: kContrastColor,
          ), 
          
          SizedBox(
            height: 180,
            child: SingleChildScrollView(
              
            scrollDirection: Axis.vertical,
            child: Column(
              children: 
              [
                ...List.generate(
                movs.length,
                  (index) {      
                      return CardMovimiento(descuento: movs[index]);          
                  },
                ),
                SizedBox(width: getProportionateScreenWidth(20)),
              ],
            ),
            ),
          ),
            const Divider(
          height: 10,
          thickness: 2,
          color: kContrastColor,
          ), 
        ],
      ),
    );
  }     

 Widget _showInfo() {     
  return Container(
      decoration:  const
      BoxDecoration(
        color: kContrastColorMedium,             
      ),
        child: Padding(
          padding:  const EdgeInsets.only(left: 20.0, right: 20, top:10, bottom: 10),  
          child: Card(
                color:Colors.white70,
                shadowColor: kPrimaryColor,
                elevation: 8,
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
                      TextDerecha(texto:product.rolls!.length.toString()),
                        const SizedBox(width: 10,),
                      const TextEncabezado(texto:'Ultima Entrada: '),
                      TextDerecha(texto:product.ultimaEntrada!),                           
                    
                  ],),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ 
                      const TextEncabezado(texto:'Total Entradas: '),
                      TextDerecha(texto:product.totalEntradas.toString()),   
                        const SizedBox(width: 10,),                      
                    const TextEncabezado(texto:'Total Salidas: '),
                      TextDerecha(texto:product.totalSalidas.toString()),  
                    ],),
                      Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ 
                      const TextEncabezado(texto:'Prom Compra: '),
                      TextDerecha(texto:NumberFormat("##.0#", "en_US").format(product.precioPromedio)),   
                        const SizedBox(width: 10,),                      
                         const TextEncabezado(texto:'Ult Compra: '),
                       TextDerecha(texto: NumberFormat("##.0#", "en_US").format(product.ultimoPrecio)),  
                    ],),
                        Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ 
                      const TextEncabezado(texto:' Prom Venta: '),
                      TextDerecha(texto:product.promVenta!),   
                        const SizedBox(width: 10,),                      
                         const TextEncabezado(texto:'Ult Venta: '),
                       TextDerecha(texto: product.ultimaVenta!),  
                    ],),
                  ]),
          ),
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
          labelText: 'Codigo Rollo',
          errorText: codigoShowError ? codigoError : null,
          suffixIcon: IconButton(iconSize: 40, onPressed:  goGetProduct, icon: const Icon(Icons.search_sharp, color: Color.fromARGB(255, 35, 145, 39),),)
         
        ),
    
      ),
    );
  }

 Widget _showCodigoProducto() {
    return Container(
      color: kContrastColor,
      padding: const EdgeInsets.only(left: 50.0, right: 50, top:20),      
      child: TextField(
        controller: codProController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          
          filled: true,
          hoverColor: const Color.fromARGB(255, 19, 47, 70),
          border:   const OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 5)),
          hintText: 'Ingresa el codigo...',
          labelText: 'Codigo Producto',
          errorText: codProShowError ? codProError : null,
          suffixIcon: IconButton(iconSize: 40, onPressed: goProductByID, icon: const Icon(Icons.search_sharp, color: Color.fromARGB(255, 35, 145, 39),),)
         
        ),
    
      ),
    );
  }

 bool _validateCodigo() {
    bool isValid = true;

    if (codigoController.text.isEmpty) {
      isValid = false;
      codigoShowError = true;
      codigoError = 'Digite el Codigo.';
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

 void goGetProduct() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (!_validateCodigo()) {
      return;
    }
    int code22 = int.parse(codigoController.text);
     _getProduct(code22);
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
      _getProductScan();
  }
  
 Future _getProduct(int code) async {
    setState(() {
        showLoader=true;
    }); 
   
    Response response = await ApiHelper.getProductByRoll(code);

    setState(() {
        showLoader=false;
    });
  
    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'El Producto No Existe', 
        message: response.message,
        actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }    
     
    setState(() {
      product = response.result;     
    });

    List<Descuento> descAux = [];
    for (var v in product.rolls!) {
      descAux.addAll(v.descuentos!);   
    }

    setState(() {
      movs=descAux;
      swicht = false;
    });
  }

 Future _getProductScan() async {
    
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
     Response response = await ApiHelper.getProductByRoll(code);

    setState(() {
        showLoader=false;
    });
  
     if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'El Producto No Existe', 
        message: response.message,
        actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }    

    setState(() {
      product = response.result;
      codigoController.text=code.toString();
    });
  }

 goBack() async {
        Navigator.push(
          context,  
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: widget.user,)
      ));  
  }
  
 refrescar() {
    setState(() {
      swicht =true;
    });
  }

 void _goChange(selectedItem) {
    setState(() {            
       auxProduct = selectedItem;
    });
    _getColors();
  }

 void _goChangeColor(selectedItem)  {
     setState(() { 
      auxColor=selectedItem;
    });
  }   
 
 Future goProductByID() async {
    if(codProController.text.isEmpty){
      await Fluttertoast.showToast(
          msg: "Digite el codigo del producto",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 48, 168, 84),
          textColor: Colors.white,
          fontSize: 16.0
      );     
      return;
    }

     if(int.tryParse(codProController.text) == null){
       await Fluttertoast.showToast(
          msg: "Digite un numero valido",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 48, 168, 84),
          textColor: Colors.white,
          fontSize: 16.0
      );     
      return;
    }

    int cod= int.parse(codProController.text);

     _getProductById(cod);

  }

 Future  goBuscarSelect() async {
    if(auxColor.descripcion==null){
      await Fluttertoast.showToast(
          msg: "Seleccione un Producto y/o Color",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 48, 168, 84),
          textColor: Colors.white,
          fontSize: 16.0
      );     
      return;
    }
      _getProductById(auxColor.id!);
  }
  
 Future _getProductById(int code) async {
     setState(() {
        showLoader=true;
    }); 
   
    Response response = await ApiHelper.
    getPRoductById(code);

    setState(() {
        showLoader=false;
    });
  
    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'El Producto No Existe', 
        message: response.message,
        actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }    
     
    Product aux = response.result;

    List<Descuento> descAux = [];
    for (var v in aux.rolls!) {
      descAux.addAll(v.descuentos!);   
    }

    setState(() {
      movs=descAux;
      swicht = false;
       product = response.result; 
    });
  }
}
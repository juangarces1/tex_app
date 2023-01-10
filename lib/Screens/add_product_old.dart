

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tex_app/Components/combo_colores.dart';
import 'package:tex_app/Components/combo_products.dart';
import 'package:tex_app/Components/custom_appbar_scan.dart';
import 'package:tex_app/Components/default_button.dart';
import 'package:tex_app/Components/text_derecha.dart';
import 'package:tex_app/Helpers/api_helper.dart';
import 'package:tex_app/Models/detalle.dart';
import 'package:tex_app/Models/order.dart';
import 'package:tex_app/Models/product.dart';
import 'package:tex_app/Models/response.dart';
import 'package:tex_app/Models/user.dart';
import 'package:tex_app/Screens/edit_order_screem.dart';
import 'package:tex_app/Screens/order_new.dart';
import 'package:tex_app/constans.dart';

import '../Components/text_encabezado.dart';

class AddOldProduct extends StatefulWidget {
  const AddOldProduct({super.key, required this.orden, required this.user, required this.ruta, });
  final String ruta;
  final Order orden;
  final User user;

  @override
  State<AddOldProduct> createState() => _AddOldProductState();
}

class _AddOldProductState extends State<AddOldProduct> {
  bool showLoader =false;
  Product auxProduct = Product();
  List<Product> products = [];
  List<Product> cProducts = [];
  Product codigoProduct=Product();
  Product defProduct=Product();
  TextEditingController precioController = TextEditingController();
  TextEditingController codigoController = TextEditingController();
  String codigoError = '';
  bool codigoShowError = false; 
 
  String precioError = '';
  bool precioShowError = false; 
  TextEditingController cantidadController = TextEditingController();
  String cantidadError = '';
  bool cantidadShowError = false; 

  @override
  void initState() {
    super.initState();   
    _getProducts(); 
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kContrastColor,
        appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppBar().preferredSize.height),
              child:  CustomAppBarScan(              
                press: () => goBack(),
                 titulo:  Text('Agregue un Producto', style: GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                 image: const AssetImage('assets/ImgAddPro.png'),
              ),
            ),
        body: Container(
          color: kContrastColor,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [ 
                _showCodigo(),
                codigoProduct.descripcion == null ? Container() : _showInfo(),
                const SizedBox(height: 10,),
                ComboProducts(
                  onChanged: _goChange, 
                  backgroundColor: Colors.white60,
                  products: products,
                  titulo: 'Productos'
                ), 
                
                ComboColores(
                  onChanged: _goChangeColor, 
                  backgroundColor: Colors.white, 
                  products: cProducts, 
                  titulo: 'Color'
                ),      
               
                const Divider( height: 40,  thickness: 2, color: kContrastColor, ),  
                _showCantidad(),
                _showPrecio(), 
                const SizedBox(height: 20,),
                DefaultButton(text: 'Agregar', press: _addProduct), 

                ],
              ),
            ),
          ),
        ),
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
                      TextDerecha(texto: codigoProduct.descripcion!),
                    ],
                  ),
                    Row(
                    children: [
                      const TextEncabezado(texto: 'Color: '),
                      TextDerecha(texto: codigoProduct.color!),
                    ],
                  ),
                    Row(
                    children: [
                      const TextEncabezado(texto: 'Stock: '),
                      TextDerecha(texto: codigoProduct.stock!.toString()),
                    ],
                  ),
                ]),
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
     _getProductCodigo(code22);
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
  
  Future _getProductCodigo(int codigo) async {
    setState(() {
        showLoader=true;
    });
   
    Response response = await ApiHelper.getPRoductById(codigo);
    setState(() {
        showLoader=false;
    });

    if (!response.isSuccess) {
      await Fluttertoast.showToast(
          msg: "El Producto no existe",
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
      codigoProduct = response.result;
      defProduct.descripcion=null;
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

  Future<void> _getProducts() async {
   setState(() {
      showLoader = true;
     
    });   

    Response response = await ApiHelper.getProducts();

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
      products = response.result;       
    });
  }

  Future<void> _getColors() async {
    if(auxProduct.descripcion==null){
      return;
    }
    
    setState(() {
      cProducts.clear();
      showLoader = true;
      defProduct.descripcion=null;
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
      cProducts = response.result;       
    });
  }

  void _goChange(selectedItem) {
    setState(() {            
       auxProduct = selectedItem;

    });
    _getColors();
  }
  
  goBack() async {
    if(widget.ruta=="Edit"){
      Navigator.of(context).pushReplacement(  
      MaterialPageRoute(
        builder: (context) => EditOrderScreen(user: widget.user, orden: widget.orden,isOld: true,)
    ));  
    }
    else{
       Navigator.of(context).pushReplacement(  
       MaterialPageRoute(
        builder: (context) => OrderNewScreen(user: widget.user, orden: widget.orden, isOld: true,)
    ));  
    }
  }

  void _goChangeColor(selectedItem)  {
     setState(() { 
      defProduct=selectedItem;
       codigoProduct.descripcion=null;
    });
  }

 _addProduct() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (codigoProduct.descripcion==null && defProduct.descripcion==null){
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

    Product aux = Product();

    if(codigoProduct.descripcion!=null){
      aux=codigoProduct;
    }
    else{
        aux=defProduct;
    }

    Detalle detailAux =  Detalle(); 
    detailAux.producto=aux.descripcion;
    detailAux.cantidad=double.parse(cantidadController.text);
    detailAux.price=double.parse(precioController.text);
    detailAux.codigoRollo=0;
    detailAux.codigoProducto=aux.id??0;
    detailAux.color=aux.color!;
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

     goBack();

  }
}
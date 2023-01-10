import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:tex_app/Components/combo_categorias.dart';
import 'package:tex_app/Components/combo_products.dart';
import 'package:tex_app/Components/default_button.dart';
import 'package:tex_app/Components/loader_component.dart';
import 'package:tex_app/Components/text_derecha.dart';
import 'package:tex_app/Components/text_encabezado.dart';
import 'package:tex_app/Helpers/api_helper.dart';
import 'package:tex_app/Models/category.dart';
import 'package:tex_app/Models/inventario.dart';
import 'package:tex_app/Models/product.dart';
import 'package:tex_app/Models/response.dart';
import 'package:tex_app/Models/user.dart';
import 'package:tex_app/Screens/home_screen.dart';
import 'package:tex_app/constans.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key, required this.user});
  final User user;

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  Inventario inventario = Inventario(detalle: []);
  bool showLoader = false;
  List<Product> products = [];
  Product product = Product();
  List<Category> categories = [];
  Category category = Category();

  @override
  void initState() {
    super.initState();   
    _getProducts(); 
    _getCategories();
  }
      
 @override
 Widget build(BuildContext context) {
    return SafeArea(child: 
     Stack(
      children: [
        Scaffold(
          appBar:  AppBar(
            backgroundColor: kPrimaryColor,
            title:  Text( 'Inventario', style : GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          actions: [
            inventario.detalle.isNotEmpty ? IconButton(onPressed: () => refrescar(), icon: const Icon(Icons.filter_alt, size: 20, color: Colors.white,),)  : Container()
          ],
          ),
          body:  inventario.detalle.isNotEmpty ? tablaInv() : formInv(),
          bottomNavigationBar: BottomAppBar(
          color: kContrastColorMedium,
          shape: const CircularNotchedRectangle(),
          child: IconTheme(
           data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
           child: SizedBox(
            height: 50,
             child: inventario.detalle.isNotEmpty ? 
              Center(
                child: Row(
                 mainAxisSize: MainAxisSize.max,
                 mainAxisAlignment: MainAxisAlignment.start,
                  children:  <Widget>[             
                  const SizedBox(width: 40,),
                  const TextEncabezado(texto: 'Total: '),
                  TextDerecha(texto: inventario.total!),
                  const SizedBox(width: 5,),
                  const TextEncabezado(texto: 'Mts: '),
                  TextDerecha(texto: inventario.metros!),
                  const SizedBox(width: 5,),
                  const TextEncabezado(texto: 'Kgs: '),
                  TextDerecha(texto: inventario.kilos!),
                  const SizedBox(width: 5,),
                  const TextEncabezado(texto: 'Rollos: '),
                  TextDerecha(texto: inventario.rollos!),
                ],          
              ),
            ) : Container(),
           ),
          ),
         ), ),
        showLoader ? const LoaderComponent(text: 'Cargando') : Container(),
      ],
     ));
  }

 Future<void> _getInventario(Map<String, dynamic> request) async {
   setState(() {
   
      showLoader = true;
    });   

     Response response = await ApiHelper.post(
     'api/Kilos/GetInventario/', 
      request,
    );    

    setState(() {
      showLoader = false;
    });

    if (!response.isSuccess) {
      await Fluttertoast.showToast(
          msg: "No Hay Productos",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 48, 168, 84),
          textColor: Colors.white,
          fontSize: 16.0
      );     
      return;
    } 
   
    var decodedJson = jsonDecode(response.result); 
      setState(() {
        inventario = Inventario.fromJson(decodedJson);   
      });
    }

 Widget tablaInv() {
    return HorizontalDataTable(
        leftHandSideColumnWidth: 110,
        rightHandSideColumnWidth: 560,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: inventario.detalle.length,
        rowSeparatorWidget: const Divider(
          color:kPrimaryColor,
          height: 1.0,
          thickness: 0.0,
        ),
        
        leftHandSideColBackgroundColor: const Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
      );
  }

 Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
        width: 100,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,      
        child: Text(inventario.detalle[index].categoria!),
        ),
        Container(
        width: 80,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Text(inventario.detalle[index].medida!),
        ),
        Container(
        width: 70,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Text(inventario.detalle[index].inventario!),
        ),
        Container(
        width: 70,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Text(inventario.detalle[index].invAlmacen!),
        ),
        Container(
        width: 70,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Text(inventario.detalle[index].invBodega!),
        ),
         Container(
        width: 70,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Text(inventario.detalle[index].totalRollos!.toString()),
        ),
         Container(
        width: 100,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Text(inventario.detalle[index].valor!),
        ),
      ]);
  }

 Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: 110,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text('${inventario.detalle[index].producto} ${inventario.detalle[index].color}'),
    );
  }

 List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Producto', 110),      
      _getTitleItemWidget('Categoria', 100),
      _getTitleItemWidget('Medida', 80),
      _getTitleItemWidget('Stock', 70),
      _getTitleItemWidget('Stock Alm', 70),
      _getTitleItemWidget('Stock Bod', 70),
      _getTitleItemWidget('Rollos', 70),
      _getTitleItemWidget('Valor', 100),
      
    ];
  }

 Widget _getTitleItemWidget(String label, double width) {
    return Container(
      color: kContrastColorMedium,
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
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
  
 goBack() async {
      Navigator.push(
        context,  
       MaterialPageRoute(
        builder: (context) => HomeScreen(user: widget.user,)
    ));  
  }
  
 Widget formInv()  {
    return Container(
      color: kContrastColorMedium,
      child: Center(
        child: Column(children:  [
      
          Container(
            color: kContrastColorMedium,
            child: Padding(padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 15),
              child: Card(
                  color:kContrastColor,
                  shadowColor: kPrimaryColor,
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(children: [
                    ComboProducts(onChanged: changeProduct, backgroundColor: kContrastColor, products: products, titulo: 'Productos'),
                    DefaultButton(text: ' X Producto', press: () => getByProduct(),),
                    const SizedBox(height: 20,),
                  ]),
              ),
            ),
          ),

            Container(
            color: kContrastColorMedium,
            child: Padding(padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15),
              child: Card(
                  color:kContrastColor,
                  shadowColor: kPrimaryColor,
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(children: [
                     ComboCategorias(onChanged: changeCategoria, backgroundColor: kContrastColor, categories: categories, titulo: 'Categorias'),
                     DefaultButton(text: 'X Categoria', press: () => getByCategoria(),),
                    const SizedBox(height: 20,),
                  ]),
              ),
            ),
          ),          
          
          const SizedBox(height: 10,),
           DefaultButton(text: 'Todo', press: () => goAll(),),
          const SizedBox(height: 10,),        
         
        ]),
      ),
    );
  }
  
 goAll() async {

  Map<String, dynamic> data = <String, dynamic>{};
    data['Tipo'] = 'Todo';
    data['descripcion'] = '';
    data['categoria'] = '';
    
    _getInventario(data);

  }
  
 refrescar() async {
   
    setState(() {
      inventario.detalle=[];
      
    });
  }
  
 getByProduct() async {
 if(product.descripcion==null){
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
  Map<String, dynamic> data = <String, dynamic>{};
    data['Tipo'] = 'Nombre';
    data['descripcion'] = product.descripcion;
    data['categoria'] = '';
    
    _getInventario(data);

}  

 Future<void>  _getCategories() async {
     setState(() {
      showLoader = true;
    });
    
    
   
    Response response = await ApiHelper.getCategoies();

    setState(() {
      showLoader = false;
    });

    if(!response.isSuccess){
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
        categories=response.result;
    });
  }  
 
 getByCategoria()  async {
      if(category.name==null){
        await Fluttertoast.showToast(
          msg: "Seleccione una Categoria",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );     
      return;
  }
  Map<String, dynamic> data = <String, dynamic>{};
    data['Tipo'] = 'cate';
    data['descripcion'] = '';
    data['categoria'] = category.name;
    
    _getInventario(data);
  }

 void changeProduct(selectItem) {
    setState(() {
      product=selectItem;
    });
  }

 void changeCategoria(selectItem) {
    category=selectItem;
  }
}
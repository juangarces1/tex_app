
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tex_app/Helpers/api_helper.dart';
import 'package:tex_app/Models/color.dart';
import 'package:tex_app/Models/product.dart';
import 'package:tex_app/Models/productlist.dart';
import 'package:tex_app/Models/response.dart';
import 'package:tex_app/Models/supplier.dart';
import 'package:tex_app/Models/user.dart';
import 'package:tex_app/sizeconfig.dart';

import '../../constans.dart';
import '../Components/default_button.dart';
import '../Models/category.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({ Key? key,  required this.user}) : super(key: key); 
  final User user;
  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
   // ignore: unused_field
  bool _showLoader = false;
  DateTime date = DateTime.now();
  int categoryId = 0;
  String colorNombre = '';
  int medida=-1;
  int supId = 0;
  TextEditingController controllerDes = TextEditingController();
  bool desShowError = false;
  String desError='';
  bool colorShowError = false;
  String colorError='';
  bool catShowError = false;
  String catError='';
  bool medShowError = false;
  String medError='';

  List<Supplier> suppliers=[];
  List<MyColor> colors=[];
  List<Category> categories = [];
  List<Product> products = [];
 

  @override
  void initState() {
    super.initState();  
     _getColors();
     _getCategories();
  }
    
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
        backgroundColor: kColorAlternativo,
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title:  const Text(
              'Crear Producto(s)',
              style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: Container(
          color: kColorAlternativo,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [              
                _showForm(),            
                const Divider( height: 40,  thickness: 2, color: kContrastColor, ),               
                _showListNew(),
                const Divider( height: 40,  thickness: 2, color: kContrastColor, ),  
                 DefaultButton(text: 'Crear', press: () => _goSave(),),
                const SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ),

          bottomNavigationBar: BottomAppBar(
              notchMargin: 6.0,
          color: kPrimaryColor,
          shape: const CircularNotchedRectangle(),
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
             mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[               
              SizedBox(                
                height: 50,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                    'Productos:${products.length.toString()}', 
                      style: const TextStyle(
                        color: Colors.white,
                         fontSize: 18, 
                         fontWeight: FontWeight.bold),
                         ),
                  ),
                ),
              ),
             
               ],          
             ),
          ),
         ), 
        
      ),
    );

  }

Widget _showDescripcion() {
   return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),      
      child: TextField(  
        controller: controllerDes,    
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Ingresa el Nombre...',
          labelText: 'Nombre',
          errorText: desShowError ? desError : null,
          suffixIcon: const Icon(Icons.message_outlined)
         
        ),
        
      ),
    );
  }
   
 Widget _showListNew() {
  return  Container(
  color: kColorAlternativo,
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
            products.length,
              (index) {      
                  return productCard(products[index]);          
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

 Widget _showForm() {
    return  Container(
      color: kColorAlternativo,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 10, left: 10, top: 10),
        child: Card(
          color: kContrateFondoOscuro,
                    shadowColor: kPrimaryColor,
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(           
            children: [          
             
            const SizedBox(height: 20,),   
            const Text('Llene todos los datos', style: TextStyle(color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold),),    
             _showDescripcion(),          
             _showCategories(),
             _showMedida(),
             _showColors(),
                 
            SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                 shape: const CircleBorder(), backgroundColor: kPrimaryColor, 
                 padding: const EdgeInsets.all(8),
                ),
                onPressed: _goAdd,
               child: const Icon(
                 Icons.add,
                  size: 30,
                ),
              ),
            ),
               const SizedBox(height: 10,),
          ]),
        ),
      ),
    );
  }

 bool _validateFields() {

    bool isValid = true;

    if (controllerDes.text.isEmpty) {
      isValid = false;
      desShowError = true;
      desError = 'Debes ingresar el nombre.';
    } else {
      desShowError = false;
    }   
    
    if(colorNombre == ''){
        isValid = false;
        colorShowError = true;
        colorError = 'Debes escoger un color.';
    } else {
      colorShowError = false;
    }

    
    if(medida < 0){
        isValid = false;
        medShowError = true;
        medError = 'Debes escoger una Unidad.';
    } else {
      medShowError = false;
    }

  


     
    
    if(categoryId == 0){
        isValid = false;
        catShowError = true;
        catError = 'Debes escoger categoria.';
    } else {
      catShowError = false;
    }
    
    
    
  

    setState(() {});
    return isValid;
  }

 Widget productCard(Product product) {
  return Padding(
    padding: EdgeInsets.only(left: getProportionateScreenWidth(20), bottom: 10),
    child:  Stack(
        children: [
          Card(
              color:kContrastColor,
                shadowColor: kPrimaryColor,
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding
              (
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(children: [
                    Text(
                      'Descripcion: ',
                      style:  TextStyle(
                        color: kPrimaryColor,
                        fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.w600,
                      ),                      
                      ),
                    Text(
                          product.descripcion.toString(),
                          style:  TextStyle(
                            color: kTextColorBlack,
                            fontSize: getProportionateScreenWidth(16),
                                fontWeight: FontWeight.w500,
                          ),
                        
                        ),

                      ],
                      ),
                
                  Row(children: [
                        Text(
                          'Color: ',
                          style:  TextStyle(
                            color: kPrimaryColor,
                            fontSize: getProportionateScreenWidth(18),
                                fontWeight: FontWeight.w600,
                          ),
                  
                          ),
                        Text(
                              product.color!.toString(),
                              style:  TextStyle(
                                color: kTextColorBlack,
                                fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.w500,
                              ),
                            
                            ),

                          ],
                      ),
                
                  Row(children: [
                        Text(
                          'Categoria: ',
                          style:  TextStyle(
                            color: kPrimaryColor,
                            fontSize: getProportionateScreenWidth(18),
                                fontWeight: FontWeight.w600,
                          ),
                  
                          ),
                        Text(
                                product.category!.name.toString(),
                              style:  TextStyle(
                                color: kTextColorBlack,
                                fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.w400,
                              ),
                            
                            ),

                          ],
                      ),
                      Row(children: [
                        Text(
                          'Medida: ',
                          style:  TextStyle(
                            color: kPrimaryColor,
                            fontSize: getProportionateScreenWidth(18),
                                fontWeight: FontWeight.w600,
                          ),
                  
                          ),
                        Text(
                              medida == 0 ?   'Metros' : 'Kilos',
                              style:  TextStyle(
                                color: kTextColorBlack,
                                fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.w400,
                              ),
                            
                            ),

                          ],
                      ),
                     
          
              ],                  
            ),
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
                    content: const Text('Desea eliminar la producto?'),
                    actions: [
                      TextButton(onPressed: () {
                        Navigator.of(context).pop(false);
                      }, child: const Text('No')),
                        TextButton(onPressed: (){
                        
                          setState(() {
                          
                            products.remove(product);
                          
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
  );
}
 
 void _goSave()  async {
    if(products.isEmpty){
       await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Agregue un producto.',
        actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

  
    
     setState(() {
      _showLoader = true;
    });

   ProductList productList = ProductList(productos: products, document: widget.user.document);

   Map<String, dynamic> request = productList.toJson();

    Response response = await ApiHelper.post(
     'api/Kilos/PostProduct/', 
      request, 
      
    );

    setState(() {
      _showLoader = false;
    });

   

     if (!response.isSuccess) {
       showErrorFromDialog(response.message);
      return;      
    }  
              

      setState(() {
       products.clear();
      });
      
   

       await  Fluttertoast.showToast(
          msg: 'Producto(s) Creado(s)\nCorrecatemente',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 19, 175, 45),
          textColor: Colors.white,
          fontSize: 16.0
      );     

  }

 _goAdd() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    if (!_validateFields()) {
      return;
    }

    Category categoria = categories.firstWhere((element) => element.id==categoryId); 
    
    Product aux = Product(id: 0,category: categoria, color: colorNombre, descripcion: controllerDes.text, stock: 0, stockEnAlmacen: 0, stockEnBodega: 0, medida: medida.toString());
    setState(() {
      products.insert(0, aux);
    });

  }

 Future<void>  _getColors() async {
     setState(() {
      _showLoader = true;
    }); 
    
    Response response = await ApiHelper.getColors();

    setState(() {
      _showLoader = false;
    });

     if (!response.isSuccess) {
       showErrorFromDialog(response.message);
      return;      
    }  
    setState(() {
     
        colors=response.result;
    });
  }  
 
 Future<void>  _getCategories() async {
     setState(() {
      _showLoader = true;
    });
    
    
   
    Response response = await ApiHelper.getCategoies();

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
       showErrorFromDialog(response.message);
      return;      
    }    
    setState(() {
     
        categories=response.result;
    });
  }  
 
 List<DropdownMenuItem<String>> _getComboColors() {
    List<DropdownMenuItem<String>> list = [];

    list.add(const DropdownMenuItem(
      value: '',
      child: Text('Seleccione un Color...'),
    ));

    for (var item in colors) {
      list.add(DropdownMenuItem(
        value: item.nombre,
        child: Text(item.nombre.toString()),
      ));
    }

    return list;
  }

 Widget _showColors() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: kContrateFondoOscuro,
              borderRadius: BorderRadius.circular(10),
          ),
          
          child: colors.isEmpty
              ? const Text('Cargando...')
              : DropdownButtonFormField(
                  items: _getComboColors(),
                  value: colorNombre,
                  onChanged: (option) {
                    setState(() {
                      colorNombre = option as String;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Seleccione un Color...',
                    labelText: 'Color',
                    errorText:
                        colorShowError ? colorError : null,
                   
                  ),
                )),
    );
  }

 List<DropdownMenuItem<int>> _getComboMedida() {
    List<DropdownMenuItem<int>> list = [];

    list.add(const DropdownMenuItem(
      value: -1,
      child: Text('Seleccione una Unidad...'),
    ));

     list.add(const DropdownMenuItem(
      value: 0,
      child: Text('Metros'),
    ));
     
      list.add(const DropdownMenuItem(
      value: 1,
      child: Text('Kilos'),
    ));
    

    return list;
  }

 Widget _showMedida() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: kContrateFondoOscuro,
              borderRadius: BorderRadius.circular(10),
          ),
          
          child: colors.isEmpty
              ? const Text('Cargando...')
              : DropdownButtonFormField(
                  items: _getComboMedida(),
                  value: medida,
                  onChanged: (option) {
                    setState(() {
                      medida = option as int;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Seleccione una Unidad...',
                    labelText: 'Unidad De Medida',
                    errorText:
                        medShowError ? medError : null,
                   
                  ),
                )),
    );
  }

 List<DropdownMenuItem<int>> _getComboCategories() {
    List<DropdownMenuItem<int>> list = [];

    list.add(const DropdownMenuItem(
      value: 0,
      child: Text('Seleccione una Categoria...'),
    ));

    for (var item in categories) {
      list.add(DropdownMenuItem(
        value: item.id,
        child: Text(item.name.toString()),
      ));
    }

    return list;
  }

 Widget _showCategories() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: kContrateFondoOscuro,
              borderRadius: BorderRadius.circular(10),
          ),
          
          child: categories.isEmpty
              ? const Text('Cargando...')
              : DropdownButtonFormField(
                  items: _getComboCategories(),
                  value: categoryId,
                  onChanged: (option) {
                    setState(() {
                      categoryId = option as int;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Seleccione una cantegoria...',
                    labelText: 'Categorias',
                    errorText:
                        catShowError ? catError : null,
                   
                  ),
                )),
    );
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




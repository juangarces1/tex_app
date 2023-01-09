import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tex_app/Components/combo_colores.dart';
import 'package:tex_app/Components/combo_products.dart';
import 'package:tex_app/Components/default_button.dart';
import 'package:tex_app/Helpers/api_helper.dart';
import 'package:tex_app/Models/compra.dart';
import 'package:tex_app/Models/product.dart';
import 'package:tex_app/Models/roll.dart';
import 'package:tex_app/Models/supplier.dart';
import 'package:tex_app/Models/user.dart';
import 'package:tex_app/Screens/add_compra_screen.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

import '../Models/response.dart';

class AddRollScreen extends StatefulWidget {
  const AddRollScreen({super.key,
   required this.user, 
    this.compra,
     this.ruta,
     this.fechaRec,
     this.fechafac
   });
  final User user; 
  final Compra? compra;
  final String? ruta;
  final DateTime? fechafac;
  final DateTime? fechaRec;
 
  @override
  State<AddRollScreen> createState() => _AddRollScreenState();
}

class _AddRollScreenState extends State<AddRollScreen> {
  static const status=<String>['Bodega','Almacen'];
  String seletedValue=status.first;
  List<Product> products = [];
  List<Product> pColors = [];
  bool showLoader = false; 
  List<Supplier> suppliers=[];
  bool supShowError = false;
  String supError='';
  bool precioShowError = false;
  String precioError='';
  List<Roll> localrolls = [];
  List<Roll> otrorollos = [];
  TextEditingController cantidadController = TextEditingController();
  String cantidadError = '';
  bool cantidadShowError = false; 
  TextEditingController precioController = TextEditingController();
  Product auxProduct = Product();
  Product defProduct = Product();


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
          appBar: AppBar(
              backgroundColor: kPrimaryColor,
              title: Text(
               widget.ruta == null ? 'Crear Rollo(s)': 'Agregar Rollo(s)',
                style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Container(              
              color: kContrastColor,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [ 
                     const SizedBox(height: 10,),

                     const Text('Seleccione la Ubicacion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                     Padding(
                       padding:   const EdgeInsets.only(left: 10, right: 10, top: 5, ),  
                       child: buildRadios(),
                     ),
                     ComboProducts(onChanged: _goChange, backgroundColor: Colors.white, products: products, titulo: 'Productos'),          
                     ComboColores(onChanged: _goChangeColor, backgroundColor: Colors.white, products: pColors, titulo: 'Color') , 
                     _showCantidad(),
                     _showPrecio(),
                     const SizedBox(height: 10,),                     
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
                    const Divider(height: 10,  thickness: 2, color: kColorFondoOscuro, ), 
                    _showListNew(),
                    const Divider( height: 10,  thickness: 2, color: kColorFondoOscuro, ), 
                    const SizedBox(height: 10,),                    
                    widget.ruta == null ?   DefaultButton(
                      text: 'Crear',
                       press: () => _goSave(),) 
                       : DefaultButton(
                        text: 'Enviar', 
                        press: () => _goCompra(),),                                
                    const SizedBox(height: 20,),
                    ],
                  ),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[               
            SizedBox(                
              height: 50,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                  'Rollos: ${localrolls.length.toString()}', 
                    style: const TextStyle(
                      color: Colors.white,
                        fontSize: 18, 
                        fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
              SizedBox(                
              height: 35,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    localrolls.isNotEmpty ? 'Cantidad: ${NumberFormat("###,000", "es_CO").format(localrolls.map((item)=>item.cantidad!).reduce((value, element) => value + element))}' : '', 
                    style: const TextStyle(
                      color: Colors.white,
                        fontSize: 15, 
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

  void _goChange(selectedItem) {
    setState(() {            
       auxProduct = selectedItem;
    });
    _getColors();
  }

  void _goChangeColor(selectedItem)  {
     setState(() { 
      defProduct=selectedItem;
    });
  }

   bool _validateFields() {
    bool isValid = true;

    if (auxProduct.descripcion == null) {
      isValid=false;
      Fluttertoast.showToast(
        msg: "Seleccione un Producto",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      ); 
        return isValid;  
    }  

    if (defProduct.descripcion == null) {
      isValid=false;
        Fluttertoast.showToast(
          msg: "Seleccione un Color",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );   
      return isValid;  
    }  

    if (cantidadController.text.isEmpty) {
      isValid = false;
      cantidadShowError = true;
      cantidadError = 'Debes ingresar la cantidad.';
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


 Future<void> _getColors() async {
    if(auxProduct.descripcion==null){
      return;
    }
    
    setState(() {
      pColors.clear();
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
        pColors = response.result;       
      });
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
 
 Widget _showListNew() {
  return  Container(
  color: kContrastColor,
    child: Column( 
      children: [
       
        SizedBox(height: getProportionateScreenWidth(5)),
        SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: 
          [
            ...List.generate(
            localrolls.length,
              (index) {      
                  return cardRollNew(localrolls[index]);          
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

  Widget cardRollNew(Roll roll) {
    return Padding(
    padding: EdgeInsets.only(left: getProportionateScreenWidth(20), bottom: 10),
    child:  Stack(
      children: [
       Card(
          color:Colors.white,
          shadowColor: kPrimaryColor,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 50, bottom: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Row(children: [
                  Text(
                    'Producto: ',
                    style:  TextStyle(
                      color: kPrimaryColor,
                      fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                    ),                      
                    ),
                   Text(
                    //aqui deberia ir la descripcion 
                    //pero por algun motivo se pierde cuando
                    //refresca el estado
                     roll.medida!.toString(),
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
                    roll.product!.color!.toString(),
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
                    'Cantidad: ',
                    style:  TextStyle(
                      color: kPrimaryColor,
                      fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                    ),                      
                    ),
                  Text(
                    roll.cantidad.toString(),
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
                    'Precio: ',
                    style:  TextStyle(
                      color: kPrimaryColor,
                      fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                    ),        
                  ),
                  Text(
                    roll.precio.toString(),
                    style:  TextStyle(
                      color: kTextColorBlack,
                      fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w500,
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
              onTap: () => pressDelete(roll),
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
 
 _goSave() async {
  if(localrolls.isEmpty){
    Fluttertoast.showToast(
      msg: "Agregue un rollo",
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
    showLoader = true;
  });

  Map<String, dynamic> request = 
    {
      'document': widget.user.document,
      'rollos' : localrolls.map((v) => v.toJson()).toList()       
    };

  Response response = await ApiHelper.post(
    'api/Kilos/PostRolls/', 
    request,       
  );

  setState(() {
    showLoader = false;
  });

  if (!response.isSuccess) {     

    await  Fluttertoast.showToast(
      msg: "Error al crear el rollo",
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
    localrolls.clear();
  });
    

   await  Fluttertoast.showToast(
      msg: 'Rollo(s) Creado(s)\nCorrecatemente',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 11, 172, 91),
      textColor: Colors.white,
      fontSize: 16.0
    );     
    return; 
  
  }

 void _goAdd() {
  FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (!_validateFields()) {
      return;
    }
    double cant = double.parse(cantidadController.text);
    double precio = double.parse(precioController.text);
    defProduct.rolls=null;
    Roll rollAux = Roll(id: 0, cantidad: cant, precio: precio, product: defProduct, medida: defProduct.descripcion, status: seletedValue); 

   setState(() {
       localrolls.insert(0, rollAux);
    
       cantidadController.text='';
   });
  
  }
  
  _goCompra() async {
      if(localrolls.isEmpty){
        await Fluttertoast.showToast(
          msg: "Agregue un Rollo",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 219, 223, 32),
          textColor: Colors.white,
          fontSize: 16.0
      );     
        return;
      }
        widget.compra!.rolls!.addAll(localrolls);
       
        Navigator.push(
         context, 
         MaterialPageRoute(
           builder: (context) => AddCompraScreen(user: widget.user, compra: widget.compra!, fechaFactura: widget.fechafac!, fechaFacturaRecepcion: widget.fechaRec!,)
         )
       );
  }

  
  pressDelete(Roll roll) {
    return  showDialog(
      context: context,
      builder: (_) =>  AlertDialog(
        title: const Text('Eliminar'),
        content: const Text('Desea eliminar el rollo?'),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          }, child: const Text('No')),
            TextButton(onPressed: (){
            
              setState(() {
              
                localrolls.remove(roll);
              
              });
              Navigator.of(context).pop(true);
            },
          child: const Text('Sí')),
        ],    
      ));
    }     
  
   Widget buildRadios() => Row(
    children: status.map(
      (value) {
        return  Expanded(
          child: RadioListTile<String>(
            activeColor: kPrimaryColor,
              value: value,
              groupValue: seletedValue,
              title:  Text(value),
              onChanged: (value) => setState(() => seletedValue = value as String),
          ),
        );
      }
    ).toList(),
   );
 
}
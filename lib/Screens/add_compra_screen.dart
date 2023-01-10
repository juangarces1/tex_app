

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tex_app/Components/combo_suplliers.dart';
import 'package:tex_app/Components/loader_component.dart';
import 'package:tex_app/Helpers/api_helper.dart';
import 'package:tex_app/Models/compra.dart';
import 'package:tex_app/Models/roll.dart';
import 'package:tex_app/Models/supplier.dart';
import 'package:tex_app/Models/user.dart';
import 'package:tex_app/Screens/add_roll_screen.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

import '../Models/response.dart';

// ignore: must_be_immutable
class AddCompraScreen extends StatefulWidget {
   AddCompraScreen({
    super.key,
     required this.user,
      required this.compra,
      required this.fechaFactura,
      required this.fechaFacturaRecepcion
    });
  final User user;
  final Compra compra;
  DateTime fechaFactura;
  DateTime fechaFacturaRecepcion;

  @override
  State<AddCompraScreen> createState() => _AddCompraScreenState();
}

class _AddCompraScreenState extends State<AddCompraScreen> {
  
  bool showLoader = false; 
  List<Supplier> suppliers=[];

  TextEditingController facNumController = TextEditingController();
  String facNumError = '';
  bool facNumShowError = false; 

  TextEditingController subTotalController = TextEditingController();
  String subTotalError = '';
  bool subTotalShowError = false; 


  
  @override
  void initState() {
    super.initState();   
    _getSuppliers(); 
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
    
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: kContrastColor,
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              title:  const Text(
                'Crear Compra',
                style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                
                ),
              ),
            ),

            body: SingleChildScrollView(
              child: Container(
                color: kContrastColor,
                child: Column(children: [
                 
                     
                  const SizedBox(height: 10,),
                    ComboSuplliers(onChanged: _goChange, backgroundColor: Colors.white60, suppliers: suppliers, titulo: 'Proveedores'),
                  _showFacNum(),       
                  const SizedBox(height: 15,),      
                  _showfecha(),
                  _showfechaRecepcion(),
                  _showSubTotal(),
                   const Divider( height: 10,  thickness: 2, color: kPrimaryColor, ), 
                  _showListNew(),
                   const Divider( height: 10,  thickness: 2, color: kPrimaryColor, ),   
                        
                  Padding(
                       padding: const EdgeInsets.only(top: 3, bottom: 3),
                       child: RawMaterialButton(
                          onPressed: goAddRoll,
                          elevation: 2.0,
                          fillColor: kPrimaryColor,
                          padding: const EdgeInsets.all(12.0),
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.add,
                            size: 25.0,
                            color: Colors.white,
                          ),
                        ),
                     ),
                  const SizedBox(height: 20,),                 
            
                ]
                ),
              ),
            ),
           bottomNavigationBar: BottomAppBar(
              color:  kPrimaryColor,
              shape: const CircularNotchedRectangle(),
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
                child: Row(
                 mainAxisSize: MainAxisSize.max,
                 mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(             
                    icon: const Icon(Icons.menu, color: kContrastColorMedium,),
                    onPressed: () {},
                  ),
                  Text(
                   widget.compra.rolls!.isNotEmpty ? 'Rollos: ${widget.compra.rolls!.length.toString()}  -  Total: ${NumberFormat("###,000", "es_CO").format(widget.compra.rolls!.map((item)=>item.cantidad!).reduce((value, element) => value + element))}' : '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),),

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
          showLoader ? const LoaderComponent(text: 'Procesando...',): Container(),
        ],
      ),
    );
  }

  Widget _showListNew() {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
                widget.compra.rolls!.length,
                  (index) {      
                      return cardRollNew(widget.compra.rolls![index]);          
                  },
                ),
                

              ],
            ),

            ),
           
 
          ],
        ),
      ),
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
              
                widget.compra.rolls!.remove(roll);
              
              });
              Navigator.of(context).pop(true);
            },
          child: const Text('Sí')),
        ],    
      ));
    }  

   Widget cardRollNew(Roll roll) {
    return Padding(
    padding: EdgeInsets.only(left: getProportionateScreenWidth(20), bottom: 10),
    child:  Stack(
      children: [
       Card(
          color:kContrastColorMedium,
          shadowColor: kPrimaryColor,
          elevation: 10,
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
                  color: kContrastColor,
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

  Widget _showFacNum() {
    return Container(
      padding: const EdgeInsets.only(left: 50.0, right: 50),      
      child: TextField(
        controller: facNumController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Ingresa el Numero...',
          labelText: 'Factura Numero',
          errorText: facNumShowError ? facNumError : null,
          suffixIcon: const Icon(Icons.numbers),
         
        ),
    
      ),
    );
  }

  Widget _showfecha() {
  return Padding(padding:  const EdgeInsets.only(left: 50.0, right: 50),
   child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [    
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(
                text: "Fecha Factura\n",
                style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),),
            TextSpan(
              text: "${widget.fechaFactura.year}/${widget.fechaFactura.month}/${widget.fechaFactura.day}\n".toUpperCase(),
              style: const TextStyle(
                color: kPrimaryColor,
                  fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ]
        ),
      ),
       MaterialButton(
          onPressed: () async {
             DateTime? newDate = await  showDatePicker(
              context: context,
              initialDate: widget.fechaFactura,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100)
                );
            if(newDate == null)   return;

            setState(() {
              widget.fechaFactura=newDate;
            });
          },
          color:kMediumColor,
          textColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.calendar_month_outlined,
            size: 20,
            color: Colors.white,
            
          ),
        )
            ]
   ),
   );
 }

  Widget _showfechaRecepcion() {
  return Padding(padding:  const EdgeInsets.only(left: 50.0, right: 50),
   child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [    
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(
                text: "Fecha Recepción\n",
                style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),),
            TextSpan(
              text: "${widget.fechaFacturaRecepcion.year}/${widget.fechaFacturaRecepcion.month}/${widget.fechaFacturaRecepcion.day}\n".toUpperCase(),
              style: const TextStyle(
                color: kPrimaryColor,
                  fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ]
        ),
      ),
       MaterialButton(
          onPressed: () async {
             DateTime? newDate = await  showDatePicker(
              context: context,
              initialDate: widget.fechaFacturaRecepcion,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100)
                );
            if(newDate == null)   return;

            setState(() {
              widget.fechaFacturaRecepcion=newDate;
            });
          },
          color:kMediumColor,
          textColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.calendar_month_outlined,
            size: 20,
            color: Colors.white,
            
          ),
        )
            ]
   ),
   );
 }

  Widget _showSubTotal() {
    return Container(
      padding: const EdgeInsets.only(left: 50.0, right: 50),      
      child: TextField(
        controller: subTotalController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Ingresa el Sub-Total...',
          labelText: 'Sub-Total',
          errorText: subTotalShowError ? subTotalError : null,
          suffixIcon: const Icon(Icons.numbers),
         
        ),
    
      ),
    );
  }
  
  Future<void> _getSuppliers() async {
     setState(() {      
      showLoader = true;
    });   

    Response response = await ApiHelper.getSuppliers();

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
        suppliers = response.result;       
      });
  }

   bool _validateFields() {
    bool isValid = true;

    if (facNumController.text.isEmpty) {
      isValid = false;
      facNumShowError= true;
      facNumError = 'Debes ingresar el numero.';
    } else {
      facNumShowError = false;
    }

    if (subTotalController.text.isEmpty) {
      isValid = false;
      subTotalShowError = true;
      subTotalError = 'Debes ingresar el Sub-Total.';
    } else {
      subTotalShowError = false;
    }
 


    

    setState(() { });
    return isValid;
  }
  
  goAddRoll()  {
     Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => AddRollScreen(user: widget.user, ruta: 'compra', compra: widget.compra, fechaRec: widget.fechaFacturaRecepcion, fechafac: widget.fechaFactura,)
        )
      );
  }
  
   goSave() async {
    if(widget.compra.supplier!.name==null){
      Fluttertoast.showToast(
        msg: "Seleccione un Proveedor",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );  
      return;  
    }

     if (!_validateFields()) {
      return;
    }

     if(widget.compra.rolls==null){
      await Fluttertoast.showToast(
        msg: "Agregue Los Rollos",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
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
    String dateFactura = formatter.format(widget.fechaFactura);
    String dateReceptcion = formatter.format(widget.fechaFacturaRecepcion);
    
    Map<String, dynamic> request = {
      'FacturaNumero': facNumController.text,
      'FechaFactura': dateFactura,
      'Fecharecepcion': dateReceptcion,
      'Subtotal':  double.parse(subTotalController.text),
      'SupplierId': widget.compra.supplier!.supplierId,
      'Rolls': widget.compra.rolls?.map((v) => v.toJson()).toList(),
     
    };   

   
    Response response = await ApiHelper.post(
      'api/Kilos/PostCompra/', 
      request,
      
    );
    setState(() {
      showLoader = false;
    });

    if (!response.isSuccess) {
      await Fluttertoast.showToast(
        msg: "Error Al Grabar",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );  
      return;
    }

     await Fluttertoast.showToast(
        msg: "Factura Grabada Ok",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 61, 184, 50),
        textColor: Colors.white,
        fontSize: 16.0
      );  
       
       setState(() {
         widget.compra.rolls!.clear();
         facNumController.text='';
         subTotalController.text='';
       });

  }
  
  goDelete(Roll roll) {
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
                 widget.compra.rolls!.remove(roll);              
              });
              Navigator.of(context).pop(true);
            },
          child: const Text('Sí')),
        ],    
      ));
  }

  void _goChange(selectedItem) {
    setState(() {
     widget.compra.supplier=selectedItem;
    });
  }
}
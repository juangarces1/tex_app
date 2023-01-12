import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tex_app/Components/card_compra.dart';
import 'package:tex_app/Components/default_button.dart';
import 'package:tex_app/Components/loader_component.dart';
import 'package:tex_app/Helpers/api_helper.dart';
import 'package:tex_app/Models/compra.dart';
import 'package:tex_app/Models/response.dart';
import 'package:tex_app/Models/user.dart';
import 'package:tex_app/Screens/home_screen.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

class CompasScreen extends StatefulWidget {
  final User user;
  const CompasScreen({super.key, required this.user});
  
  @override
  State<CompasScreen> createState() => _CompasScreenState();
}

class _CompasScreenState extends State<CompasScreen> {
  bool swicht =true;
  bool showLoader=false;

  TextEditingController codigoController = TextEditingController();
  String codigoError = '';
  bool codigoShowError = false; 

  DateTime fromDate  = DateTime.now();
  DateTime toDate  = DateTime.now();

  List<Compra> compras = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                            Text('Consulta Compras ', style: TextStyle(color: Colors.white, fontSize: 20),),
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
        body:  swicht ? formCompra() : _showCompraResult()
        ),
    );
  }

  goBack() async {
        Navigator.push(
          context,  
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: widget.user,)
      ));  
  }

  
  formCompra() {
    return Stack(
          children: [
            Container(
              color: kContrastColor,
              child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children:  [ 
                                   
                    Container(                    
                      color: kContrastColor,
                      child: _showCodigo()),  
                      
                      
                     Container(height: 15, color:kContrastColor,),
                       Padding(
                        padding:  const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                         child: Card(                    
                            color:Colors.white,
                            shadowColor: kPrimaryColor,
                            elevation: 8,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                               padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                              child: Column(children: [
                                _showFromDate(),
                                _showToDate(),
                                DefaultButton(text: 'Buscar', press:  goGetCompraDates,) ,
                            
                              ],),
                            )
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

  Widget _showToDate() {
  return Padding(padding:  const EdgeInsets.only(left: 50.0, right: 50),
   child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [    
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(
                text: "Hasta: \n",
                style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),),
            TextSpan(
              text: "${toDate.year}/${toDate.month}/${toDate.day}\n".toUpperCase(),
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
              initialDate: toDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100)
                );
            if(newDate == null)   return;

            setState(() {
              toDate=newDate;
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

  Widget _showFromDate() {
  return Padding(padding:  const EdgeInsets.only(left: 50.0, right: 50),
   child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [    
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(
                text: "Desde: \n",
                style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),),
            TextSpan(
              text: "${fromDate.year}/${fromDate.month}/${fromDate.day}\n".toUpperCase(),
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
              initialDate: fromDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100)
                );
            if(newDate == null)   return;

            setState(() {
              fromDate=newDate;
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
  
  _showCompraResult() {
    return SafeArea(
    child:  SingleChildScrollView(
      child: Column(
        children: [
          compras.isNotEmpty  ?  _showInfo() : Container(),              
                 
        
        ],
      ) 
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
          hintText: 'Ingresa el Numero...',
          labelText: '# Factura',
          errorText: codigoShowError ? codigoError : null,
          suffixIcon: IconButton(iconSize: 40, onPressed:  goGetCompra, icon: const Icon(Icons.search_sharp, color: Color.fromARGB(255, 35, 145, 39),),)
         
        ),
    
      ),
    );
  }
  
  Future goGetCompra() async {
    if(codigoController.text.isEmpty){
      await Fluttertoast.showToast(
        msg: 'Digite el Numero de la Factura',
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
     compras.clear();
   
    Response response = await ApiHelper.getCompraByNum(codigoController.text);

    setState(() {
        showLoader=false;
    });
  
    if (!response.isSuccess) {
     showErrorFromDialog(response.message);
      return;
    }   
     
    setState(() {
      compras = response.result;
      swicht=false;     
    });   
  }

 Future goGetCompraDates() async {
  
   setState(() {
      showLoader = true;
    });
     compras.clear();
  
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String date1 = formatter.format(toDate);
    String date2 = formatter.format(fromDate);
    
    Map<String, dynamic> request = {
      'FromDate': date2,
      'ToDate': date1, 
    };   

    Response response = await ApiHelper.post(
     'api/Kilos/GetCompraByFecha/', 
      request,       
    );

    setState(() {
      showLoader = false;
    });

    if (!response.isSuccess) {
     showErrorFromDialog(response.message);
      return;
    }   
     
     var decodedJson = jsonDecode(response.result);     
       setState(() {
        if(decodedJson != null){
          for (var item in decodedJson){
            compras.add(Compra.fromJson(item));
          }
        }    
        swicht=false;  
      });
      

  }
  
  refrescar() {
     setState(() {
      swicht =true;
    });
  }

  Widget _showInfo() {     
  return Container(
      decoration:  const
      BoxDecoration(
        color: kContrastColorMedium,             
      ),
        child: Padding(
          padding:  const EdgeInsets.only( right: 10, top:10, bottom: 10),  
          child: 
            Column(
              children: [            
              
                ...List.generate(
                compras.length,
                  (index) {      
                      return CardCompra(compra: compras[index]);          
                  },
                ),
                SizedBox(width: getProportionateScreenWidth(20)),
              ],
              
            ),
          
        ),
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tex_app/Components/app_bar_home.dart';
import 'package:tex_app/Models/compra.dart';
import 'package:tex_app/Models/menu.dart';
import 'package:tex_app/Models/order.dart';
import 'package:tex_app/Models/user.dart';
import 'package:tex_app/Screens/Inventario_screen.dart';
import 'package:tex_app/Screens/add_compra_screen.dart';
import 'package:tex_app/Screens/add_newproduct_screen.dart';
import 'package:tex_app/Screens/add_roll_screen.dart';
import 'package:tex_app/Screens/consulta_producto_screen.dart';
import 'package:tex_app/Screens/login_screen.dart';
import 'package:tex_app/Screens/orden_entrada.dart';
import 'package:tex_app/Screens/order_new.dart';
import 'package:tex_app/Screens/order_screen.dart';
import 'package:tex_app/Screens/pedidos_screen.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user,});
  final User user;


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
List<Menu> menus = [];
   @override  
  void initState() {
    super.initState();
    _getMenus();
  }

  @override
  Widget build(BuildContext context) {   
   SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: kContrastColor,           
        appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppBar().preferredSize.height),
              child:  const AppBarHome(),                 
              ),            
        body: _getListView(),
         bottomNavigationBar: BottomAppBar(
        color: kColorHomeBar,
        shape: const CircularNotchedRectangle(),
        child: IconTheme(
         data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
         child: Container(
           decoration: const BoxDecoration(        
            gradient: kGradientAppBarHome,),
          height: 50,
           child: Center(
             child: Text(
                widget.user.fullName!, style:  GoogleFonts.oswald(fontStyle: FontStyle.normal, fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
           ),
         ),
        ),
       ), 
        ),
      );    
  }

   Widget _getListView() {
    return Container(  
       decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/AppBack.png"),
                fit: BoxFit.cover,
              ),),    
      padding: const EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 2,      
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: menus.map((e) {          
          return Card(              
            color: e.color,
              shadowColor: Colors.blueGrey,
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              onTap: () => _goMenu(e.nombre),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage(e.assetV), height: 100, width: 70,),
                    Text(
                      e.nombre.toString(), 
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
 
  void goLogin() {
      Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => const LoginScreen()
      )
    );
  }

  void goPedido() {
    Order orden = Order(documentUser:widget.user.document, detalles: [],);
     Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) =>  OrderScreen(orden: orden, codigo: '',)
      )
    );
  }
  
  _goMenu(String? nombre) {
       if(nombre=='Orden'){      
       Order order = Order(detalles: []);
        Navigator.of(context).pushReplacement(        
        MaterialPageRoute(
          builder: (context) => OrderNewScreen(orden: order, user: widget.user, isOld: true,)
        )
      );
      return;
    }

     if(nombre=='Agregar Compra'){      
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => AddCompraScreen(
            user: widget.user,
            compra: Compra(rolls: []),
              fechaFactura: DateTime.now(),
              fechaFacturaRecepcion: DateTime.now(),
          )
        )
      );
      return;
    }
     
     if(nombre=='Pedidos'){      
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => PedidosScreen(user: widget.user,)
        )
      );
      return;
    }
     if(nombre=='Entrada Almacen'){
       Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const OrdenEntradaScreen(status: 'EnBodega',)
        )
      );
      return;
    }
     if(nombre=='Crear Producto'){
       Navigator.push(
        context,       
        MaterialPageRoute(
          builder: (context) =>  AddNewProductScreen(user: widget.user,)
        )
      );
      return;
    }
    if(nombre=='Consultar Producto'){
       Navigator.push(
        context,       
        MaterialPageRoute(
          builder: (context) =>   ConsultaProductoScreen(user: widget.user,)
        )
      );
      return;
    }
    if(nombre=='Cerrar Sesion'){
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => const LoginScreen()
        )
      );
      return;
    }
     if(nombre=='Agregar Rollo'){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) =>   AddRollScreen(user: widget.user,)
        )
      );
      return;
    }
     if(nombre=='Nuevo Pedido'){
      Order order = Order(detalles: []);
      Navigator.of(context).pushReplacement(        
        MaterialPageRoute(
          builder: (context) => OrderNewScreen(orden: order, user: widget.user, isOld: false,)
        )
      );
     
    }
     if(nombre=='Inventario'){      
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => InventarioScreen(user: widget.user,)
        )
      );
      return;
    }
  }
  
  void _getMenus() {
    if(widget.user.isAdmin==true){
       Menu  menu= Menu(nombre: 'Crear Producto', assetV: 'assets/NewFondo.png', color: const Color.fromARGB(255, 182, 195, 230).withOpacity(0.7));
        menus.add(menu);
        menu= Menu(nombre: 'Agregar Rollo', assetV: 'assets/iconNuevo.png', color: const Color.fromARGB(255, 143, 161, 189).withOpacity(0.7));
        menus.add(menu);
          menu= Menu(nombre: 'Agregar Compra', assetV: 'assets/Factura.png', color: const Color.fromARGB(255, 143, 161, 189).withOpacity(0.7));
        menus.add(menu);
        menu= Menu(nombre: 'Entrada Almacen', assetV: 'assets/Almacen.png', color: const Color.fromARGB(248, 160, 195, 211).withOpacity(0.7));
        menus.add(menu); 
    }
 
      Menu menu= Menu(nombre: 'Nuevo Pedido', assetV: 'assets/Cart.png', color: const Color.fromARGB(255, 203, 209, 212).withOpacity(0.7));
      menus.add(menu);
     
      menu= Menu(nombre: 'Pedidos', assetV: 'assets/pedidos.png', color: Colors.white.withOpacity(0.7));
      menus.add(menu);

       menu= Menu(nombre: 'Orden', assetV: 'assets/Op.png', color: const Color.fromARGB(255, 203, 209, 212).withOpacity(0.7));
      menus.add(menu);
      
      menu = Menu(nombre: 'Consultar Producto', assetV: 'assets/iconNuevo.png', color: Colors.white.withOpacity(0.7));
      menus.add(menu);

      menu= Menu(nombre: 'Inventario', assetV: 'assets/rollos1.png', color: const Color.fromARGB(255, 143, 161, 189).withOpacity(0.7));
        menus.add(menu);

      menu= Menu(nombre: 'Cerrar Sesion', assetV: 'assets/Salir.png', color: const Color.fromARGB(255, 143, 161, 189).withOpacity(0.7));
      menus.add(menu);
     
  }
  
 
  
}
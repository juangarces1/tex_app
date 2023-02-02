import 'package:tex_app/Models/category.dart';
import 'package:tex_app/Models/descuento.dart';
import 'package:tex_app/Models/roll.dart';

class Product {
  int? id;
  String? descripcion;
  double? stock;  
  double? stockEnBodega;
  double? stockEnAlmacen;
  Category? category;
  String? color; 
  String? medida;
  List<Roll>? rolls;
  String? ultimaEntrada;
  double? totalEntradas;
  double? totalSalidas;
  double? precioPromedio;
  double? ultimoPrecio;
  String? ultimaVenta;
  String? promVenta;
  String? venta;
  List<Descuento>? movimientos;


  Product(
      {this.id,
      this.descripcion,
      this.stock,
      this.stockEnBodega,
      this.stockEnAlmacen,
      this.category,
      this.color,     
      this.medida,
      this.rolls,
      this.ultimaEntrada,
      this.totalEntradas,
      this.totalSalidas,
      this.ultimoPrecio,
      this.precioPromedio,
      this.ultimaVenta,
      this.promVenta,
      this.venta,
      this.movimientos,
      });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descripcion = json['descripcion'];   
    stock = json['stock'].toDouble();
    stockEnBodega = json['stockEnBodega'].toDouble();
    stockEnAlmacen = json['stockEnAlmacen'].toDouble();
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    color = json['color'];  
    medida = json['medida'];
    if (json['rolls'] != null) {
      rolls = <Roll>[];
      json['rolls'].forEach((v) {
        rolls!.add(Roll.fromJson(v));        
      });
    }
    ultimaEntrada = json['ultimaEntrada'];
    totalEntradas = json['totalEntradas'].toDouble();
    totalSalidas = json['totalSalidas'].toDouble();     
    ultimoPrecio = json['ultimoPrecio'].toDouble();
    precioPromedio = json['precioPromedio'].toDouble();
    ultimaVenta = json['ultimaVenta'];
    promVenta = json['promVenta'];
    venta = json['venta'];
    if (json['movimientos'] != null) {
      movimientos = <Descuento>[];
      json['movimientos'].forEach((v) {
        movimientos!.add(Descuento.fromJson(v));
      });
    }
   
   
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descripcion'] = descripcion;
    data['stock'] = stock;
    data['stockEnBodega'] = stockEnBodega;
    data['stockEnAlmacen'] = stockEnAlmacen;
    if (category != null) {
      data['category'] = category!.toJson();
    }
     data['color'] = color;
    data['medida'] = medida;
    if (rolls != null) {
      data['rolls'] = rolls!.map((v) => v.toJson()).toList();
    }
    data['ultimaEntrada'] = ultimaEntrada;
    data['totalEntradas'] = totalEntradas;
    data['totalSalidas'] = totalSalidas;
    data['ultimoPrecio'] = ultimoPrecio;
    data['precioPromedio'] = precioPromedio;
    data['ultimaVenta'] = ultimaVenta;
    data['promVenta'] = promVenta;
    data['venta'] = venta;
    if (movimientos != null) {
      data['movimientos'] = movimientos!.map((v) => v.toJson()).toList();
    }
   
   
   
    return data;
  }
}


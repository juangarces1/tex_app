import 'package:tex_app/Models/category.dart';
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
      this.promVenta
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
  
   
    return data;
  }
}


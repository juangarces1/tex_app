import 'package:tex_app/Models/roll.dart';

class InventDetail {
  int? id;
  String? categoria;
  String? producto;
  double? cantidad;
  double? precio;
  String? medida;
  String? color;

  InventDetail(
      {this.id,
      this.categoria,
      this.producto,
      this.cantidad,
      this.precio,
      this.medida,
      this.color});

  //Convert the json to a object
  factory InventDetail.fromJson(Map<String, dynamic> json) {
    return InventDetail(
      id: json['id'],
      categoria: json['categoria'],
      producto: json['producto'],
      cantidad: json['cantidad'],
      precio: json['precio'],
      medida: json['medida'],
      color: json['color'],
    );
  }

  //Convert the object Roll to a object InventDetail
  factory InventDetail.fromRoll(Roll roll) {
    return InventDetail(
      id: roll.id,
      categoria: roll.product!.category!.name,
      producto: roll.product!.descripcion,
      cantidad: roll.inventario,
      precio: roll.precio,
      medida: roll.medida,
      color: roll.product!.color!,
    );
  }

  //Convert the object to a json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoria': categoria,
      'producto': producto,
      'cantidad': cantidad,
      'precio': precio,
      'medida': medida,
      'color': color,
    };
    }
}
import 'package:tex_app/Models/descuento.dart';
import 'package:tex_app/Models/product.dart';

class Roll {
  int? id;
  double? cantidad;
  int? rolloPadre;
  double? precio;
  double? totalValue;
  String? medida;
  String? status;
  Product? product;
  List<Descuento>? descuentos;
  String? codigoBarras;
  double? inventario;
  int? movimienotos;

  Roll(
      {this.id,
      this.cantidad,
      this.rolloPadre,
      this.precio,
      this.totalValue,
      this.medida,
      this.status,
      this.product,
      this.descuentos,
      this.codigoBarras,
      this.inventario,
      this.movimienotos});

  Roll.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cantidad = json['cantidad'].toDouble();
    rolloPadre = json['rolloPadre'];
    precio = json['precio'].toDouble();
    totalValue = json['totalValue'].toDouble();
    medida = json['medida'];
    status = json['status'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    if (json['descuentos'] != null) {
      descuentos = <Descuento>[];
      json['descuentos'].forEach((v) {
        descuentos!.add(Descuento.fromJson(v));
      });
    }
    codigoBarras = json['codigoBarras'];
    inventario = json['inventario'];
    movimienotos = json['movimienotos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cantidad'] = cantidad;
    data['rolloPadre'] = rolloPadre;
    data['precio'] = precio;
    data['totalValue'] = totalValue;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (descuentos != null) {
      data['descuentos'] = descuentos!.map((v) => v.toJson()).toList();
    }
    data['codigoBarras'] = codigoBarras;
    data['inventario'] = inventario;
    data['movimienotos'] = movimienotos;
    return data;
  }
}

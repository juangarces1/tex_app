class Detalle {
  int? codigoRollo;
  double? price;
  double? cantidad;
  double? total;
  String? producto;
  String? color;
  int? codigoProducto;


  Detalle({this.codigoRollo, this.price, this.cantidad, this.total, this.producto, this.color, this.codigoProducto});

  Detalle.fromJson(Map<String, dynamic> json) {
    codigoRollo = json['codigoRollo'];
    price = json['precio'].toDouble();
    cantidad = json['cant'].toDouble();
    total=json['valor'].toDouble();
    producto = json['producto'];
    color = json['color'];
    codigoProducto = json['codigoProducto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codigoProducto'] = codigoProducto;
    data['codigoRollo'] = codigoRollo;
    data['price'] = price;
    data['cantidad'] = cantidad;
    return data;
  }
}
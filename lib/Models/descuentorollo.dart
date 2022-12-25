class DescuentoRollo {
  int? id;
  String? date;
  int? tipo;
  double? descuento;

  DescuentoRollo({this.id, this.date, this.tipo, this.descuento});

  DescuentoRollo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    tipo = json['tipo'];
    descuento = json['descuento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['tipo'] = tipo;
    data['descuento'] = descuento;
    return data;
  }
}
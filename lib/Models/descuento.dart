import 'package:tex_app/Models/user.dart';

class Descuento {
  int? id;
  String? date;
  int? tipo;
  double? descuento;
  User? employee;

  Descuento({this.id, this.date, this.tipo, this.descuento});

  Descuento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    tipo = json['tipo'];
    descuento = json['descuento'];
    employee = json['employee'] != null
        ? User.fromJson(json['employee'])
        : null
    ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['tipo'] = tipo;
    data['descuento'] = descuento;
    if (employee != null) {
      data['employee'] = employee!.toJson();
    }
    return data;
  }
}


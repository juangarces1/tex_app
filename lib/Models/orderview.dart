import 'package:tex_app/Models/detalle.dart';

class OrderView {
  int? id;
  List<Detalle>? detalles;
  int? productos;
  String? hora;
  double? total;
  String? estado;

  OrderView({this.id, this.detalles, this.productos, this.hora, this.total, this.estado});

  OrderView.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['detalles'] != null) {
      detalles = <Detalle>[];
      json['detalles'].forEach((v) {
        detalles!.add(Detalle.fromJson(v));
      });
    }
    productos = json['productos'];
    hora = json['hora'];
    total=json['total'].toDouble();
     estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (detalles != null) {
      data['detalles'] = detalles!.map((v) => v.toJson()).toList();
    }
    data['productos'] = productos;
    data['hora'] = hora;
      data['estado'] = estado;
    return data;
  }
}
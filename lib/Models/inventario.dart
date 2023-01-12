
import 'package:tex_app/Models/inventarioview.dart';

class Inventario {
  int? id;
  List<InventarioView> detalle=[];
  String? total;
  String? rollos;
  String? kilos;
  String? metros;
  String? fecha;
  

  Inventario({this.id, required this.detalle,  this.total, this.rollos, this.kilos, this.metros, this.fecha});

  Inventario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['detalle'] != null) {
      detalle = <InventarioView>[];
      json['detalle'].forEach((v) {
        detalle.add(InventarioView.fromJson(v));        
      });
    }
     total = json['total'];
     rollos = json['rollos'];
     kilos = json['kilos'];
     metros = json['metros'];
      fecha = json['fecha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (detalle.isNotEmpty) {
      data['detalle'] = detalle.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['rollos'] = rollos;
    data['kilos'] = kilos;
    data['metros'] = metros;
    data['fecha'] = fecha;
    return data;
  }
}


import 'package:tex_app/Models/inventarioview.dart';

class Inventario {
 
   List<InventarioView> detalle=[];
   String? total;
   String? rollos;
   String? kilos;
   String? metros;

  Inventario({required this.detalle,  this.total, this.rollos, this.kilos, this.metros});

  Inventario.fromJson(Map<String, dynamic> json) {
   
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
   
    return data;
  }
}
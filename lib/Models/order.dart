import 'package:tex_app/Models/detalle.dart';

class Order {
  String? documentUser;
  List<Detalle> detalles=[];
  int? id; 
  Order({this.documentUser, required this.detalles, this.id});

  Order.fromJson(Map<String, dynamic> json) {
    documentUser = json['documentUser'];
    if (json['detalles'] != null) {
      detalles = <Detalle>[];
      json['detalles'].forEach((v) {
        detalles.add(Detalle.fromJson(v));

        
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['documentUser'] = documentUser;
    data['detalles'] = detalles.map((v) => v.toJson()).toList();
      data['id'] = id;
    return data;
  }
}
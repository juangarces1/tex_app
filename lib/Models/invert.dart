
import 'invent_detail.dart';

class Invent{
  int? id;
  double? total;
  int? rollos;
  double? metros;
  double? kilos;
  String? fecha;
  List<InventDetail>? items;

  Invent({this.id, this.total, this.rollos, this.metros, this.kilos, this.fecha, this.items});

  //Convert the json to a object
  factory Invent.fromJson(Map<String, dynamic> json) {
    return Invent(
      id: json['id'],
      total: json['total'].toDouble(),
      rollos: json['rollos'],
      metros: json['metros'].toDouble(),
      kilos: json['kilos'].toDouble(),
      fecha: json['fecha'],
      items: json['items'] != null ? (json['inventDetails'] as List).map((i) => InventDetail.fromJson(i)).toList() : null,
    );
  }

  

  //Convert the object to a json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total': total,
      'rollos': rollos,
      'metros': metros,
      'kilos': kilos,
      'fecha': fecha,
      'inventDetails': items,
    };
  }

}

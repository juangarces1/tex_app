
import 'package:tex_app/Models/roll.dart';

class ChageStateRoll {
  String? estado;
  List<Roll> rollos=[];

  ChageStateRoll({this.estado, required this.rollos});

  ChageStateRoll.fromJson(Map<String, dynamic> json) {
    estado = json['estado'];
    if (json['detalles'] != null) {
      rollos = <Roll>[];
      json['detalles'].forEach((v) {
        rollos.add(Roll.fromJson(v));

        
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['estado'] = estado;
    data['rollos'] = rollos.map((v) => v.toJson()).toList();
    return data;
  }
}
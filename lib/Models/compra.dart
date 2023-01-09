import 'package:tex_app/Models/roll.dart';
import 'package:tex_app/Models/supplier.dart';

class Compra {
   int? id;
   String? facturaNumero;
   String? fechafactura;
   String? fechafacturarecepcion;
   String? fechavencimiento;
   double? subtotal;
   double? iva;
   double? total;
   int? compraStatus;
   bool? subir;
   Supplier? supplier;
   List<Roll>? rolls;
   
  Compra({
    this.id, 
    this.facturaNumero,
    this.fechafactura,
    this.fechafacturarecepcion, 
    this.fechavencimiento,
    this.subtotal,
    this.iva, 
    this.total,
    this.compraStatus,
    this.subir,
    this.supplier,
    this.rolls,  
  });

  Compra.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    facturaNumero = json['facturaNumero'];
    fechafactura = json['fechaFactura'];
    fechafacturarecepcion = json['fecharecepcion'];
    fechavencimiento = json['fechaVencimiento'];
    subtotal = json['subtotal'];
    iva = json['iva'];
    total = json['total'];
    compraStatus = json['compraStatus'];
    subir = json['subir'];    
    supplier = json['supplier'] != null
      ? Supplier.fromJson(json['supplier'])
      : null;
    if (json['rolls'] != null) {
      rolls = <Roll>[];
      json['rolls'].forEach((v) {
        rolls?.add(Roll.fromJson(v));        
     });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['facturaNumero'] = facturaNumero;
    data['fechafactura'] = fechafactura;
    data['fechafacturarecepcion'] = fechafacturarecepcion;
    data['fechavencimiento'] = fechavencimiento;
    data['subtotal'] = subtotal;
    data['iva'] = iva;
    data['total'] = total;
    data['compraStatus'] = compraStatus;
    data['subir'] = subir;
    if(supplier != null){
      data['supplier'] = supplier?.toJson(); 
    }   
    data['rolls'] = rolls?.map((v) => v.toJson()).toList();   
    return data;
  }
}
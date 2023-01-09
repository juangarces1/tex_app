import 'package:tex_app/Models/product.dart';

class InventReview {
   List<Product> products =[];
   double? total;
   double? rollos;
   double? kilos;
   double? metros;


  InventReview({required this.products,  this.total, this.rollos, this.kilos, this.metros});


  InventReview.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Product>[];
      json['detalle'].forEach((v) {
        products.add(Product.fromJson(v));        
      });
    }
    
     total = json['total'].todouble();
     rollos = json['rollos'].todouble();
     kilos = json['kilos'].todouble();
     metros = json['metros'].todouble();
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};  
     data['total'] = total;
     data['rollos'] = rollos;
     data['kilos'] = kilos;
     data['metros'] = metros;
     data['products'] = products.map((v) => v.toJson()).toList();
    return data;
  }
}
import 'package:tex_app/Models/product.dart';

class ProductList {
  String? document;
  List<Product> productos=[];

  ProductList({this.document, required this.productos});

  ProductList.fromJson(Map<String, dynamic> json) {
    document = json['documentUser'];
    if (json['detalles'] != null) {
      productos = <Product>[];
      json['detalles'].forEach((v) {
        productos.add(Product.fromJson(v));

        
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document'] = document;
    data['products'] = productos.map((v) => v.toJson()).toList();
    return data;
  }
}
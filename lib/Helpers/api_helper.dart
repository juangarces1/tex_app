import 'dart:convert';

import 'package:tex_app/Helpers/constans.dart';
import 'package:tex_app/Models/category.dart';
import 'package:tex_app/Models/color.dart';
import 'package:tex_app/Models/compra.dart';
import 'package:tex_app/Models/inventario.dart';
import 'package:tex_app/Models/orderview.dart';
import 'package:tex_app/Models/product.dart';
import 'package:tex_app/Models/response.dart';
import 'package:http/http.dart' as http;
import 'package:tex_app/Models/roll.dart';
import 'package:tex_app/Models/supplier.dart';
import 'package:tex_app/Models/user.dart';

class ApiHelper{
  static Future<Response> getCierreActivo(int? password) async {  

    var url = Uri.parse('${Constans.apiUrl}/api/Orders/LogIn/$password');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );

    var body = response.body;
   
    if (response.statusCode >= 400) {
        body="Contraseña Incorrecta";
       return Response(isSuccess: false, message: body);
    }

   
    var decodedJson = jsonDecode(body);
   

    return Response(isSuccess: true, result: User.fromJson(decodedJson));
 }

  static Future<Response> getInventario() async {  

    var url = Uri.parse('${Constans.apiUrl}/api/Kilos/GetInventario/');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );

    var body = response.body;
   
    if (response.statusCode >= 400) {
        body="Contraseña Incorrecta";
       return Response(isSuccess: false, message: body);
    }

   
    var decodedJson = jsonDecode(body);
   

    return Response(isSuccess: true, result: Inventario.fromJson(decodedJson));
 }

  static Future<Response> getOrdersByUser(String document) async {  

    var url = Uri.parse('${Constans.apiUrl}/api/Kilos/GetOrdersByUser/$document');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    

    var body = response.body;
   
    if (response.statusCode >= 400) {
        
       return Response(isSuccess: false, message: response.body);
    }

    List<OrderView> pedidos = [];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        pedidos.add(OrderView.fromJson(item));
      }
    }

    return Response(isSuccess: true, result: pedidos);
 }

  static Future<Response> getCompraByNum(String nume) async {  

    var url = Uri.parse('${Constans.apiUrl}/api/Kilos/GetCompraByNum/$nume');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    

    var body = response.body;
   
    if (response.statusCode >= 400) {
        body="No se encontro la Compra";
       return Response(isSuccess: false, message: body);
    }

    List<Compra> compras = [];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        compras.add(Compra.fromJson(item));
      }
    }

    return Response(isSuccess: true, result: compras);
 }
 
  static Future<Response> getCategoies() async {  
    var url = Uri.parse('${Constans.apiUrl}/api/kilos/GetCategories/');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;   
    if (response.statusCode >= 400) {
        body="Error";
       return Response(isSuccess: false, message: body);    }   
    var decodedJson = jsonDecode(body);   
    List<Category> categories = [];    
      if(decodedJson != null){
        for (var item in decodedJson){
          categories.add(Category.fromJson(item));
        }
      }
    return Response(isSuccess: true, result: categories);
 }
  static Future<Response> getSuppliers() async {  
    var url = Uri.parse('${Constans.apiUrl}/api/kilos/GetSuppliers/');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;   
    if (response.statusCode >= 400) {
        body="Error";
       return Response(isSuccess: false, message: body);    }   
    var decodedJson = jsonDecode(body);   
    List<Supplier> suppliers = [];    
      if(decodedJson != null){
        for (var item in decodedJson){
          suppliers.add(Supplier.fromJson(item));
        }
      }
    return Response(isSuccess: true, result: suppliers);
 }

  static Future<Response> getProducts() async {  

    var url = Uri.parse('${Constans.apiUrl}/api/Kilos/GetProducts/');
     var response = await http.post(
      
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',       
      },     
    );    

    var body = response.body;
   
    if (response.statusCode >= 400) {
        body="Error";
       return Response(isSuccess: false, message: body);
    }

   
    var decodedJson = jsonDecode(body);
   
    List<Product> products = [];
    
      if(decodedJson != null){
        for (var item in decodedJson){
          products.add(Product.fromJson(item));
        }
      }

    return Response(isSuccess: true, result: products);
 }
  
   static Future<Response> getProductsBySuplier(int id) async {  

    var url = Uri.parse('${Constans.apiUrl}/api/Orders/GetProductsBySuplier/$id');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );

    var body = response.body;
   
    if (response.statusCode >= 400) {
        body="Error";
       return Response(isSuccess: false, message: body);
    }

   
    var decodedJson = jsonDecode(body);
   
    List<Product> products = [];
    
      if(decodedJson != null){
        for (var item in decodedJson){
          products.add(Product.fromJson(item));
        }
      }

    return Response(isSuccess: true, result: products);
 }

   static Future<Response> getProductColors(Map<String, dynamic> request) async {  

    var url = Uri.parse('${Constans.apiUrl}/api/Kilos/GetProductsByProduct/');
    var response = await http.post(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },   
      body:  jsonEncode(request)
    );

    var body = response.body;
   
    if (response.statusCode >= 400) {
        body="Error";
       return Response(isSuccess: false, message: body);
    }

   
    var decodedJson = jsonDecode(body);
   
    List<Product> products = [];
    
      if(decodedJson != null){
        for (var item in decodedJson){
          products.add(Product.fromJson(item));
        }
      }

    return Response(isSuccess: true, result: products);
 }

  static Future<Response> getColors() async {  

    var url = Uri.parse('${Constans.apiUrl}/api/Kilos/GetColors/');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );

    var body = response.body;
   
    if (response.statusCode >= 400) {
        body="Error";
       return Response(isSuccess: false, message: body);
    }

   
    var decodedJson = jsonDecode(body);
   
    List<MyColor> colors = [];
    
      if(decodedJson != null){
        for (var item in decodedJson){
          colors.add(MyColor.fromJson(item));
        }
      }

    return Response(isSuccess: true, result: colors);
 }

  static Future<Response> getRoll(int codigo) async {  

    var url = Uri.parse('${Constans.apiUrl}/api/Kilos/GetRoll/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );

    var body = response.body;
   
    if (response.statusCode >= 400) {
        body="Error";
       return Response(isSuccess: false, message: body);
    }

   
    var decodedJson = jsonDecode(body);
   

    return Response(isSuccess: true, result: Roll.fromJson(decodedJson));
 }

 static Future<Response> getPRoductById(int codigo) async {  

    var url = Uri.parse('${Constans.apiUrl}/api/Kilos/GetProductById/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );

    var body = response.body;
   
    if (response.statusCode >= 400) {
        body="Error";
       return Response(isSuccess: false, message: body);
    }

   
    var decodedJson = jsonDecode(body);
   

    return Response(isSuccess: true, result: Product.fromJson(decodedJson));
 }

  static Future<Response> getProductByRoll(int codigo) async {  

    var url = Uri.parse('${Constans.apiUrl}/api/Kilos/GetProductByRoll/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );

    var body = response.body;
   
    if (response.statusCode >= 400) {
        body="Error";
       return Response(isSuccess: false, message: body);
    }

   
    var decodedJson = jsonDecode(body);
   

    return Response(isSuccess: true, result: Product.fromJson(decodedJson));
 }

  static Future<Response> post(String controller, Map<String, dynamic>   request) async {        
    var url = Uri.parse('${Constans.apiUrl}/$controller');
    var response = await http.post(
      
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',       
      },
      body: jsonEncode(request)
    );    

    if(response.statusCode >= 400){    
      return Response(isSuccess: false, message: response.body);
    }     
     return Response(isSuccess: true, result: response.body);
  }
  
  static Future<Response> delete(String controller, String id) async { 
    
    var url = Uri.parse('${Constans.apiUrl}$controller$id');
    var response = await http.delete(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',       
      },
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }  

}
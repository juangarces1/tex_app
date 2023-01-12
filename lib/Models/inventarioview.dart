class InventarioView {
  String? categoria; 
  String? producto;  
  String? color;   
  String? medida; 
  String? inventario;
  String? invAlmacen;
  String? invBodega;
  int? totalRollos;
  String? valor;

  InventarioView(
     {
      this.categoria,
      this.producto,
      this.color,
      this.medida,
      this.inventario,
      this.invAlmacen,
      this.invBodega,     
      this.totalRollos,
      this.valor,
      
      });

  InventarioView.fromJson(Map<String, dynamic> json) {
    categoria = json['categoria'];
    producto = json['producto'];
    color = json['color'];
    medida = json['medida'];
    inventario = json['inventario'];   
    invAlmacen = json['invAlmacen'];  
    invBodega = json['invBodega'];   
    totalRollos = json['totalRollos'];
    valor = json['valor'];  
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoria'] = categoria;
    data['producto'] = producto;
    data['color'] = color;
    data['medida'] = medida;
    data['inventario'] = inventario;
    data['invAlmacen'] = invAlmacen;
    data['invBodega'] = invBodega;
    data['totalRollos'] = totalRollos;
    data['valor'] = valor;
    
    return data;
  }
}
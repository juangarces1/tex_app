class Supplier {
  int? supplierId;
  String? name;
  String? lastName;
  String? contactFirstName;
  String? address;
  String? phone;
  String? email;
  int? diasPlazo;

  Supplier(
      {this.supplierId,
      this.name,
      this.lastName,
      this.contactFirstName,
      this.address,
      this.phone,
      this.email,
      this.diasPlazo});

  Supplier.fromJson(Map<String, dynamic> json) {
    supplierId = json['supplierId'];
    name = json['name'];
    lastName = json['lastName'];
     contactFirstName = json['contactFirstName'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    diasPlazo = json['diasPlazo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supplierId'] = supplierId;
    data['name'] = name;
    data['lastname'] = lastName;  
    data['contactFirstName'] = contactFirstName;   
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    data['diasPlazo'] = diasPlazo;
    return data;
  }
}
class User {
  int? id;
  String? document;
  String? firstName;
  String? lastName;
  String? address;
  String? fullName;
  bool? isAdmin;

  User(
      {this.id,
      this.document,
      this.firstName,
      this.lastName,
      this.address,
      this.fullName,
      this.isAdmin});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    document = json['document'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    address = json['address'];
    fullName = json['fullName'];
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['document'] = document;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['address'] = address;
    data['fullName'] = fullName;
    data['isAdmin'] = isAdmin;
    return data;
  }
}
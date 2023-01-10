 class Item {
    final int? id;
    final String? name;
    final String? description;
    final double? price;
    final int? quantity;
    final double? total;

    Item({
      this.id,
      this.name,
      this.description,
      this.price,
      this.quantity,
      this.total,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
          id: json["id"],
          name: json["name"],
          description: json["description"],
          price: json["price"],
          quantity: json["quantity"],
          total: json["total"],
        );

    Map<String, dynamic> toJson() => {
          "id": id,
          "name": name,
          "description": description,
          "price": price,
          "quantity": quantity,
          "total": total,
        };

    Map<String, dynamic> toMap() => {
          "id": id,
          "name": name,
          "description": description,
          "price": price,
          "quantity": quantity,
          "total": total,
        };
  }
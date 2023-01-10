// Make a class for the model of invoice
import 'package:tex_app/Models/item.dart';

class Invoice {
  // Make a constructor for the model class
   int? id;
   String? invoiceNumber;
   String? invoiceDate;
   String? dueDate;
   String? customerName;
   String? customerAddress;
   String? customerEmail;
   String? customerPhone;
   double? subTotal;
   double? discount;
   double? tax;
   double? total;
  List<Item> items = [];

  Invoice({
    this.id,
    this.invoiceNumber,
    this.invoiceDate,
    this.dueDate,
    this.customerName,
    this.customerAddress,
    this.customerEmail,
    this.customerPhone,
    this.subTotal,
    this.discount,
    this.tax,
    this.total,
    required this.items,
  });

  // Make a factory method for the model
  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json["id"],
        invoiceNumber: json["invoice_number"],
        invoiceDate: json["invoice_date"],
        dueDate: json["due_date"],
        customerName: json["customer_name"],
        customerAddress: json["customer_address"],
        customerEmail: json["customer_email"],
        customerPhone: json["customer_phone"],
        subTotal: json["sub_total"],
        discount: json["discount"],
        tax: json["tax"],
        total: json["total"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  // Make a method to convert the model to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_number": invoiceNumber,
        "invoice_date": invoiceDate,
        "due_date": dueDate,
        "customer_name": customerName,
        "customer_address": customerAddress,
        "customer_email": customerEmail,
        "customer_phone": customerPhone,
        "sub_total": subTotal,
        "discount": discount,
        "tax": tax,
        "total": total,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };

  // Make a method to convert the model to map
  Map<String, dynamic> toMap() => {
        "id": id,
        "invoice_number": invoiceNumber,
        "invoice_date": invoiceDate,
        "due_date": dueDate,
        "customer_name": customerName,
        "customer_address": customerAddress,
        "customer_email": customerEmail,
        "customer_phone": customerPhone,
        "sub_total": subTotal,
        "discount": discount,
        "tax": tax,
        "total": total,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
      };
}

  //Make a class for invoice Item
 
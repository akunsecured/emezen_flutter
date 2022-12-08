import 'package:emezen/model/enums.dart';

class Product {
  final String? id;
  final String name;
  final String sellerId;
  final double price;
  final List images;
  String details;
  final int quantity;
  final ProductCategories category;

  Product({
    this.id,
    required this.name,
    required this.sellerId,
    required this.price,
    this.images = const [],
    required this.details,
    required this.quantity,
    required this.category
  });

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'seller_id': sellerId,
    'price': price,
    'images': images,
    'details': details,
    'quantity': quantity,
    'category': category.index
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json['_id'],
      name: json['name'],
      sellerId: json['seller_id'],
      price: json['price'],
      images: json['images'],
      details: json['details'],
      quantity: json['quantity'],
      category: ProductCategories.values[json['category']]);

  @override
  String toString() => toJson().toString();
}
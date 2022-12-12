class ProductObserver {
  String? id;
  final List productList;
  final String userId;

  ProductObserver(this.userId, [this.productList = const [], this.id]);

  factory ProductObserver.fromJson(Map<String, dynamic> json) =>
      ProductObserver(
        json['user_id'],
        json['product_list'],
        json['_id'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'product_list': productList,
        '_id': id,
      };
}

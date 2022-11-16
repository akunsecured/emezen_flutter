import 'package:emezen/model/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Image imageWidget;
    if (product.images.isEmpty) {
      imageWidget = const Image(
        image: AssetImage('assets/images/product-image-placeholder.jpg'),
        width: 128,
      );
    } else {
      imageWidget = Image.network(
        product.images.first,
        width: 128,
        height: 128,
        fit: BoxFit.cover,
        errorBuilder: (context, exception, stackTrace) => const Image(
          image: AssetImage('assets/images/product-image-placeholder.jpg'),
          width: 128,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(12),
      width: 200,
      child: Card(
        child: InkWell(
          onTap: () {
            // TODO: implement navigation to ProductPage
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              imageWidget,
              Text(product.name),
              Text("Price: ${product.price}"),
              Text("Quantity: ${product.quantity}"),
              Text("Details: ${product.details}")
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:emezen/model/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(Product) onTap;

  const ProductCard({Key? key, required this.product, required this.onTap})
      : super(key: key);

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
          onTap: () async => onTap(product),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              imageWidget,
              Text(
                product.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text("Price: \$${product.price}"),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:emezen/model/product.dart';
import 'package:emezen/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCartElement extends StatelessWidget {
  final Product product;

  const ShoppingCartElement({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Image imageWidget;
    if (product.images.isEmpty) {
      imageWidget = const Image(
        image: AssetImage('assets/images/product-image-placeholder.jpg'),
        width: 64,
      );
    } else {
      imageWidget = Image.network(
        product.images.first,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (context, exception, stackTrace) => const Image(
          image: AssetImage('assets/images/product-image-placeholder.jpg'),
          width: 64,
        ),
      );
    }

    return Container(
        width: 400,
        margin: const EdgeInsets.all(24.0),
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) => Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  imageWidget,
                  Container(
                      margin: const EdgeInsets.only(left: 8.0),
                      child: Text(product.name))
                ],
              ),
              Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: cartProvider.cart[product]! > 1
                              ? () {
                                  cartProvider.reduceQuantity(product);
                                }
                              : null,
                          icon: const Icon(Icons.remove)),
                      Text(cartProvider.cart[product].toString()),
                      IconButton(
                          onPressed: cartProvider.cart[product]! < 100
                              ? () {
                                  cartProvider.increaseQuantity(product);
                                }
                              : null,
                          icon: const Icon(Icons.add)),
                    ],
                  ),
                  Text(
                    '\$${(product.price * cartProvider.cart[product]!).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  IconButton(
                      onPressed: () => cartProvider.removeFromCart(product),
                      icon: const Icon(Icons.delete))
                ],
              )
            ],
          ),
        ));
  }
}

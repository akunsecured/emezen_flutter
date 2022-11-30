import 'package:emezen/model/enums.dart';
import 'package:emezen/model/product.dart';
import 'package:emezen/pages/product_page.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/cart_provider.dart';
import 'package:emezen/provider/product_page_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  void _navigateToProductPage(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: authProvider),
                ChangeNotifierProvider.value(value: productProvider),
                ChangeNotifierProvider.value(value: cartProvider),
                ChangeNotifierProvider(
                    create: (_) => ProductPageProvider(product)),
              ],
              child: const ProductPage(),
            )));
    /*
    Provider.of<MainPageProvider>(context, listen: false)
        .changePage(MainPages.product, args: {'product': product});*/
  }

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
          onTap: () => _navigateToProductPage(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              imageWidget,
              Text(
                product.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text("Price: \$${product.price}"),
            ],
          ),
        ),
      ),
    );
  }
}

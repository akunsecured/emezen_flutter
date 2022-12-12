import 'package:emezen/model/product.dart';
import 'package:emezen/pages/product_page.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/cart_provider.dart';
import 'package:emezen/provider/product_page_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductObserverWidget extends StatefulWidget {
  final List<Product> products;

  const ProductObserverWidget(this.products, {Key? key}) : super(key: key);

  @override
  State<ProductObserverWidget> createState() => _ProductObserverWidgetState();
}

class _ProductObserverWidgetState extends State<ProductObserverWidget> {
  late final List<Product> _products;

  @override
  void initState() {
    super.initState();

    _products = widget.products;
  }

  void _navigateToProductPage(Product product) {
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
  }

  void _onProductTap(Product product) {
    Provider.of<ProductProvider>(context, listen: false)
        .addOrRemoveProductToObserver(product.id!);
    Navigator.of(context).pop(true);
    _navigateToProductPage(product);
  }

  Future<void> _showProductsDialog() async {
    var result = await showDialog(
        context: context,
        builder: (_) => MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                    value: Provider.of<AuthProvider>(context, listen: false)),
                ChangeNotifierProvider.value(
                    value:
                        Provider.of<ProductProvider>(context, listen: false)),
                ChangeNotifierProvider.value(
                    value: Provider.of<CartProvider>(context, listen: false)),
              ],
              child: Dialog(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 380,
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.all(12.0),
                      child: Column(children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Text(
                              'Filled products',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        ..._products
                            .map(
                              (product) => ListTile(
                                onTap: () => _onProductTap(product),
                                title: Text(product.name),
                              ),
                            )
                            .toList(),
                      ]),
                    ),
                  ),
                ),
              ),
            ));

    if (result != null) {
      Provider.of<ProductProvider>(context, listen: false).loadData();
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        constraints: const BoxConstraints(
          maxWidth: 200,
          maxHeight: 48,
        ),
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          onTap: _showProductsDialog,
          child: Card(
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Center(
              child: Text('${_products.length} new products are filled!'),
            ),
          ),
        ),
      );
}

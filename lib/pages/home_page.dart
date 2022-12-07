import 'package:emezen/model/product.dart';
import 'package:emezen/pages/product_page.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/cart_provider.dart';
import 'package:emezen/provider/product_page_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/widgets/product_card.dart';
import 'package:emezen/widgets/search_bar.dart';
import 'package:emezen/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<void> _future;

  @override
  void initState() {
    super.initState();

    _future = _getAllProducts();
  }

  Future<void> _getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 750));
    await Provider.of<ProductProvider>(context, listen: false).getAllProducts();
  }

  Future<void> _navigateToProductPage(Product product) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    var result = await Navigator.of(context).push(MaterialPageRoute(
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
    if (result != null) await _getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
          constraints: const BoxConstraints(maxWidth: 640),
          margin: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 64.0),
          child: ChangeNotifierProvider.value(
              value: Provider.of<ProductProvider>(context, listen: false),
              child: const SearchWidget())),
      Consumer<CartProvider>(
        builder: (context, cartProvider, child) => FutureBuilder(
            future: _future,
            builder: (context, AsyncSnapshot<void> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return Selector<ProductProvider, bool>(
                  selector: (_, productProvider) => productProvider.isLoading,
                  builder: (_, bool isLoading, __) => isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Selector<ProductProvider, List<Product>>(
                          selector: (_, productProvider) =>
                              productProvider.products,
                          builder: (_, List<Product> products, __) => products
                                  .isEmpty
                              ? const Center(
                                  child:
                                      Text('Currently there are no products'),
                                )
                              : ResponsiveGridRow(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: products
                                      .map((product) => ResponsiveGridCol(
                                            xs: 6,
                                            sm: 4,
                                            md: 3,
                                            child: ProductCard(
                                              product: product,
                                              onTap: _navigateToProductPage,
                                            ),
                                          ))
                                      .toList(),
                                ),
                        ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
      )
    ]));
  }
}

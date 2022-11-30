import 'package:emezen/model/product.dart';
import 'package:emezen/provider/cart_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/widgets/product_card.dart';
import 'package:emezen/widgets/search_bar.dart';
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
  late final Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();

    _future =
        Provider.of<ProductProvider>(context, listen: false).getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) => FutureBuilder(
          future: _future,
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Currently there are no products'));
                }
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 128.0, horizontal: 64.0),
                            child: const SearchBar()),
                        ResponsiveGridRow(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: snapshot.data!
                              .map((product) => ResponsiveGridCol(
                                    xs: 6,
                                    sm: 4,
                                    md: 3,
                                    child: ProductCard(
                                      product: product,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: Text('Null'));
              }
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

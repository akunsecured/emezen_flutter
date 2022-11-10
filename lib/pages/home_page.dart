import 'package:emezen/model/product.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _productProvider.getAllProducts(),
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
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!
                    .map((product) => ProductCard(product: product))
                    .toList(),
              );
            } else {
              return const Center(child: Text('Null'));
            }
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}

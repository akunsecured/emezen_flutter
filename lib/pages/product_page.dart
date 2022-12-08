import 'package:emezen/model/enums.dart';
import 'package:emezen/model/product.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/cart_provider.dart';
import 'package:emezen/provider/product_page_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:emezen/util/constants.dart';
import 'package:emezen/widgets/app_image_widget.dart';
import 'package:emezen/widgets/delete_dialog.dart';
import 'package:emezen/widgets/product_details_styled_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Product _product;
  late Future<User?> _future;

  @override
  void initState() {
    super.initState();

    _product = Provider.of<ProductPageProvider>(context, listen: false).product;
    _future = Provider.of<AuthProvider>(context, listen: false)
        .getUser(_product.sellerId);
  }

  Widget _buildImageWidget() => Consumer<ProductPageProvider>(
          builder: (context, productPageProvider, child) {
        Widget imageWidget = AppImageWidget(
          predicate: _product.images.isNotEmpty,
          size: 256,
          url: productPageProvider
              .images[productPageProvider.selectedImageIndex],
        );

        Widget previewWidget = Selector<ProductPageProvider, int>(
          selector: (_, productPageProvider) =>
              productPageProvider.selectedImageIndex,
          builder: (_, int selectedImageIndex, __) => Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: productPageProvider.images
                .map((image) => Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                          border: Border.all(
                              color: image ==
                                      productPageProvider
                                          .images[selectedImageIndex]
                                  ? AppTheme.primarySwatch
                                  : Colors.transparent)),
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                          child: InkWell(
                            onTap: () =>
                                productPageProvider.setSelectedImageIndex(
                                    productPageProvider.images.indexOf(image)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0)),
                            child: AppImageWidget(
                              url: image,
                              size: 64,
                            ),
                          )),
                    ))
                .toList(),
          ),
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 24.0),
                child: imageWidget),
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: previewWidget),
          ],
        );
      });

  Widget _desktopBody(User seller) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildImageWidget()),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 256 + 64 + 32),
              margin: const EdgeInsets.only(
                top: 24.0,
              ),
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  bottomLeft: Radius.circular(24.0),
                ),
                color: Colors.black12,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Seller:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${seller.firstName} ${seller.lastName}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${_product.price}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Quantity: ${_product.quantity}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    ProductDetailsStyledText(_product.details),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 24.0),
                      child: Provider.of<AuthProvider>(context, listen: false)
                                  .currentUser!
                                  .id !=
                              seller.id
                          ? (_product.quantity > 0
                              ? Consumer<CartProvider>(
                                  builder: (context, cartProvider, child) =>
                                      ElevatedButton(
                                          onPressed: cartProvider.cart
                                                  .containsKey(_product)
                                              ? null
                                              : () => cartProvider
                                                  .addToCart(_product),
                                          child: const Text("Add to cart")),
                                )
                              : const ElevatedButton(
                                  onPressed: null, child: Text("Out of stock")))
                          : const SizedBox(),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      );

  Widget _mobileBody(User seller) => SingleChildScrollView(
        child: Column(
          children: [
            _buildImageWidget(),
            Container(
              margin: const EdgeInsets.only(top: 24.0),
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                color: Colors.black12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Seller:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${seller.firstName} ${seller.lastName}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${_product.price}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Quantity: ${_product.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  ProductDetailsStyledText(_product.details),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 24.0),
                    child: Provider.of<AuthProvider>(context, listen: false)
                                .currentUser!
                                .id !=
                            seller.id
                        ? (_product.quantity > 0
                            ? Consumer<CartProvider>(
                                builder: (context, cartProvider, child) =>
                                    ElevatedButton(
                                        onPressed: cartProvider.cart
                                                .containsKey(_product)
                                            ? null
                                            : () => cartProvider
                                                .addToCart(_product),
                                        child: const Text("Add to cart")),
                              )
                            : const ElevatedButton(
                                onPressed: null, child: Text("Out of stock")))
                        : const SizedBox(),
                  )
                ],
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _product.name,
            style: const TextStyle(color: AppTheme.appBarSecondaryColor),
          ),
          iconTheme: const IconThemeData(color: AppTheme.appBarSecondaryColor),
          actions: Provider.of<AuthProvider>(context, listen: false)
                      .currentUser!
                      .id ==
                  _product.sellerId
              ? [
                  Container(
                    margin: const EdgeInsets.only(right: 6.0),
                    child: IconButton(
                        onPressed: () async {},
                        tooltip: 'Edit product',
                        icon: const Icon(Icons.edit)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 12.0, left: 6.0),
                    child: IconButton(
                        onPressed: () async {
                          ProductProvider productProvider =
                              Provider.of<ProductProvider>(context,
                                  listen: false);

                          bool? success = await showDialog(
                              context: context,
                              builder: (_) => ChangeNotifierProvider.value(
                                    value: productProvider,
                                    child: DeleteDialog(
                                        id: _product.id!,
                                        deleteType: DeleteType.product),
                                  ));
                          if (success ?? false) {
                            Navigator.of(context).pop(success);
                          }
                        },
                        tooltip: 'Delete product',
                        icon: const Icon(Icons.delete)),
                  ),
                ]
              : [],
        ),
        body: FutureBuilder(
            future: _future,
            builder: (context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error:\n${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  return LayoutBuilder(
                    builder: (context, constraints) => Builder(
                      builder: (context) =>
                          (constraints.maxWidth >= Constants.mobilWidth &&
                                  MediaQuery.of(context).size.height >=
                                      Constants.mobilHeight)
                              ? _desktopBody(snapshot.data!)
                              : _mobileBody(snapshot.data!),
                    ),
                  );
                }

                return const Center(
                    child: Text('Error:\nNo seller with this ID'));
              }

              return const Center(child: CircularProgressIndicator());
            }));
  }
}

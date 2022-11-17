import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/cart_provider.dart';
import 'package:emezen/widgets/loading_support_button.dart';
import 'package:emezen/widgets/shopping_cart_element.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCartDialog extends StatefulWidget {
  const ShoppingCartDialog({Key? key}) : super(key: key);

  @override
  State<ShoppingCartDialog> createState() => _ShoppingCartDialogState();
}

class _ShoppingCartDialogState extends State<ShoppingCartDialog> {
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 16, bottom: 32),
                child: const Text(
                  'Shopping cart',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) => cartProvider
                        .cart.keys.isEmpty
                    ? Center(
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 24.0),
                            child: const Text('The shopping cart is empty')),
                      )
                    : Column(
                        children: [
                          ...cartProvider.cart.keys
                              .map((product) =>
                                  ShoppingCartElement(product: product))
                              .toList(),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                                top: 36.0,
                                left: 24.0,
                                right: 24.0,
                                bottom: 24.0),
                            child: LoadingSupportButton(
                              isLoading: cartProvider.isLoading,
                              text: 'Checkout',
                              onPressed: () async {
                                String? token = await Provider.of<AuthProvider>(
                                        context,
                                        listen: false)
                                    .isLoggedIn();
                                if (token != null) {
                                  await cartProvider.checkout(token);
                                }
                              },
                            ),
                          )
                        ],
                      ),
              )
            ],
          ),
        ),
      );
}

import 'package:emezen/model/enums.dart';
import 'package:emezen/model/product.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/pages/product_page.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/cart_provider.dart';
import 'package:emezen/provider/product_page_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:emezen/util/constants.dart';
import 'package:emezen/util/utils.dart';
import 'package:emezen/widgets/delete_dialog.dart';
import 'package:emezen/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthProvider _authProvider;
  late ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _productProvider = Provider.of<ProductProvider>(context, listen: false);

    _loadData();
  }

  void _loadData() {
    _authProvider.getCurrentUser();
    _productProvider.getAllProductsOfUser(widget.userId);
  }

  Future<void> _navigateToProductPage(Product product) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    await Navigator.of(context).push(MaterialPageRoute(
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

  Widget _buildProfileImage(User user) {
    imageCache.clear();
    Image image = Image.network(
      '${Constants.apiBaseUrl}/user/image/${widget.userId}',
      width: 128,
      height: 128,
      errorBuilder: (context, exception, stackTrace) => const Image(
        image: AssetImage('assets/images/profile-picture-placeholder.png'),
        width: 128,
      ),
      fit: BoxFit.cover,
    );

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: image,
    );
  }

  Widget _buildProfilePage(User user) => Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey.shade200,
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Builder(builder: (context) => _buildProfileImage(user)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Email: ${user.contactEmail}'),
                  Text('Age: ${user.age}'),
                ],
              )
            ]),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: const Text(
              'Products',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Consumer<ProductProvider>(
              builder: (_, productProvider, __) => productProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (productProvider.userProducts.isNotEmpty
                      ? ResponsiveGridRow(
                          children: productProvider.userProducts
                              .map((product) => ResponsiveGridCol(
                                  xs: 12,
                                  sm: 6,
                                  md: 4,
                                  lg: 3,
                                  child: ProductCard(
                                    product: product,
                                    onTap: _navigateToProductPage,
                                  )))
                              .toList())
                      : const Center(child: Text('User has no products'))))
        ],
      );

  Future<void> _showDeleteProfileDialog() async {
    bool? success = await showDialog(
        context: context,
        builder: (_) => ChangeNotifierProvider.value(
              value: _authProvider,
              child: DeleteDialog(
                  id: widget.userId, deleteType: DeleteType.profile),
            ));
    if (success ?? false) {
      Utils.showMessage('User successfully deleted', false);
    }
  }

  @override
  Widget build(BuildContext context) => Consumer<AuthProvider>(
      builder: (_, authProvider, __) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Profile',
                style: TextStyle(color: AppTheme.appBarSecondaryColor)),
            iconTheme:
                const IconThemeData(color: AppTheme.appBarSecondaryColor),
            actions: [
              if (authProvider.currentUser != null)
                Container(
                  margin: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    onPressed: () async => await _showDeleteProfileDialog(),
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete profile',
                  ),
                ),
            ],
          ),
          body: authProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : authProvider.currentUser != null
                  ? Builder(
                      builder: (context) =>
                          _buildProfilePage(authProvider.currentUser!),
                    )
                  : const Center(child: Text('Error: user does not exist'))));
}

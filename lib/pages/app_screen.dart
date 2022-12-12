import 'package:emezen/model/enums.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/pages/home_page.dart';
import 'package:emezen/pages/not_found_page.dart';
import 'package:emezen/pages/error_page.dart';
import 'package:emezen/pages/profile_page.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/cart_provider.dart';
import 'package:emezen/provider/product_details_editor_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:emezen/util/constants.dart';
import 'package:emezen/widgets/drawer_list_tile.dart';
import 'package:emezen/widgets/create_edit_product_dialog.dart';
import 'package:emezen/widgets/shopping_cart_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  final User user;

  const AppScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  late User currentUser;
  late Widget _body;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    currentUser = widget.user;
    _body = const HomePage();
  }

  Future<void> _reloadData() async {
    await Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    await Provider.of<ProductProvider>(context, listen: false)
        .getProductObserver();
    await Provider.of<ProductProvider>(context, listen: false)
        .getFilledProducts();
  }

  Future<void> _navigate(MainPages destination,
      {Map<String, dynamic> args = const {}}) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    switch (destination) {
      case MainPages.profile:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          String? userId = args['id'];

          if (userId == null) return const ErrorPage(error: 'User ID is null');

          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: authProvider),
              ChangeNotifierProvider.value(value: productProvider),
              ChangeNotifierProvider.value(value: cartProvider),
            ],
            child: ProfilePage(userId: userId),
          );
        }));
        break;
      case MainPages.newProduct:
        String? userId = args['id'];

        if (userId == null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const ErrorPage(error: 'User ID is null')));
        }

        var result = await showDialog(
            context: context,
            builder: (_) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: productProvider),
                    ChangeNotifierProvider(
                        create: (_) => ProductDetailsEditorProvider()),
                  ],
                  child: CreateEditProductDialog(userId: userId!),
                ));
        if (result != null) {
          _reloadData();
        }
        break;
      default:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const NotFoundPage()));
    }
  }

  void _navigateAndCloseDrawer(MainPages destination,
      {Map<String, dynamic> args = const {}}) {
    _navigate(destination, args: args);
    if (_scaffoldKey.currentState != null) {
      if (_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState?.closeDrawer();
      }
    }
  }

  String _getHelloText() {
    return 'Hello, ${currentUser.firstName}!';
  }

  void _logout() {
    Provider.of<AuthProvider>(context, listen: false).logout();
  }

  Widget _refreshIcon() => Consumer<ProductProvider>(
        builder: (context, productProvider, child) => IconButton(
          onPressed: () => _reloadData(),
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
          color: AppTheme.appBarSecondaryColor,
        ),
      );

  Widget _cartIcon() => Consumer<CartProvider>(
        builder: (context, cartProvider, child) => Stack(
          children: [
            IconButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (_) => ChangeNotifierProvider.value(
                        value:
                            Provider.of<CartProvider>(context, listen: false),
                        child: ChangeNotifierProvider.value(
                            value: Provider.of<AuthProvider>(context,
                                listen: false),
                            child: const ShoppingCartDialog()))),
                icon: const Icon(
                  Icons.shopping_cart,
                  color: AppTheme.appBarSecondaryColor,
                )),
            cartProvider.cart.isNotEmpty
                ? Positioned.fill(
                    child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        cartProvider.cart.length.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.appBarSecondaryColor,
                        ),
                      ),
                    ),
                  ))
                : const SizedBox()
          ],
        ),
      );

  Widget _mobileScaffold() => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Container(
            height: AppBar().preferredSize.height,
            padding: const EdgeInsets.all(12),
            child: const Image(
              image: AssetImage('assets/images/emezen-logo.png'),
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppTheme.appBarSecondaryColor),
          actions: [
            Center(
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Builder(builder: (context) => _refreshIcon()))),
            Center(
                child: Container(
                    margin: const EdgeInsets.all(12.0),
                    child: Builder(builder: (context) => _cartIcon()))),
          ],
        ),
        drawer: Drawer(
          backgroundColor: AppTheme.drawerBackgroundColor,
          child: Column(
            children: [
              Container(
                height: AppBar().preferredSize.height,
                padding: const EdgeInsets.all(12),
                child: const Image(
                  image: AssetImage('assets/images/emezen-logo.png'),
                ),
              ),
              Builder(
                builder: (context) => DrawerListTile(
                  image: const Image(
                    image: AssetImage(
                        'assets/images/profile-picture-placeholder.png'),
                    width: 24,
                  ),
                  text: _getHelloText(),
                  onTap: () => _navigateAndCloseDrawer(MainPages.profile,
                      args: {'id': currentUser.id!}),
                ),
              ),
              const Divider(),
              DrawerListTile(
                iconData: Icons.add,
                text: 'New product',
                onTap: () => _navigateAndCloseDrawer(MainPages.newProduct,
                    args: {'id': currentUser.id!}),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: DrawerListTile(
                    iconData: Icons.key,
                    text: 'Logout',
                    onTap: () => _logout(),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: _body,
      );

  List<PopupMenuItem> _getPopupMenuItems() => [
        PopupMenuItem(
            child: const Text('Profile'),
            onTap: () async {
              await Future.delayed(const Duration(milliseconds: 1));
              _navigate(MainPages.profile, args: {'id': currentUser.id!});
            }),
        PopupMenuItem(
            child: const Text('New product'),
            onTap: () async {
              await Future.delayed(const Duration(milliseconds: 1));
              _navigate(MainPages.newProduct, args: {'id': currentUser.id!});
            }),
        PopupMenuItem(child: const Text('Logout'), onTap: () => _logout())
      ];

  Widget _desktopScaffold() => Scaffold(
        appBar: AppBar(
          title: Container(
            height: AppBar().preferredSize.height,
            padding: const EdgeInsets.all(12),
            child: const Image(
              image: AssetImage('assets/images/emezen-logo.png'),
            ),
          ),
          centerTitle: true,
          actions: [
            Center(
              child: Builder(
                builder: (context) => _refreshIcon(),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Center(
              child: Builder(
                builder: (context) => _cartIcon(),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            PopupMenuButton(
                itemBuilder: (BuildContext context) => _getPopupMenuItems(),
                child: Builder(
                  builder: (context) => Row(
                    children: [
                      Text(_getHelloText(),
                          style: const TextStyle(
                              fontSize: 20,
                              color: AppTheme.appBarSecondaryColor)),
                      const Icon(Icons.arrow_drop_down_sharp,
                          color: AppTheme.appBarSecondaryColor)
                    ],
                  ),
                ))
          ],
        ),
        body: _body,
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Builder(
            builder: (context) => (constraints.maxWidth >=
                        Constants.mobilWidth &&
                    MediaQuery.of(context).size.height >= Constants.mobilHeight)
                ? _desktopScaffold()
                : _mobileScaffold()));
  }
}

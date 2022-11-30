import 'package:emezen/model/enums.dart';
import 'package:emezen/model/page_with_args.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/pages/home_page.dart';
import 'package:emezen/pages/new_product_page.dart';
import 'package:emezen/pages/not_found_page.dart';
import 'package:emezen/pages/error_page.dart';
import 'package:emezen/pages/profile_page.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/cart_provider.dart';
import 'package:emezen/provider/main_page_provider.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:emezen/util/constants.dart';
import 'package:emezen/widgets/drawer_list_tile.dart';
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
  late final MainPageProvider _mainPageProvider;
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  late User currentUser;
  late Widget _body;

  @override
  void initState() {
    super.initState();
    _mainPageProvider = Provider.of<MainPageProvider>(context, listen: false);
    _scaffoldKey = GlobalKey<ScaffoldState>();
    currentUser = widget.user;
    _body = Builder(builder: (context) => _getBody());
  }

  // TODO: termékfigyelő notificationként az alkalmazás tetején, formázás a termékleírásra

  Widget _getBody() => Consumer<MainPageProvider>(
      builder: (context, pageProvider, child) =>
          Selector<MainPageProvider, PageWithArgs>(
              selector: (_, pageProvider) => pageProvider.actualPage,
              builder: (_, actualPage, __) {
                switch (actualPage.page) {
                  case MainPages.home:
                    return const HomePage();
                  case MainPages.profile:
                    {
                      if (actualPage.args.isEmpty ||
                          actualPage.args['id'] == null) {
                        return const ErrorPage(
                            error: "No 'id' is given as argument");
                      }
                      return ProfilePage(userId: actualPage.args['id']);
                    }
                  case MainPages.newProduct:
                    {
                      if (actualPage.args.isEmpty ||
                          actualPage.args['id'] == null) {
                        return const ErrorPage(
                            error: "No 'userId' is given as argument");
                      }
                      return NewProductPage(userId: actualPage.args['id']);
                    }
                  default:
                    return const NotFoundPage();
                }
              }));

  void _navigate(MainPages destination,
      {Map<String, dynamic> args = const {}}) {
    _mainPageProvider.changePage(destination, args: args);
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
                iconData: Icons.home,
                text: 'Home',
                onTap: () => _navigateAndCloseDrawer(MainPages.home),
              ),
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
          child: const Text('Home'),
          onTap: () => _navigate(MainPages.home),
        ),
        PopupMenuItem(
            child: const Text('Profile'),
            onTap: () =>
                _navigate(MainPages.profile, args: {'id': currentUser.id!})),
        PopupMenuItem(
            child: const Text('New product'),
            onTap: () =>
                _navigate(MainPages.newProduct, args: {'id': currentUser.id!})),
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

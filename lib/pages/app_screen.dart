import 'package:emezen/model/enums.dart' as enums;
import 'package:emezen/model/page_with_args.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/pages/home_page.dart';
import 'package:emezen/pages/not_found_page.dart';
import 'package:emezen/pages/error_page.dart';
import 'package:emezen/pages/profile_page.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/page_provider.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:emezen/util/constants.dart';
import 'package:emezen/widgets/drawer_list_tile.dart';
import 'package:emezen/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  final User user;

  const AppScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  late final PageProvider _pageProvider;
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    _pageProvider = Provider.of<PageProvider>(context, listen: false);
    _scaffoldKey = GlobalKey<ScaffoldState>();
    currentUser = widget.user;
  }

  Widget _getBody() => Consumer<PageProvider>(
      builder: (context, pageProvider, child) =>
          Selector<PageProvider, PageWithArgs>(
              selector: (_, pageProvider) => pageProvider.actualPage,
              builder: (_, actualPage, __) {
                switch (actualPage.page) {
                  case enums.Page.home:
                    return const HomePage();
                  case enums.Page.profile:
                    {
                      if (actualPage.args.isEmpty ||
                          actualPage.args['id'] == null) {
                        return const ErrorPage(
                            error: "No 'id' is given as argument");
                      }
                      return ProfilePage(userId: actualPage.args['id']);
                    }
                  default:
                    return const NotFoundPage();
                }
              }));

  void _navigate(enums.Page destination,
      {Map<String, dynamic> args = const {}}) {
    _pageProvider.changePage(destination, args: args);
  }

  void _navigateAndCloseDrawer(enums.Page destination,
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

  Widget _mobileScaffold() => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: const SearchBar(),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppTheme.appBarSecondaryColor),
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
                  onTap: () => _navigateAndCloseDrawer(enums.Page.profile,
                      args: {'id': currentUser.id!}),
                ),
              ),
              const Divider(),
              DrawerListTile(
                iconData: Icons.home,
                text: 'Home',
                onTap: () => _navigateAndCloseDrawer(enums.Page.home),
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
        body: Builder(
          builder: (context) => _getBody(),
        ),
      );

  List<PopupMenuItem> _getPopupMenuItems() => [
        PopupMenuItem(
          child: const Text('Home'),
          onTap: () => _navigate(enums.Page.home),
        ),
        PopupMenuItem(
            child: const Text('Profile'),
            onTap: () =>
                _navigate(enums.Page.profile, args: {'id': currentUser.id!})),
        PopupMenuItem(child: const Text('Logout'), onTap: () => _logout())
      ];

  Widget _desktopScaffold() => Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: AppBar().preferredSize.height,
                padding: const EdgeInsets.all(12),
                child: const Image(
                  image: AssetImage('assets/images/emezen-logo.png'),
                ),
              ),
              const Expanded(
                child: SearchBar(),
              ),
              PopupMenuButton(
                  itemBuilder: (BuildContext context) => _getPopupMenuItems(),
                  child: Builder(
                    builder: (context) => Row(
                      children: [
                        Text(_getHelloText(),
                            style: const TextStyle(
                                color: AppTheme.appBarSecondaryColor)),
                        const Icon(Icons.arrow_drop_down_sharp,
                            color: AppTheme.appBarSecondaryColor)
                      ],
                    ),
                  ))
            ],
          ),
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) => _getBody(),
        ),
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

import 'package:emezen/model/user.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:emezen/util/constants.dart';
import 'package:emezen/widgets/drawer_list_tile.dart';
import 'package:emezen/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String? accessToken;
  final Object? extras;

  const HomeScreen({Key? key, this.accessToken, this.extras}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Map<String, dynamic> _args;
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  String? _accessToken;
  User? currentUser;

  void _setUserByAccessToken(String token) {
    setState(() {
      currentUser = User.fromJson(JwtToken.payload(token)['user']);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.extras != null) {
      _args = widget.extras as Map<String, dynamic>;
    } else {
      _args = {};
    }

    _scaffoldKey = GlobalKey<ScaffoldState>();
    _accessToken = widget.accessToken;
    if (widget.accessToken != null) {
      _setUserByAccessToken(widget.accessToken!);
    }
  }

  void _navigateAndCloseDrawer(String destination) {
    context.push(destination, extra: {'fromHome': true});
    GoRouter.of(context).addListener(_watchRouterChange);
    if (_scaffoldKey.currentState != null) {
      if (_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState?.closeDrawer();
      }
    }
  }

  void _watchRouterChange() {
    if (GoRouter.of(context).location == '/') {
      Provider.of<AuthProvider>(context).getAccessToken().then((token) {
        _accessToken = token;
        if (_accessToken != null) {
          _setUserByAccessToken(_accessToken!);
        }
        GoRouter.of(context).removeListener(_watchRouterChange);
      });
    }
  }

  String _getHelloText() {
    if (currentUser == null) {
      return 'Hello, please login!';
    }
    return 'Hello, ${currentUser!.firstName}!';
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
          child: ListView(
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
                  iconData: Icons.account_circle,
                  text: _getHelloText(),
                  onTap: () {},
                  enabled: false,
                ),
              ),
              DrawerListTile(
                iconData: Icons.key,
                text: 'Login',
                onTap: () => _navigateAndCloseDrawer('/login'),
              ),
              DrawerListTile(
                  iconData: Icons.person,
                  text: 'Register',
                  onTap: () => _navigateAndCloseDrawer('/register')),
            ],
          ),
        ),
      );

  List<PopupMenuItem> _getPopupMenuItems() {
    if (currentUser != null) {
      return [
        PopupMenuItem(
            child: const Text('Logout'),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false)
                  .logout()
                  .then((_) {
                setState(() {
                  currentUser = null;
                });
              });
            })
      ];
    }
    return [
      PopupMenuItem(
        child: const Text('Login'),
        onTap: () => _navigateAndCloseDrawer('/login'),
      ),
      PopupMenuItem(
        child: const Text('Register'),
        onTap: () => _navigateAndCloseDrawer('/register'),
      ),
    ];
  }

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

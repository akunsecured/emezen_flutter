import 'package:emezen/model/enums.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:emezen/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _mobileScaffold() => Scaffold(
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
              ListTile(
                  leading: const Icon(Icons.key),
                  title: const Text("Login",
                      style: TextStyle(color: AppTheme.drawerListTileColor)),
                  onTap: () {
                    Navigator.pushNamed(context, '/auth',
                        arguments: AuthMethod.login);
                  }),
              ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Register",
                      style: TextStyle(color: AppTheme.drawerListTileColor)),
                  onTap: () {
                    Navigator.pushNamed(context, '/auth',
                        arguments: AuthMethod.register);
                  }),
            ],
          ),
        ),
      );

  Widget _desktopScaffold() => Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.appBarColor,
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
              const Text('Hello, user!')
            ],
          ),
          centerTitle: true,
        ),
      );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => Builder(
          builder: (context) => (constraints.maxWidth > 715 &&
                  MediaQuery.of(context).size.height > 550)
              ? _desktopScaffold()
              : _mobileScaffold()));
}

import 'package:emezen/model/user.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthProvider _authProvider;
  late Future<User?> _future;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);

    _future = _authProvider.getUser(widget.userId);
  }

  Widget _buildProfileImage(User user) {
    if (_authProvider.currentUser != null) {
      if (widget.userId == _authProvider.currentUser!.id) {
        // TODO: show this only in edit mode
        return Container(
          margin: const EdgeInsets.only(right: 16),
          child: Stack(
            children: [
              // TODO: implement if user has image logic
              const Image(
                image:
                    AssetImage('assets/images/profile-picture-placeholder.png'),
                width: 128,
              ),
              Positioned.fill(
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          // TODO: implement user image upload
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          color: const Color(0x60000000),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.edit,
                                color: AppTheme.appBarSecondaryColor,
                              ),
                              Text('Edit',
                                  style: TextStyle(
                                      color: AppTheme.appBarSecondaryColor))
                            ],
                          ),
                        ),
                      )))
            ],
          ),
        );
      }
    }

    // TODO: implement if user has image logic
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: const Image(
        image: AssetImage('assets/images/profile-picture-placeholder.png'),
        width: 128,
      ),
    );
  }

  Widget _buildProfileButtons(User user) {
    if (_authProvider.currentUser != null) {
      if (widget.userId == _authProvider.currentUser!.id) {
        return TextButton.icon(
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
            onPressed: () {
              // TODO: implement show edit profile with provider
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit profile'));
      }
    }

    return TextButton.icon(
        style: TextButton.styleFrom(
          primary: Colors.black,
        ),
        onPressed: () {
          // TODO: implement chat
        },
        icon: const Icon(Icons.chat),
        label: const Text('Contact'));
  }

  Widget _buildProfilePage(User user) => Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Row(children: [
              Builder(builder: (context) => _buildProfileImage(user)),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${user.firstName} ${user.lastName}',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
                ],
              )
            ]),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Builder(builder: (context) => _buildProfileButtons(user)))
        ],
      ));

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _future,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return const Center(child: Text('Error: user does not exist'));
            }

            return Builder(
              builder: (context) => _buildProfilePage(snapshot.data!),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      );
}

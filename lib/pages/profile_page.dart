import 'dart:io';

import 'package:emezen/model/enums.dart';
import 'package:emezen/model/product.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/provider/profile_page_provider.dart';
import 'package:emezen/util/constants.dart';
import 'package:emezen/widgets/bordered_text_field.dart';
import 'package:emezen/widgets/product_card.dart';
import 'package:file_picker/file_picker.dart';
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
  late ProfilePageProvider _profilePageProvider;
  late ProductProvider _productProvider;

  late Future<User?> _future;
  late Future<List<Product>> _shopFuture;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _profilePageProvider =
        Provider.of<ProfilePageProvider>(context, listen: false);
    _productProvider = Provider.of<ProductProvider>(context, listen: false);

    _future = _authProvider.getUser(widget.userId);
    _shopFuture = _productProvider.getAllProductsOfUser(widget.userId);
  }

  Widget _buildAboutTab(User user) => Selector<ProfilePageProvider, bool>(
      selector: (_, profilePageProvider) =>
          profilePageProvider.isEditingProfile,
      builder: (_, bool isEditing, __) => isEditing
          ? Column(
              children: [
                BorderedTextField(_profilePageProvider.aboutController, 'About',
                    TextInputType.multiline),
                BorderedTextField(_profilePageProvider.contactEmailController,
                    'Contact email', TextInputType.emailAddress),
                BorderedTextField(_profilePageProvider.phoneNumberController,
                    'Phone number', TextInputType.phone),
              ],
            )
          : Container(
        margin: EdgeInsets.all(16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Age:'),
                      Text('About:'),
                      Text('Contact email:'),
                      Text('Phone number:')
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(user.age.toString()),
                      Text(user.about.toString()),
                      Text(user.contactEmail.toString()),
                      Text(user.phoneNumber.toString()),
                    ],
                  )
                ],
              ),
          ));

  Widget _buildShopTab(User user) => FutureBuilder(
        future: _shopFuture,
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return const Center(child: Text('Error'));
            }

            if (snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('There are no products from this user'));
            }

            List<Product> products = snapshot.data!;

            return ResponsiveGridRow(
                children: products
                    .map((product) => ResponsiveGridCol(
                        xs: 12,
                        sm: 6,
                        md: 4,
                        lg: 3,
                        child: ProductCard(product: product)))
                    .toList());
          }

          return const Center(child: CircularProgressIndicator());
        },
      );

  Widget _buildProfileImage(User user) => Selector<ProfilePageProvider, bool>(
      selector: (_, profilePageProvider) =>
          profilePageProvider.isEditingProfile,
      builder: (_, bool isEditing, __) {
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

        if (isEditing) {
          return Container(
            margin: const EdgeInsets.only(right: 16),
            child: Stack(
              children: [
                image,
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowMultiple: false,
                              allowedExtensions: ['png'],
                            );

                            if (result != null) {
                              bool? response =
                                  await _authProvider.uploadProfilePicture(
                                      widget.userId, result.files.single);
                              if (response != null && response) {
                                print(response);
                                // setState(() {});
                              }
                            }
                          },
                        )))
              ],
            ),
          );
        }
        return Container(
          margin: const EdgeInsets.only(right: 16),
          child: image,
        );
      });

  Widget _buildProfileButtons(User user) {
    if (_authProvider.currentUser != null) {
      if (widget.userId == _authProvider.currentUser!.id) {
        return Selector<ProfilePageProvider, bool>(
          selector: (_, profilePageProvider) =>
              profilePageProvider.isEditingProfile,
          builder: (_, bool isEditing, __) => isEditing
              ? Row(
                  children: [
                    Container(
                      width: 96,
                      margin: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: implement save
                          _profilePageProvider.changeEditingProfile();
                        },
                        child: const Text('Save'),
                      ),
                    ),
                    SizedBox(
                      width: 96,
                      child: OutlinedButton(
                          onPressed: () {
                            // TODO: implement cancel
                            _profilePageProvider.changeEditingProfile();
                          },
                          child: const Text('Cancel')),
                    )
                  ],
                )
              : SizedBox(
                  child: TextButton.icon(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: _profilePageProvider.changeEditingProfile,
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit profile')),
                ),
        );
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

  Widget _buildTabBar() => Row(
        children: ProfileTabs.values
            .map((tab) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextButton(
                    onPressed: () {
                      _profilePageProvider.changeTab(tab);
                    },
                    style: TextButton.styleFrom(primary: Colors.white24),
                    child: Selector<ProfilePageProvider, ProfileTabs>(
                        selector: (_, profilePageProvider) =>
                            profilePageProvider.actualTab,
                        builder: (_, ProfileTabs actualTab, __) => Text(
                              tab.value,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: tab == actualTab
                                      ? Colors.black
                                      : Colors.black38),
                            )))))
            .toList(),
      );

  Widget _buildSelectedTab(User user) =>
      Selector<ProfilePageProvider, ProfileTabs>(
        selector: (_, profilePageProvider) => profilePageProvider.actualTab,
        builder: (_, ProfileTabs actualTab, __) {
          switch (actualTab) {
            case ProfileTabs.about:
              return _buildAboutTab(user);
            case ProfileTabs.shop:
              return _buildShopTab(user);
            default:
              return const Text('Error, tab does not exist to this enum value');
          }
        },
      );

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
                  Builder(builder: (context) => _buildProfileButtons(user))
                ],
              )
            ]),
          ),
          Builder(builder: (context) => _buildTabBar()),
          Builder(builder: (context) => _buildSelectedTab(user))
        ],
      );

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

            return Consumer<ProfilePageProvider>(
              builder: (_, profilePageProvider, __) => Builder(
                  builder: (context) => _buildProfilePage(snapshot.data!)),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      );
}

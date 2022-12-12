import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  final Function()? onTap;

  const SearchBar({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();

    _titleController.addListener(() {
      Provider.of<ProductProvider>(context, listen: false)
          .setTitle(_titleController.text);
    });
  }

  @override
  Widget build(BuildContext context) => Container(
        height: AppBar().preferredSize.height,
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: TextFormField(
          controller: _titleController,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              fillColor: AppTheme.appBarSecondaryColor,
              filled: true,
              hintText: 'Search for the title of the product',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
              suffixIcon: Container(
                height: AppBar().preferredSize.height,
                decoration: const BoxDecoration(
                    color: AppTheme.primarySwatch,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: AppTheme.appBarColor,
                  ),
                  onPressed: () async {
                    Provider.of<ProductProvider>(context, listen: false)
                        .setNameFilter(_titleController.text);
                    Provider.of<ProductProvider>(context, listen: false)
                        .getAllProducts();
                  },
                ),
              )),
        ),
      );
}

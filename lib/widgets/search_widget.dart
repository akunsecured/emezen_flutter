import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/widgets/search_bar.dart';
import 'package:emezen/widgets/search_filter_group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
        value: Provider.of<ProductProvider>(context, listen: false),
        child: Column(
          children: [
            SearchBar(
              onTap: () => Provider.of<ProductProvider>(context, listen: false)
                  .getAllProducts(),
            ),
            const Text(
              'Advanced searching tools',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            ExpandIcon(
                isExpanded: _isExpanded,
                padding: const EdgeInsets.all(0.0),
                onPressed: (bool isExpanded) => setState(() {
                      _isExpanded = !isExpanded;
                    })),
            if (_isExpanded) const SearchFilterGroup(),
          ],
        ),
      );
}

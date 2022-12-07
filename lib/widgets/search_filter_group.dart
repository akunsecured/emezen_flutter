import 'package:emezen/model/enums.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/util/validation.dart';
import 'package:emezen/widgets/bordered_text_field.dart';
import 'package:emezen/widgets/search_filter_group_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchFilterGroup extends StatefulWidget {
  const SearchFilterGroup({Key? key}) : super(key: key);

  @override
  State<SearchFilterGroup> createState() => _SearchFilterGroupState();
}

class _SearchFilterGroupState extends State<SearchFilterGroup> {
  late final TextEditingController _priceFromController;
  late final TextEditingController _priceToController;

  @override
  void initState() {
    super.initState();

    _priceFromController = TextEditingController();
    _priceToController = TextEditingController();

    _priceFromController.addListener(() {
      Provider.of<ProductProvider>(context, listen: false)
          .setPriceFrom(_priceFromController.text);
    });

    _priceToController.addListener(() {
      Provider.of<ProductProvider>(context, listen: false)
          .setPriceTo(_priceToController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ProductProvider, List<ProductCategories>>(
      selector: (_, productProvider) => productProvider.categories,
      builder: (_, List<ProductCategories> categories, __) => Column(
        children: [
          const Divider(),
          const SearchFilterGroupTextField('Price'),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 96.0,
                child: BorderedTextField(
                  _priceFromController,
                  'From',
                  TextInputType.number,
                  numRegExp: Validation.priceRegExp,
                ),
              ),
              const Text('-'),
              SizedBox(
                width: 96.0,
                child: BorderedTextField(
                  _priceToController,
                  'To',
                  TextInputType.number,
                  numRegExp: Validation.priceRegExp,
                ),
              ),
            ],
          ),
          const SearchFilterGroupTextField('Categories'),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0,
              runSpacing: 12.0,
              children: categories
                  .map((category) => Selector<ProductProvider, bool>(
                      selector: (_, productProvider) => productProvider
                          .containsCategoryFilter(category.index),
                      builder: (_, bool contains, __) => FilterChip(
                          label: Text(category.text),
                          selected: contains,
                          onSelected: (_) {
                            Provider.of<ProductProvider>(context, listen: false)
                                .addOrRemoveCategoryFilter(category.index);
                          })))
                  .toList(),
            ),
          ),
          const SizedBox(height: 24.0)
        ],
      ),
    );
  }
}

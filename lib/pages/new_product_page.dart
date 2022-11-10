import 'package:emezen/model/enums.dart';
import 'package:emezen/model/product.dart';
import 'package:emezen/provider/add_product_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/widgets/bordered_text_field.dart';
import 'package:emezen/widgets/loading_support_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class NewProductPage extends StatefulWidget {
  final String userId;

  const NewProductPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  late final ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AddProductProvider(widget.userId),
        builder: (context, _) {
          AddProductProvider addProductProvider =
              Provider.of<AddProductProvider>(context, listen: false);
          return Center(
            child: Container(
              width: 400,
              margin: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38, width: 2.0),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 32),
                        child: const Text(
                          'Create new product',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      BorderedTextField(addProductProvider.nameController,
                          "Product's name", TextInputType.name),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          width: double.infinity,
                          child: const Text('Select category')),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        child: Selector<AddProductProvider, ProductCategories>(
                          selector: (_, addProductProvider) => addProductProvider.selectedCategory,
                          builder: (_, selectedCategory, __) => DropdownButton(
                              value: addProductProvider.selectedCategory,
                              items: ProductCategories.values
                                  .map((category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(category.text),
                                      ))
                                  .toList(),
                              onChanged: (ProductCategories? category) =>
                                  addProductProvider
                                      .setSelectedCategory(category)),
                        ),
                      ),
                      BorderedTextField(addProductProvider.priceController,
                          "Price", TextInputType.number),
                      BorderedTextField(addProductProvider.quantityController,
                          'Quantity', TextInputType.number),
                      BorderedTextField(
                        addProductProvider.detailsController,
                        'Details',
                        TextInputType.text,
                      ),
                      Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white
                            ),
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowMultiple: true,
                                allowedExtensions: ['png'],
                              );

                              if (result != null) {
                                addProductProvider.setImages(result.files);
                              }

                              setState(() {});
                            },
                            label: const Text('Choose files'),
                            icon: const Icon(Icons.folder),
                          )),
                      Selector<AddProductProvider, List<PlatformFile>>(
                          selector: (_, addProductProvider) =>
                              addProductProvider.images,
                          builder: (_, images, __) {
                            print(images.length);
                            return ResponsiveGridRow(
                                children: images
                                    .map((image) => ResponsiveGridCol(
                                        xs: 12,
                                        sm: 6,
                                        md: 4,
                                        child: Stack(children: [
                                          Image.memory(
                                            image.bytes!,
                                            width: 128,
                                            height: 128,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned.fill(
                                              child: Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              color: Colors.red,
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                addProductProvider
                                                    .removeImage(image);
                                                setState(() {});
                                              },
                                            ),
                                          ))
                                        ])))
                                    .toList());
                          }),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            top: 32, bottom: 16, left: 12, right: 12),
                        child: Consumer<ProductProvider>(
                          builder: (context, productProvider, child) =>
                              Selector<ProductProvider, bool>(
                            selector: (_, productProvider) =>
                                productProvider.isLoading,
                            builder: (_, isLoading, __) => LoadingSupportButton(
                              isLoading: isLoading,
                              text: 'Add product',
                              onPressed: () async {
                                Product product =
                                    addProductProvider.getProduct();
                                await _productProvider.createProduct(
                                    product, addProductProvider.images);
                                addProductProvider.clear();
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    _productProvider.dispose();
    super.dispose();
  }
}

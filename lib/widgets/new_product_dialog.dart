import 'package:emezen/model/enums.dart';
import 'package:emezen/model/product.dart';
import 'package:emezen/provider/add_product_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/util/validation.dart';
import 'package:emezen/widgets/bordered_text_field.dart';
import 'package:emezen/widgets/loading_support_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class NewProductDialog extends StatefulWidget {
  final String userId;

  const NewProductDialog({Key? key, required this.userId}) : super(key: key);

  @override
  State<NewProductDialog> createState() => _NewProductDialogState();
}

class _NewProductDialogState extends State<NewProductDialog> {
  final GlobalKey<FormState> _newProductFormKey = GlobalKey();

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
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black38, width: 2.0),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child: Form(
                      key: _newProductFormKey,
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
                          BorderedTextField(
                            addProductProvider.nameController,
                            "Product's name",
                            TextInputType.name,
                            validateFun: Validation.validatePartOfName,
                            maxLines: 1,
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              width: double.infinity,
                              child: const Text('Select category')),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            width: double.infinity,
                            child:
                                Selector<AddProductProvider, ProductCategories>(
                              selector: (_, addProductProvider) =>
                                  addProductProvider.selectedCategory,
                              builder: (_, selectedCategory, __) =>
                                  DropdownButton(
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
                          BorderedTextField(
                            addProductProvider.priceController,
                            "Price",
                            TextInputType.number,
                            validateFun: Validation.validatePrice,
                            numRegExp: Validation.priceRegExp,
                            maxLines: 1,
                          ),
                          BorderedTextField(
                            addProductProvider.quantityController,
                            'Quantity',
                            TextInputType.number,
                            validateFun: Validation.validateQuantity,
                            numRegExp: Validation.numUntil999RegExp,
                            maxLines: 1,
                          ),
                          BorderedTextField(
                            addProductProvider.detailsController,
                            'Details',
                            TextInputType.multiline,
                            validateFun: Validation.validateDetails,
                            maxLines: 10,
                            maxLength: 500,
                          ),
                          Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white),
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
                              builder: (_, images, __) => ResponsiveGridRow(
                                  children: images
                                      .map((image) => ResponsiveGridCol(
                                            xs: 12,
                                            sm: 6,
                                            md: 4,
                                            child: Center(
                                              child: SizedBox(
                                                width: 128,
                                                height: 128,
                                                child: Stack(children: [
                                                  Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      alignment: Alignment.center,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.black38,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(24.0),
                                                        ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                24.0),
                                                        child: Image.memory(
                                                          image.bytes!,
                                                          fit: BoxFit.cover,
                                                          width: 128,
                                                          height: 128,
                                                        ),
                                                      )),
                                                  Positioned.fill(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                        margin:
                                                            const EdgeInsets.all(
                                                                4.0),
                                                        child: IconButton(
                                                          color: Colors.red,
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                          tooltip: 'Remove',
                                                          onPressed: () {
                                                            addProductProvider
                                                                .removeImage(
                                                                    image);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                              ),
                                            ),
                                          ))
                                      .toList())),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                                top: 32, bottom: 16, left: 12, right: 12),
                            child: Consumer<ProductProvider>(
                              builder: (context, productProvider, child) =>
                                  Selector<ProductProvider, bool>(
                                selector: (_, productProvider) =>
                                    productProvider.isLoading,
                                builder: (_, isLoading, __) =>
                                    LoadingSupportButton(
                                  isLoading: isLoading,
                                  text: 'Add product',
                                  onPressed: () async {
                                    if (_newProductFormKey.currentState
                                            ?.validate() ??
                                        false) {
                                      if (addProductProvider.images.isNotEmpty) {
                                        Product product =
                                            addProductProvider.getProduct();
                                        await _productProvider.createProduct(
                                            product, addProductProvider.images);
                                        Navigator.of(context).pop(true);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                'At least 1 image must be selected');
                                      }
                                    }
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
              ),
            ),
          );
        });
  }
}

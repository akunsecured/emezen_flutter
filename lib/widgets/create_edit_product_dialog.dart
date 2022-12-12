import 'package:emezen/model/enums.dart';
import 'package:emezen/model/product.dart';
import 'package:emezen/provider/create_edit_product_provider.dart';
import 'package:emezen/provider/product_details_editor_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/util/validation.dart';
import 'package:emezen/widgets/bordered_text_field.dart';
import 'package:emezen/widgets/loading_support_button.dart';
import 'package:emezen/widgets/product_details_editor_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class CreateEditProductDialog extends StatefulWidget {
  final String userId;
  final Product? product;

  const CreateEditProductDialog({
    Key? key,
    required this.userId,
    this.product,
  }) : super(key: key);

  @override
  State<CreateEditProductDialog> createState() =>
      _CreateEditProductDialogState();
}

class _CreateEditProductDialogState extends State<CreateEditProductDialog> {
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
        create: (_) => CreateEditProductProvider(widget.userId),
        builder: (context, _) {
          CreateEditProductProvider createEditProductProvider =
              Provider.of<CreateEditProductProvider>(context, listen: false);

          if (widget.product != null) {
            createEditProductProvider.nameController.text =
                widget.product!.name;
            createEditProductProvider.detailsController.text =
                widget.product!.details;
            createEditProductProvider.priceController.text =
                widget.product!.price.toString();
            createEditProductProvider.quantityController.text =
                widget.product!.quantity.toString();
            createEditProductProvider
                .setSelectedCategory(widget.product!.category);
            createEditProductProvider.imageUrls =
                widget.product!.images.map((image) => image as String).toList();
          }

          return Consumer<CreateEditProductProvider>(
            builder: (_, createEditProductProvider, __) => Dialog(
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
                              margin:
                                  const EdgeInsets.only(top: 16, bottom: 32),
                              child: Text(
                                widget.product != null
                                    ? 'Edit product'
                                    : 'Create new product',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            BorderedTextField(
                              createEditProductProvider.nameController,
                              "Product's name",
                              TextInputType.name,
                              validateFun: Validation.validatePartOfName,
                              maxLines: 1,
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                width: double.infinity,
                                child: const Text('Select category')),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              width: double.infinity,
                              child: Selector<CreateEditProductProvider,
                                  ProductCategories>(
                                selector: (_, createEditProductProvider) =>
                                    createEditProductProvider.selectedCategory,
                                builder: (_, selectedCategory, __) =>
                                    DropdownButton(
                                        value: createEditProductProvider
                                            .selectedCategory,
                                        items: ProductCategories.values
                                            .map((category) => DropdownMenuItem(
                                                  value: category,
                                                  child: Text(category.text),
                                                ))
                                            .toList(),
                                        onChanged:
                                            (ProductCategories? category) =>
                                                createEditProductProvider
                                                    .setSelectedCategory(
                                                        category)),
                              ),
                            ),
                            BorderedTextField(
                              createEditProductProvider.priceController,
                              "Price",
                              TextInputType.number,
                              validateFun: Validation.validatePrice,
                              numRegExp: Validation.priceRegExp,
                              maxLines: 1,
                            ),
                            BorderedTextField(
                              createEditProductProvider.quantityController,
                              'Quantity',
                              TextInputType.number,
                              validateFun: Validation.validateQuantity,
                              numRegExp: Validation.numUntil999RegExp,
                              maxLines: 1,
                            ),
                            ProductDetailsEditorWidget(
                              text: widget.product != null
                                  ? widget.product!.details
                                  : null,
                            ),
                            if (widget.product == null)
                              Container(
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 12),
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
                                      createEditProductProvider
                                          .setImages(result.files);
                                    }
                                  },
                                  label: const Text('Choose files'),
                                  icon: const Icon(Icons.folder),
                                ),
                              ),
                            ResponsiveGridRow(
                                children: createEditProductProvider.images
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
                                                          createEditProductProvider
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
                                    .toList()),
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
                                    text: widget.product != null
                                        ? 'Edit product'
                                        : 'Add product',
                                    onPressed: () async {
                                      if (_newProductFormKey.currentState
                                              ?.validate() ??
                                          false) {
                                        if (Provider.of<
                                                    ProductDetailsEditorProvider>(
                                                context,
                                                listen: false)
                                            .productDetailsController
                                            .text
                                            .isNotEmpty) {
                                          if (widget.product == null) {
                                            if (createEditProductProvider
                                                .images.isNotEmpty) {
                                              Product product =
                                                  createEditProductProvider
                                                      .getProduct();
                                              product.details = Provider.of<
                                                          ProductDetailsEditorProvider>(
                                                      context,
                                                      listen: false)
                                                  .productDetailsController
                                                  .text;
                                              await _productProvider
                                                  .createProduct(
                                                      product,
                                                      createEditProductProvider
                                                          .images);
                                              Navigator.of(context).pop(true);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'At least 1 image must be selected');
                                            }
                                          } else {
                                            Product product =
                                                createEditProductProvider
                                                    .getProduct();
                                            product.id = widget.product!.id;
                                            product.images =
                                                widget.product!.images;
                                            product.details = Provider.of<
                                                ProductDetailsEditorProvider>(
                                                context,
                                                listen: false)
                                                .productDetailsController
                                                .text;

                                            bool success =
                                                await _productProvider
                                                    .editProduct(product);
                                            if (success) {
                                              Navigator.of(context).pop(true);
                                            }
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Details cannot be empty');
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
            ),
          );
        });
  }
}

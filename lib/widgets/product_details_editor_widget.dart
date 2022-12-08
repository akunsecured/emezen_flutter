import 'package:emezen/model/enums.dart';
import 'package:emezen/provider/product_details_editor_provider.dart';
import 'package:emezen/widgets/product_details_styled_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsEditorWidget extends StatefulWidget {
  const ProductDetailsEditorWidget({Key? key}) : super(key: key);

  @override
  State<ProductDetailsEditorWidget> createState() =>
      _ProductDetailsEditorWidgetState();
}

class _ProductDetailsEditorWidgetState
    extends State<ProductDetailsEditorWidget> {
  @override
  Widget build(BuildContext context) => Consumer<ProductDetailsEditorProvider>(
        builder: (_, productDetailsEditorProvider, __) =>
            Selector<ProductDetailsEditorProvider, ProductDetailsMode>(
          selector: (_, productDetailsEditorProvider) =>
              productDetailsEditorProvider.actualTab,
          builder: (_, actualTab, __) => Column(
            children: [
              Builder(builder: (context) => _buildTabButtons(actualTab)),
              SizedBox(
                width: double.infinity,
                child: Builder(
                  builder: (context) => _buildActualTab(actualTab),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildTabButtons(ProductDetailsMode actualTab) => Row(
        mainAxisSize: MainAxisSize.min,
        children: ProductDetailsMode.values
            .map((tab) => TextButton.icon(
                onPressed: () => Provider.of<ProductDetailsEditorProvider>(
                        context,
                        listen: false)
                    .changeTab(tab),
                icon: Icon(tab.getIcon(),
                    color: actualTab == tab ? Colors.black : Colors.black54),
                label: Text(
                  tab.getText(),
                  style: TextStyle(
                      color: actualTab == tab ? Colors.black : Colors.black54,
                      fontWeight: actualTab == tab ? FontWeight.bold : null),
                )))
            .toList(),
      );

  Widget _buildActualTab(ProductDetailsMode tab) {
    switch (tab) {
      case ProductDetailsMode.edit:
        return Column(
          children: [
            Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black12, width: 1.0),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: TextFormatters.values
                        .map((formatter) => TextStylerButton(
                            textEditingController:
                                Provider.of<ProductDetailsEditorProvider>(
                                        context,
                                        listen: false)
                                    .productDetailsController,
                            formatter: formatter))
                        .toList(),
                  ),
                )),
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black12, width: 1.0),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Material(
                color: Colors.transparent,
                child: TextField(
                    maxLines: 20,
                    controller: Provider.of<ProductDetailsEditorProvider>(
                            context,
                            listen: false)
                        .productDetailsController,
                    decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        border: InputBorder.none,
                        hoverColor: Colors.transparent)),
              ),
            ),
          ],
        );
      case ProductDetailsMode.preview:
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black12, width: 1.0),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: SingleChildScrollView(
                  child: Container(
                      margin: const EdgeInsets.all(12.0),
                      width: double.infinity,
                      child: ProductDetailsStyledText(
                          Provider.of<ProductDetailsEditorProvider>(context)
                              .productDetailsController
                              .text)),
                )),
          ],
        );
      default:
        return const Center(
          child: Text('Tab does not exist.'),
        );
    }
  }
}

class TextStylerButton extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextFormatters formatter;

  const TextStylerButton(
      {Key? key, required this.textEditingController, required this.formatter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String tagChar, tooltip;
    String? label;
    TextStyle? textStyle;
    Map<String, String> tagAttributes = {};

    switch (formatter) {
      case TextFormatters.header1:
        tagChar = 'h1';
        tooltip = 'Header 1';
        label = 'h1';
        break;
      case TextFormatters.header2:
        tagChar = 'h2';
        tooltip = 'Header 2';
        label = 'h2';
        break;
      case TextFormatters.header3:
        tagChar = 'h3';
        tooltip = 'Header 3';
        label = 'h3';
        break;
      case TextFormatters.bold:
        tagChar = 'b';
        tooltip = 'Bold';
        label = 'B';
        textStyle = const TextStyle(fontWeight: FontWeight.bold);
        break;
      case TextFormatters.italic:
        tagChar = 'i';
        tooltip = 'Italic';
        label = 'i';
        textStyle = const TextStyle(fontStyle: FontStyle.italic);
        break;
      case TextFormatters.underlined:
        tagChar = 'u';
        tooltip = 'Underlined';
        label = 'u';
        textStyle = const TextStyle(decoration: TextDecoration.underline);
        break;
      default:
        tagChar = '';
        tooltip = '';
        label = '';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      child: IconButton(
        onPressed: () async {
          // Getting the selection's start
          int base = textEditingController.selection.baseOffset;
          if (base == -1) base = 0;

          // Getting the selection's end
          int extent = textEditingController.selection.extentOffset;
          if (extent == -1) extent = 0;

          // Setting starting and ending position
          bool isExtentBigger = base < extent;
          int startPos = isExtentBigger ? base : extent;
          int endPos = isExtentBigger ? extent : base;

          // Building up the tagged string
          String prefixText = textEditingController.text.substring(0, startPos);

          String attrs = '';
          if (tagAttributes.isNotEmpty) {
            attrs = ' ';
            List<String> temp = [];
            tagAttributes.forEach((key, value) => temp.add('$key="$value"'));
            attrs += temp.join(' ');
          }

          String midText =
              '<$tagChar$attrs>${textEditingController.text.substring(startPos, endPos)}</$tagChar>';
          String suffixText = textEditingController.text.substring(endPos);
          textEditingController.text = '$prefixText$midText$suffixText';
          textEditingController.selection = TextSelection(
              baseOffset: startPos, extentOffset: startPos + midText.length);
        },
        icon: Text(label, style: textStyle),
        tooltip: tooltip,
      ),
    );
  }
}

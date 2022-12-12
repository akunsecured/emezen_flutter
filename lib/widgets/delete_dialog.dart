import 'package:emezen/model/enums.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteDialog extends StatelessWidget {
  final String? id;
  final DeleteType deleteType;

  const DeleteDialog({Key? key, this.id, required this.deleteType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String titleType;
    String contentType;
    Function() onPressed;

    switch (deleteType) {
      case DeleteType.profile:
        {
          titleType = 'profile';
          contentType = 'your profile';
          onPressed = () {
            Provider.of<AuthProvider>(context, listen: false).deleteUser().then(
                (_) =>
                    Navigator.of(context).popUntil((route) => route.isFirst));
          };

          break;
        }
      case DeleteType.product:
        {
          titleType = 'product';
          contentType = 'this product';
          onPressed = () {
            Provider.of<ProductProvider>(context, listen: false)
                .deleteProduct(id!)
                .then((success) => Navigator.of(context).pop(success));
          };

          break;
        }
      default:
        throw Exception('Invalid delete type');
    }

    return AlertDialog(
      title: Text('Deleting $titleType'),
      content: Text('Are you sure you want to delete $contentType?'),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: onPressed,
            child: const Text('Yes')),
        OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No')),
      ],
    );
  }
}

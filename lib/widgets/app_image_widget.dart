import 'package:flutter/material.dart';

class AppImageWidget extends StatelessWidget {
  final bool predicate;
  final String url;
  final double size;

  const AppImageWidget({
    Key? key,
    required this.url,
    required this.size,
    this.predicate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Image image;
    if (predicate) {
      image = Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, exception, stackTrace) => Image(
          image:
              const AssetImage('assets/images/product-image-placeholder.jpg'),
          width: size,
        ),
      );
    } else {
      image = Image(
        image: const AssetImage('assets/images/product-image-placeholder.jpg'),
        width: size,
      );
    }

    return image;
  }
}

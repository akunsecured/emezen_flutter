import 'package:emezen/style/app_theme.dart';
import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final IconData? iconData;
  final String text;
  final Function() onTap;
  final bool? enabled;
  final Widget? image;

  const DrawerListTile(
      {Key? key,
      required this.text,
      required this.onTap,
      this.iconData,
      this.enabled,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: image ??
            Icon(
              iconData,
              color: AppTheme.drawerListTileColor,
            ),
        title: Text(text,
            style: const TextStyle(color: AppTheme.drawerListTileColor)),
        onTap: onTap,
        enabled: enabled ?? true,
      );
}

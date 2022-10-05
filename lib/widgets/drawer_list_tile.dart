import 'package:emezen/style/app_theme.dart';
import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Function() onTap;
  final bool? enabled;

  const DrawerListTile(
      {Key? key,
      required this.iconData,
      required this.text,
      required this.onTap,
      this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(
          iconData,
          color: AppTheme.drawerListTileColor,
        ),
        title: Text(text,
            style: const TextStyle(color: AppTheme.drawerListTileColor)),
        onTap: onTap,
        enabled: enabled ?? true,
      );
}

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class MyBottomBar extends StatelessWidget implements PreferredSizeWidget {
  const MyBottomBar({
    super.key,
    required this.page,
    required this.onPageChanged,
  });

  final BodyPage page;
  final ValueChanged<BodyPage> onPageChanged;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return HorizontalNavigationBar(
      height: preferredSize.height,
      extraTopPadding: context.safe.top,
      value: page,
      onChanged: onPageChanged,
      items: [
        HorizontalNavigationItem(
          value: BodyPage.theme,
          label: Text('Theme'),
          selectedIcon: Icon(Icons.palette),
          unselectedIcon: Icon(Icons.palette_outlined),
        ),
        HorizontalNavigationItem(
          value: BodyPage.alerts,
          label: Text('Alerts'),
          selectedIcon: Icon(Icons.warning),
          unselectedIcon: Icon(Icons.warning_amber),
        ),
        HorizontalNavigationItem(
          value: BodyPage.snackbars,
          label: Text('Snackbars'),
          selectedIcon: Icon(Icons.notifications),
          unselectedIcon: Icon(Icons.notifications_none),
        ),
        HorizontalNavigationItem(
          value: BodyPage.settings,
          label: Text('Settings'),
          selectedIcon: Icon(Icons.settings),
          unselectedIcon: Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}

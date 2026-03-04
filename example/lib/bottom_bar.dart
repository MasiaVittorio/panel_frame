import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class MyBottomBar extends StatelessWidget implements PreferredSizeWidget {
  const MyBottomBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final pageVar = context.provide<Reactive<BodyPage>>();

    return pageVar.build((context, value) {
      return HorizontalNavigationBar(
        height: preferredSize.height,
        extraTopPadding: context.safe.top,
        value: value,
        onChanged: pageVar.update,
        items: [
          const HorizontalNavigationItem(
            value: BodyPage.theme,
            label: Text('Theme'),
            selectedIcon: Icon(Icons.palette),
            unselectedIcon: Icon(Icons.palette_outlined),
          ),
          const HorizontalNavigationItem(
            value: BodyPage.alerts,
            label: Text('Alerts'),
            selectedIcon: Icon(Icons.warning),
            unselectedIcon: Icon(Icons.warning_amber),
          ),
          const HorizontalNavigationItem(
            value: BodyPage.snackbars,
            label: Text('Snackbars'),
            selectedIcon: Icon(Icons.notifications),
            unselectedIcon: Icon(Icons.notifications_none),
          ),
          const HorizontalNavigationItem(
            value: BodyPage.settings,
            label: Text('Settings'),
            selectedIcon: Icon(Icons.settings),
            unselectedIcon: Icon(Icons.settings_outlined),
          ),
          const HorizontalNavigationItem(
            value: BodyPage.more,
            label: Text('More'),
            selectedIcon: Icon(Icons.more_horiz),
            unselectedIcon: Icon(Icons.more_horiz),
          ),
        ],
      );
    });
  }
}

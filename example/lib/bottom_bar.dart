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
    return Material(
      color: context.theme.colorScheme.surfaceContainerLowest,
      child: SafeArea(
        child: RadioNavBar(
          singleBackgroundColor:
              context.theme.colorScheme.surfaceContainerLowest,
          selectedValue: page,
          onSelect: onPageChanged,
          items: [
            RadioNavBarItem(
              value: BodyPage.theme,
              title: Text('Theme'),
              icon: Icon(Icons.palette),
              unselectedIcon: Icon(Icons.palette_outlined),
            ),
            RadioNavBarItem(
              value: BodyPage.alerts,
              title: Text('Alerts'),
              icon: Icon(Icons.warning),
              unselectedIcon: Icon(Icons.warning_amber),
            ),
            RadioNavBarItem(
              value: BodyPage.snackbars,
              title: Text('Snackbars'),
              icon: Icon(Icons.notifications),
              unselectedIcon: Icon(Icons.notifications_none),
            ),
            RadioNavBarItem(
              value: BodyPage.settings,
              title: Text('Settings'),
              icon: Icon(Icons.settings),
              unselectedIcon: Icon(Icons.settings_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

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
          orderedValues: [BodyPage.alerts, BodyPage.theme],
          items: {
            BodyPage.alerts: RadioNavBarItem(
              title: 'Alerts',
              icon: Icons.warning,
              unselectedIcon: Icons.warning_amber,
            ),
            BodyPage.theme: RadioNavBarItem(
              title: 'Theme',
              icon: Icons.palette,
              unselectedIcon: Icons.palette_outlined,
            ),
          },
          onSelect: onPageChanged,
        ),
      ),
    );
  }
}

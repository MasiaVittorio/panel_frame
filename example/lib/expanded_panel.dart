import 'package:example/main.dart';
import 'package:example/pages/panel_theme_page.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ExpandedPanel extends StatelessWidget {
  const ExpandedPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final pageVar = context.provide<Reactive<PanelPage>>();
    return pageVar.build((context, value) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AnimatedPagedView(
              value: value,
              pages: const [
                ViewPage(child: Placeholder(), value: PanelPage.alerts),
                ViewPage(child: Placeholder(), value: PanelPage.settings),
                ViewPage(child: PanelThemePage(), value: PanelPage.theme),
              ],
            ),
          ),
          HorizontalNavigationBar(
            value: value,
            onChanged: pageVar.update,
            items: [
              const HorizontalNavigationItem(
                value: PanelPage.alerts,
                label: Text('Alerts'),
                selectedIcon: Icon(Icons.notifications),
                unselectedIcon: Icon(Icons.notifications_outlined),
              ),
              const HorizontalNavigationItem(
                value: PanelPage.settings,
                label: Text('Settings'),
                selectedIcon: Icon(Icons.settings),
                unselectedIcon: Icon(Icons.settings_outlined),
              ),
              const HorizontalNavigationItem(
                value: PanelPage.theme,
                label: Text('Theme'),
                selectedIcon: Icon(Icons.color_lens),
                unselectedIcon: Icon(Icons.color_lens_outlined),
              ),
            ],
          ),
        ],
      );
    });
  }
}

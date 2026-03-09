import 'package:example/main.dart';
import 'package:example/pages/expanded_settings_page.dart';
import 'package:example/pages/panel_alerts_page.dart';
import 'package:example/pages/theme_page.dart';
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
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: AnimatedPagedView(
                value: value,
                pages: const [
                  ViewPage(child: PanelAlertsPage(), value: PanelPage.alerts),
                  ViewPage(
                    value: PanelPage.settings,
                    child: ExpandedSettingsPage(),
                  ),
                  ViewPage(
                    child: ThemePage(withHeader: true),
                    value: PanelPage.theme,
                  ),
                ],
              ),
            ),
          ),
          HorizontalNavigationBar(
            height: 64,
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

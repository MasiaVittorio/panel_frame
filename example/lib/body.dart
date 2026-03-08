import 'package:example/main.dart';
import 'package:example/pages/notes_page.dart';
import 'package:example/pages/settings_page.dart';
import 'package:example/pages/snackbars_page.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

import 'pages/alerts_page.dart';
import 'pages/theme_page.dart';

class MyBody extends StatelessWidget {
  const MyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return context.provide<Reactive<BodyPage>>().build((context, value) {
      return AnimatedPagedView(
        value: value,
        pages: const [
          ViewPage(value: BodyPage.theme, child: ThemePage()),
          ViewPage(value: BodyPage.alerts, child: AlertsPage()),
          ViewPage(value: BodyPage.snackbars, child: SnackBarsPage()),
          ViewPage(value: BodyPage.settings, child: SettingsPage()),
          ViewPage(value: BodyPage.notes, child: NotesPage()),
        ],
      );
    });
  }
}

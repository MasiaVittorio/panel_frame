import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

import 'pages/alerts_page.dart';
import 'pages/theme_page.dart';

class MyBody extends StatelessWidget {
  const MyBody({super.key, required this.page});

  final BodyPage page;

  @override
  Widget build(BuildContext context) {
    return RadioPageTransition(
      page: page,
      orderedPages: [BodyPage.alerts, BodyPage.theme],
      builder: (context, value) {
        return switch (value) {
          BodyPage.alerts => AlertsPage(),
          BodyPage.theme => ThemePage(),
        };
      },
    );
  }
}

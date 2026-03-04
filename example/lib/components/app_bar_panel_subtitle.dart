import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class AppBarPanelSubtitle extends StatelessWidget {
  const AppBarPanelSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    final panelPageVar = context.provide<Reactive<PanelPage>>();
    return panelPageVar.build((context, value) {
      return Text(value.name.capitalizeFirst);
    });
  }
}

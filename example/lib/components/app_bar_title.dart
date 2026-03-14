import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    final pageVar = context.provide<Reactive<BodyPage>>();
    return pageVar.build((context, page) {
      return frame.buildWithIsTopBarExpanded(
        builder: (context, value) {
          return AnimatedText(
            value ? "Opened panel" : page.name.capitalizeFirst,
            style: const TextStyle(fontWeight: FontWeight.w500),
            duration: const Duration(milliseconds: 260),
          );
        },
      );
    });
  }
}

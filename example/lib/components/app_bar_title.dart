import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    return frame.isMostlyOpened.build((context, value) {
      return AnimatedText(
        value ? "Panel title" : "App title",
        duration: const Duration(milliseconds: 260),
      );
    });
  }
}

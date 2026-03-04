import 'package:example/alerts/full_screen_alert.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class FullAlertTile extends StatelessWidget {
  const FullAlertTile({super.key});

  @override
  Widget build(BuildContext context) {
    final panelFrame = context.panelFrame;

    return ListTile(
      leading: const Icon(Icons.fullscreen),
      title: const Text('Show full screen'),
      onTap: () => panelFrame.showAlert(const FullScreenAlert()),
    );
  }
}

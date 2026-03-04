import 'package:example/alerts/my_alert.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class SmallAlertTile extends StatelessWidget {
  const SmallAlertTile({super.key});

  @override
  Widget build(BuildContext context) {
    final panelFrame = context.panelFrame;

    return ListTile(
      leading: const Icon(Icons.horizontal_split_rounded),
      title: const Text('Show smaller alert'),
      onTap: () => panelFrame.showAlert(const MyAlert(height: 400)),
    );
  }
}

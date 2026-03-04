import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class PreviousAlertTile extends StatelessWidget {
  const PreviousAlertTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.keyboard_arrow_left),
      title: const Text('Previous alert'),
      onTap: context.panelFrame.previousAlert,
    );
  }
}

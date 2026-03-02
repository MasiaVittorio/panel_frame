import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class OpenPanelTile extends StatelessWidget {
  const OpenPanelTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.keyboard_arrow_up),
      title: Text('Open panel'),
      onTap: context.panelFrame.openPanel,
    );
  }
}

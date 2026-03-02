import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class ClosePanelTile extends StatelessWidget {
  const ClosePanelTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.close),
      title: Text('Close panel'),
      onTap: context.panelFrame.closePanel,
    );
  }
}

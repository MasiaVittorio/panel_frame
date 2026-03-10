import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class RestoreDefaultStyleTile extends StatelessWidget {
  const RestoreDefaultStyleTile({super.key});

  @override
  Widget build(BuildContext context) {
    final onStyleChange = context
        .provide<ValueChanged<PanelFrameStyleCustomizations>>();

    return ListTile(
      onTap: () => context.panelFrame.showAlert(
        ConfirmPanelAlert(
          title: const Text('Restore style to defaults?'),
          onConfirmed: () => onStyleChange(MyHomePage.defaultStyle),
          danger: true,
        ),
      ),
      title: const Text('Restore default style'),
      leading: const Icon(Icons.restart_alt),
    );
  }
}

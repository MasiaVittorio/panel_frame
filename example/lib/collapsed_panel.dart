import 'package:example/alerts/my_alert.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class CollapsedPanel extends StatelessWidget {
  const CollapsedPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final panelFrame = context.panelFrame;

    return Stack(
      children: [
        Center(child: PanelDragHandle()),
        Positioned.fill(
          child: Pad(
            horizontal: layout.padding.large,
            child: Al.centerRight(
              child: IconButton(
                onPressed: panelFrame.openPanel,
                icon: Icon(Icons.keyboard_arrow_up),
                style: FrameAppBar.buttonStyle(context.theme),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Pad(
            horizontal: layout.padding.large,
            child: Al.centerLeft(
              child: IconButton(
                onPressed: () => panelFrame.showAlert(MyAlert(height: 400)),
                icon: Icon(Icons.horizontal_split_rounded),
                style: FrameAppBar.buttonStyle(context.theme),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

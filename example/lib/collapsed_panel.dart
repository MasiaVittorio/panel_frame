import 'package:example/alerts/my_alert.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class CollapsedPanel extends StatelessWidget {
  const CollapsedPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final panelFrame = context.panelFrame;
    final style = context.panelFrameStyle;

    return InkWell(
      onTap: panelFrame.openPanel,
      child: Stack(
        children: [
          Center(child: PanelDragHandle()),
          Positioned(
            left: 0,
            width: style.collapsedPanelHeight,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () => panelFrame.showAlert(MyAlert(height: 400)),
                icon: Icon(Icons.horizontal_split_rounded),
                style: FrameAppBar.buttonStyle(context.theme),
              ),
            ),
          ),
          Positioned(
            right: 0,
            width: style.collapsedPanelHeight,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () => panelFrame.showSnackBar(
                  PanelSnackBar(child: Icon(Icons.add)),
                ),
                icon: Icon(Icons.check),
                style: FrameAppBar.buttonStyle(context.theme),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

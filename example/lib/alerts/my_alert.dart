import 'package:example/components/full_alert_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class MyAlert extends StatelessWidget {
  const MyAlert({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final panelFrame = context.panelFrame;
    void next() => panelFrame.showAlert(MyAlert(height: height + 200));
    return HeaderedList(
      height: height,
      children: {
        (title: 'Navigation', leading: Icon(Icons.compare_arrows_sharp)): [
          ListTile(
            leading: Icon(Icons.keyboard_arrow_right),
            title: Text('Next alert'),
            onTap: next,
          ),
          FullAlertTile(),
        ],
        (
          title: 'More space',
          leading: Icon(Icons.vertical_align_center_outlined),
        ): [
          Space.vertical(600),
        ],
      }.groupedCards(),
    );
  }
}

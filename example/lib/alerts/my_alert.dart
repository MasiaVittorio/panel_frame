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
        (
          title: 'Navigation',
          leading: const Icon(Icons.compare_arrows_sharp),
        ): [
          ListTile(
            leading: const Icon(Icons.keyboard_arrow_right),
            title: const Text('Next alert'),
            onTap: next,
          ),
          const FullAlertTile(),
        ],
        (
          title: 'More space',
          leading: const Icon(Icons.vertical_align_center_outlined),
        ): [
          const Space.vertical(600),
        ],
      }.groupedCards(),
    );
  }
}

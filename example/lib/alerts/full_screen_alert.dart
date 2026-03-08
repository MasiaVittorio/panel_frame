import 'package:example/components/full_alert_tile.dart';
import 'package:example/components/small_alert_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class FullScreenAlert extends StatelessWidget implements PanelAlertWidget {
  @override
  EdgeInsets? get overridePanelMargin => null;

  @override
  bool? get wantsToBeFullScreen => true;

  const FullScreenAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderedList.expand(
      children: {
        (title: 'Alerts', leading: const Icon(Icons.warning_outlined)): [
          const SmallAlertTile(),
          const FullAlertTile(),
        ],
        (title: 'More space', leading: const Icon(Icons.vertical_align_center)):
            [const Space.vertical(700)],
      }.groupedCards(),
    );
  }
}

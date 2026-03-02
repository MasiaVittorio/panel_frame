import 'package:example/components/close_panel_tile.dart';
import 'package:example/components/full_alert_tile.dart';
import 'package:example/components/previous_alert_tile.dart';
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
    return HeaderedList(
      children: {
        (title: 'Navigation', leading: Icon(Icons.compare_arrows_sharp)): [
          PreviousAlertTile(),
          ClosePanelTile(),
        ],
        (title: 'Alerts', leading: Icon(Icons.warning_outlined)): [
          SmallAlertTile(),
          FullAlertTile(),
        ],
        (title: 'More space', leading: Icon(Icons.vertical_align_center)): [
          Space.vertical(700),
        ],
      }.groupedCards(),
    );
  }
}

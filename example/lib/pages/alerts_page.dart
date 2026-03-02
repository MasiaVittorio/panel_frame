import 'package:example/components/full_alert_tile.dart';
import 'package:example/components/open_panel_tile.dart';
import 'package:example/components/small_alert_tile.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: {
        (title: 'Navigation', leading: Icon(Icons.compare_arrows_sharp)): [
          OpenPanelTile(),
        ],
        (title: 'Alerts', leading: Icon(Icons.warning_outlined)): [
          SmallAlertTile(),
          FullAlertTile(),
        ],
      }.groupedCards(),
    );
  }
}

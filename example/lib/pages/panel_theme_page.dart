import 'package:example/components/close_panel_tile.dart';
import 'package:example/components/full_alert_tile.dart';
import 'package:example/components/small_alert_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class PanelThemePage extends StatelessWidget {
  const PanelThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PanelHeader(),
        ...{
          (
            title: 'Navigation',
            leading: const Icon(Icons.compare_arrows_sharp),
          ): [
            const ClosePanelTile(),
          ],
          (title: 'Alerts', leading: const Icon(Icons.warning_outlined)): [
            const SmallAlertTile(),
            const FullAlertTile(),
          ],
        }.groupedCards(),
      ],
    );
  }
}

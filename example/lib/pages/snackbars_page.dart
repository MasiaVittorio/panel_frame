import 'package:example/components/open_panel_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class SnackBarsPage extends StatelessWidget {
  const SnackBarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: {
        (title: 'Navigation', leading: const Icon(Icons.compare_arrows_sharp)): [
          const OpenPanelTile(),
        ],
        (title: 'Snackbars', leading: const Icon(Icons.keyboard_arrow_right)): [
          ListTile(
            title: const Text("Show Snackbar"),
            onTap: () => context.panelFrame.showSnackBar(
              PanelSnackBar(child: const Icon(Icons.add)),
            ),
          ),
        ],
      }.groupedCards(),
    );
  }
}

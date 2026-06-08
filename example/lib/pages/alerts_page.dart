import 'package:example/components/full_alert_tile.dart';
import 'package:example/components/small_alert_tile.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final style = context.panelFrameStyle;
    final theme = context.theme;
    final layout = theme.layout;
    final customizations = context.provide<PanelFrameStyleCustomizations>();
    final frame = context.panelFrame;
    return ListView(
      children: {
        (
          title: 'Simple alerts',
          leading: const Icon(Icons.warning_amber_outlined),
        ): [
          const SmallAlertTile(),
          const FullAlertTile(),
        ],
        (
          title: 'Interactive alerts',
          leading: const Icon(Icons.edit_outlined),
        ): [
          ListTile(
            title: const Text("Insert alert"),
            leading: const Icon(Icons.text_fields),
            onTap: () async {
              final result = await InsertPanelAlert.show(
                context: context,
                label: 'Insert some text',
              );
              if (result case String text) {
                if (!context.mounted) return;
                frame.showSnackBar(
                  PanelSnackBar(
                    child: Text('You entered: $text'),
                    dismissible: true,
                    scrollable: true,
                  ),
                );
              }
            },
          ),
          ListTile(
            title: const Text("Alternatives alert"),
            leading: const Icon(Icons.list),
            onTap: () => context.panelFrame.showAlert(
              AlternativesPanelAlert.grouped(
                title: const Text("Title"),
                onSubmit: (value) => frame.showSnackBar(
                  PanelSnackBar(child: Text('Selected value: $value')),
                ),
                alternatives: const [
                  [
                    PanelAlternative(value: 1, label: Text('Option one')),
                    PanelAlternative(value: 2, label: Text('Option two')),
                    PanelAlternative(value: 3, label: Text('Option three')),
                  ],
                  [PanelAlternative(value: 4, label: Text('Not sure'))],
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text("Alternatives alert"),
            subtitle: const Text("Confirmable"),
            leading: const Icon(Icons.list),
            onTap: () => frame.showAlert(
              AlternativesPanelAlert.grouped(
                confirmationMode:
                    AlternativeConfirmationMode.selectAndConfirm(),
                onSubmit: (value) => frame.showSnackBar(
                  PanelSnackBar(child: Text('Selected value: $value')),
                ),
                alternatives: const [
                  [
                    PanelAlternative(value: 1, label: Text('Option one')),
                    PanelAlternative(value: 2, label: Text('Option two')),
                    PanelAlternative(value: 3, label: Text('Option three')),
                  ],
                  [PanelAlternative(value: -1, label: Text('Not sure'))],
                ],
              ),
            ),
          ),
        ],
        (title: 'Settings', leading: const Icon(Icons.settings_outlined)): [
          SwitchListTile(
            title: const Text("Floating alerts"),
            value: style.alertsMargin.horizontal > 0,
            onChanged: (value) {
              context.changePanelStyle(
                customizations.copyWith(
                  alertsBorderRadius: value
                      ? layout.radius.large
                      : layout.radius.larger,
                  alertsMargin: value
                      ? EdgeInsets.all(layout.margin.larger)
                      : EdgeInsets.zero,
                  alertsCanCoverViewPadding: !value,
                  alertsBorderSide: value
                      ? BorderSide(color: theme.colorScheme.outline)
                      : BorderSide.none,
                  alertsBarrierColor: value
                      ? theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.5,
                        )
                      : Colors.black54,
                ),
              );
            },
          ),
        ],
      }.groupedCards(),
    );
  }
}

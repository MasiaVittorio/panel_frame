import 'package:example/alerts/my_alert.dart';
import 'package:example/components/restore_default_style_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class ExpandedSettingsPage extends StatelessWidget {
  const ExpandedSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onCustomizationsChanged = context
        .provide<ValueChanged<PanelFrameStyleCustomizations>>();

    final style = PanelFrameStyle.of(context);

    final customizations = context.provide<PanelFrameStyleCustomizations>();

    final theme = context.theme;
    final layout = theme.layout;

    return PanelList.expand(
      children: [
        ...{
          (title: 'Top bar', leading: Icon(MdiIcons.dockTop)): [
            ListTile(
              leading: Icon(MdiIcons.arrowExpandVertical),
              title: const Text('Height'),
              subtitle: Text(style.topBarExpandedHeight.toString()),
              onTap: () {
                onCustomizationsChanged(
                  customizations.copyWith(
                    topBarExpandedHeight: switch (style.topBarExpandedHeight) {
                      120 => 100,
                      100 => 72,
                      _ => 120,
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.dockTop),
              title: const Text('Overlap'),
              subtitle: Text(style.openPanelTopBarOverlap.toString()),
              onTap: () {
                onCustomizationsChanged(
                  customizations.copyWith(
                    openPanelTopBarOverlap:
                        switch (style.openPanelTopBarOverlap) {
                          0 => -layout.margin.large,
                          final double v when v == -layout.margin.large =>
                            style.expandedPanelMargin.top +
                                style.collapsedPanelHeight / 2,
                          _ => 0,
                        },
                  ),
                );
              },
            ),
          ],
          (title: 'Expanded panel', leading: const Icon(Icons.unfold_more)): [
            SwitchListTile(
              title: const Text("Floating expanded panel"),
              value: style.expandedPanelMargin.horizontal > 0,
              onChanged: (value) {
                onCustomizationsChanged(
                  customizations.copyWith(
                    expandedPanelBorderRadius: value ? layout.radius.large : 0,
                    openPanelTopBarOverlap: value
                        ? style.collapsedPanelHeight / 2
                        : 0,
                    expandedPanelMargin: value
                        ? EdgeInsets.all(layout.margin.large).copyWith(top: 0)
                        : EdgeInsets.zero,
                    topBarExpandedHeight: value ? 120 : 100,
                    expandedPanelCanCoverViewPadding: !value,
                    expandedPanelBorderSide: value
                        ? BorderSide(color: theme.colorScheme.outline)
                        : BorderSide.none,
                    panelBarrierColor: value
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
        const GroupedCard(
          isFirst: true,
          isLast: true,
          child: RestoreDefaultStyleTile(),
        ),
        Space.vertical(layout.margin.medium),
        const GroupedCard(isFirst: true, isLast: true, child: LoremIpsum()),
      ],
    );
  }
}

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
            ListTile(
              leading: Icon(MdiIcons.borderRadius),
              title: const Text('Border radius'),
              subtitle: Text(style.expandedPanelBorderRadius.toString()),
              onTap: () {
                onCustomizationsChanged(
                  customizations.copyWith(
                    expandedPanelBorderRadius:
                        style.expandedPanelBorderRadius == 0
                        ? layout.radius.huge
                        : 0,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.borderAllVariant),
              title: const Text('Border'),
              subtitle: Text(style.expandedPanelBorderSide.width.toString()),
              onTap: () {
                onCustomizationsChanged(
                  customizations.copyWith(
                    expandedPanelBorderSide:
                        style.expandedPanelBorderSide.width == 0
                        ? BorderSide(color: theme.colorScheme.outline, width: 1)
                        : BorderSide.none,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.panHorizontal),
              title: const Text('Margin'),
              subtitle: Text(style.expandedPanelMargin.left.toString()),
              onTap: () {
                onCustomizationsChanged(
                  customizations.copyWith(
                    expandedPanelMargin: style.expandedPanelMargin.left == 0
                        ? EdgeInsets.fromLTRB(
                            layout.margin.large,
                            layout.margin.large,
                            layout.margin.large,
                            layout.margin.large,
                          )
                        : EdgeInsets.zero,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.vectorArrangeBelow),
              title: const Text('Barrier color'),
              subtitle: Text(
                style.barrierColor == Colors.black54 ? 'Black' : 'Primary',
              ),
              onTap: () {
                onCustomizationsChanged(
                  customizations.copyWith(
                    barrierColor: style.barrierColor == Colors.black54
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
      ],
    );
  }
}

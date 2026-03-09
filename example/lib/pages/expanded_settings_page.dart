import 'package:example/components/restore_default_style_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class ExpandedSettingsPage extends StatelessWidget {
  const ExpandedSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onStyleChange = context.provide<ValueChanged<PanelFrameStyleData>>();

    final style = PanelFrameStyle.of(context);

    final theme = context.theme;
    final layout = theme.layout;

    return HeaderedList.expand(
      children: [
        ...{
          (title: 'Top bar', leading: Icon(MdiIcons.dockTop)): [
            ListTile(
              leading: Icon(MdiIcons.arrowExpandVertical),
              title: const Text('Height'),
              subtitle: Text(style.topBarExpandedHeight.toString()),
              onTap: () {
                onStyleChange(
                  style.copyWith(
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
                onStyleChange(
                  style.copyWith(
                    computeOpenPanelTopBarOverlap:
                        switch (style.openPanelTopBarOverlap) {
                          0 => (_) => -layout.margin.large,
                          final double v when v == -layout.margin.large =>
                            (_) =>
                                style.expandedPanelMargin(context).top +
                                style.collapsedPanelHeight / 2,
                          _ => (_) => 0,
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
              subtitle: Text(
                style.expandedPanelBorderRadius(context).toString(),
              ),
              onTap: () {
                onStyleChange(
                  style.copyWith(
                    expandedPanelBorderRadius: (_) =>
                        style.expandedPanelBorderRadius(context) == 0
                        ? layout.radius.huge
                        : 0,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.borderAllVariant),
              title: const Text('Border'),
              subtitle: Text(
                style.expandedPanelBorderSide(context).width.toString(),
              ),
              onTap: () {
                onStyleChange(
                  style.copyWith(
                    expandedPanelBorderSide:
                        style.expandedPanelBorderSide(context).width == 0
                        ? (_) => BorderSide(
                            color: theme.colorScheme.outline,
                            width: 1,
                          )
                        : (_) => BorderSide.none,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.panHorizontal),
              title: const Text('Margin'),
              subtitle: Text(
                style.expandedPanelMargin(context).left.toString(),
              ),
              onTap: () {
                onStyleChange(
                  style.copyWith(
                    expandedPanelMargin: (_) =>
                        style.expandedPanelMargin(context).left == 0
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
                onStyleChange(
                  style.copyWith(
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

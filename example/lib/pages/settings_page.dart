import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onStyleChange = context.provide<ValueChanged<PanelFrameStyleData>>();

    final style = PanelFrameStyle.of(context);

    final theme = context.theme;
    final layout = theme.layout;

    return ListView(
      children: {
        (title: 'Panel style', leading: Icon(Icons.fullscreen)): [
          ListTile(
            leading: Icon(MdiIcons.borderRadius),
            title: Text('Collapsed panel height'),
            trailing: Text(style.collapsedPanelHeight.toString()),
            onTap: () {
              onStyleChange(
                style.copyWith(
                  collapsedPanelHeight: switch (style.collapsedPanelHeight) {
                    56 => 64,
                    64 => 72,
                    _ => 56,
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.borderRadius),
            title: Text('Collapsed panel radius'),
            trailing: Text(
              style.collapsedPanelBorderRadius(context).toString(),
            ),
            onTap: () {
              onStyleChange(
                style.copyWith(
                  collapsedPanelBorderRadius: (_) =>
                      style.collapsedPanelBorderRadius(context) ==
                          style.collapsedPanelHeight / 2
                      ? layout.radius.medium
                      : style.collapsedPanelHeight / 2,
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.borderRadius),
            title: Text('Expanded panel radius'),
            trailing: Text(style.expandedPanelBorderRadius(context).toString()),
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
            leading: Icon(MdiIcons.panHorizontal),
            title: Text('Expanded panel margin'),
            trailing: Text(style.expandedPanelMargin(context).left.toString()),
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
            leading: Icon(MdiIcons.panVertical),
            title: Text('panel / app bar overlap'),
            trailing: Text(style.openPanelTopBarOverlap.toString()),
            onTap: () {
              onStyleChange(
                style.copyWith(
                  computeOpenPanelTopBarOverlap: switch (style
                      .openPanelTopBarOverlap) {
                    final double over
                        when style.collapsedPanelHeight / 2 == over =>
                      (_) => 0,
                    0 => (_) => -layout.margin.large,
                    _ =>
                      PanelFrameStyleData.defaultComputeOpenPanelTopBarOverlap,
                  },
                ),
              );
            },
          ),
        ],
      }.groupedCards(),
    );
  }
}

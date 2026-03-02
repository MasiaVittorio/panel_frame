import 'package:example/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:segmented_slider/segmented_slider.dart';
import 'package:sid_base/sid_base.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final onStyleChange = context.provide<ValueChanged<PanelFrameStyle>>();

    final style = context.panelFrameStyle;

    final theme = context.theme;
    final layout = theme.layout;

    return ListView(
      children: [
        SectionTitle(
          title: Text('Theme'),
          leading: Icon(Icons.palette_outlined),
        ),
        ThemeSwitch(),
        SectionTitle(
          title: Text('Panel style'),
          leading: Icon(Icons.fullscreen),
        ),
        ...[
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
                    _ => PanelFrameStyle.defaultComputeOpenPanelTopBarOverlap,
                  },
                ),
              );
            },
          ),
        ].groupedCards(),
      ],
    );
  }
}

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeLogic = context.themeLogic;

    return themeLogic.themeMode.build(
      (context, value) => SegmentedSlider(
        segments: [
          for (final mode in [
            ThemeMode.light,
            ThemeMode.system,
            ThemeMode.dark,
          ])
            SliderSegment(
              value: mode,
              label: Text(mode.name),
              selectedIcon: Icon(mode.icon),
            ),
        ],
        onSelect: (value) => themeLogic.themeMode.update(value!),
        allowDeselectOnTap: false,
        value: value,
      ),
    );
  }
}

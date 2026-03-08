import 'package:example/components/restore_default_style_tile.dart';
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
      children:
          {
            (
              title: 'Collapsed panel',
              leading: Icon(MdiIcons.unfoldLessHorizontal),
            ): [
              ListTile(
                leading: Icon(MdiIcons.arrowExpandVertical),
                title: const Text('Panel height'),
                subtitle: Text(style.collapsedPanelHeight.toString()),
                onTap: () {
                  final previousRadius = style.collapsedPanelBorderRadius(
                    context,
                  );
                  final bool wasRounded =
                      previousRadius >= style.collapsedPanelHeight / 2;
                  final double newHeight = switch (style.collapsedPanelHeight) {
                    56 => 64,
                    64 => 72,
                    _ => 56,
                  };
                  onStyleChange(
                    style.copyWith(
                      collapsedPanelHeight: newHeight,
                      collapsedPanelBorderRadius: wasRounded
                          ? (_) => newHeight / 2
                          : null,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(MdiIcons.borderRadius),
                title: const Text('Border radius'),
                subtitle: Text(
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
                leading: Icon(MdiIcons.borderAllVariant),
                title: const Text('Border'),
                subtitle: Text(
                  style.collapsedPanelBorderSide(context).width.toString(),
                ),
                onTap: () {
                  onStyleChange(
                    style.copyWith(
                      collapsedPanelBorderSide:
                          style.collapsedPanelBorderSide(context).width == 0
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
                  style.collapsedPanelHorizontalMargin(context).toString(),
                ),
                onTap: () {
                  onStyleChange(
                    style.copyWith(
                      collapsedPanelHorizontalMargin: (_) =>
                          style.collapsedPanelHorizontalMargin(context) ==
                              layout.margin.large
                          ? layout.margin.small
                          : layout.margin.large,
                    ),
                  );
                },
              ),
            ],
          }.groupedCards()..addAll(
            [const RestoreDefaultStyleTile()].groupedCards(),
          ),
    );
  }
}

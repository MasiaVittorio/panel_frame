import 'package:example/components/restore_default_style_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onCustomizationsChanged = context
        .provide<ValueChanged<PanelFrameStyleCustomizations>>();

    final style = PanelFrameStyle.of(context);

    final theme = context.theme;
    final layout = theme.layout;

    final customizations = context.provide<PanelFrameStyleCustomizations>();

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
                  final previousRadius = style.collapsedPanelBorderRadius;
                  final bool wasRounded =
                      previousRadius >= style.collapsedPanelHeight / 2;
                  final double newHeight = switch (style.collapsedPanelHeight) {
                    56 => 64,
                    64 => 72,
                    _ => 56,
                  };
                  onCustomizationsChanged(
                    customizations.copyWith(
                      collapsedPanelHeight: newHeight,
                      collapsedPanelBorderRadius: wasRounded
                          ? newHeight / 2
                          : null,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(MdiIcons.borderRadius),
                title: const Text('Border radius'),
                subtitle: Text(style.collapsedPanelBorderRadius.toString()),
                onTap: () {
                  onCustomizationsChanged(
                    customizations.copyWith(
                      collapsedPanelBorderRadius:
                          style.collapsedPanelBorderRadius ==
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
                subtitle: Text(style.collapsedPanelBorderSide.width.toString()),
                onTap: () {
                  onCustomizationsChanged(
                    customizations.copyWith(
                      collapsedPanelBorderSide:
                          style.collapsedPanelBorderSide.width == 0
                          ? BorderSide(
                              color: theme.colorScheme.outline,
                              width: 1,
                            )
                          : BorderSide.none,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(MdiIcons.panHorizontal),
                title: const Text('Margin'),
                subtitle: Text(style.collapsedPanelHorizontalMargin.toString()),
                onTap: () {
                  onCustomizationsChanged(
                    customizations.copyWith(
                      collapsedPanelHorizontalMargin:
                          {
                            layout.margin.small: layout.margin.medium,
                            layout.margin.medium: layout.margin.large,
                            layout.margin.large: layout.margin.huge,
                            layout.margin.huge: layout.margin.small,
                          }[style.collapsedPanelHorizontalMargin] ??
                          layout.margin.medium,
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

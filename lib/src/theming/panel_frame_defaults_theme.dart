part of '../../panel_frame.dart';

/// class for the dev to extend and customize. fills in any style properties not
/// specified by the user in [PanelFrameStyleCustomizations] with defaults in
/// order to compose the resolved style in [PanelFrameStyleData].
class PanelFrameDefaultsThemeData {
  const PanelFrameDefaultsThemeData();

  BorderSide collapsedPanelBorderSide(BuildContext context, ThemeData theme) =>
      BorderSide.none;

  BorderSide expandedPanelBorderSide(BuildContext context, ThemeData theme) =>
      BorderSide.none;

  double collapsedPanelBorderRadius(BuildContext context, ThemeData theme) =>
      theme.layout.radius.large;

  double expandedPanelBorderRadius(BuildContext context, ThemeData theme) =>
      context.theme.layout.radius.small;

  EdgeInsets expandedPanelMargin(BuildContext context, ThemeData theme) {
    final s = theme.layout.margin.small;
    return EdgeInsets.fromLTRB(s, 0, s, s);
  }

  /// only left and right are important, bottom will be added based on the bottom bar height since the PanelFrame widget will only accept a PreferredSizeWidget there
  double collapsedPanelHorizontalMargin(
    BuildContext context,
    ThemeData theme,
  ) => theme.layout.margin.large;
  Color scaffoldBackgroundColor(BuildContext context, ThemeData theme) =>
      theme.colorScheme.surface;

  Color headerColor(BuildContext context, ThemeData theme) =>
      theme.colorScheme.surface.withValues(alpha: 0.5);

  Color collapsedPanelBackgroundColor(BuildContext context, ThemeData theme) =>
      theme.colorScheme.surfaceContainer;

  Color expandedPanelBackgroundColor(BuildContext context, ThemeData theme) =>
      theme.colorScheme.surface;

  Color topBarCollapsedBackgroundColor(BuildContext context, ThemeData theme) =>
      theme.colorScheme.surface;

  Color topBarExpandedBackgroundColor(BuildContext context, ThemeData theme) =>
      theme.colorScheme.surface;

  double openPanelTopBarOverlap(
    BuildContext context,
    ThemeData theme,
    PanelFrameStyleCustomizations style,
  ) {
    final double halfCollapsedHeight = style.collapsedPanelHeight / 2;
    if (style.topBarExpandedHeight > halfCollapsedHeight) {
      return halfCollapsedHeight;
    } else {
      return 0;
    }
  }
}

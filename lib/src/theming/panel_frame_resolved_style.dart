part of '../../panel_frame.dart';

/// resolved class that is composed of customizations and evaluated defaults.
/// used both internally in panel frame to build the actual layouts and by the user to consume information via [PanelFrameStyle]'s of(context) method.
class PanelFrameStyleData {
  final Duration duration;
  final Curve curve;

  final double collapsedPanelHeight;
  final BorderSide collapsedPanelBorderSide;
  final BorderSide expandedPanelBorderSide;
  final double collapsedPanelBorderRadius;
  final double expandedPanelBorderRadius;
  final EdgeInsets expandedPanelMargin;
  final double collapsedPanelHorizontalMargin;

  final double topBarCollapsedHeight;
  final double topBarExpandedHeight;
  final double bodyParallaxOffset;
  final bool fullScreenExpandedPanel;

  final bool showDragHandleInHeaders;

  final double collapsedElevation;
  final double expandedElevation;
  final Color scaffoldBackgroundColor;
  final Color headerColor;
  final Color barrierColor;
  final bool dismissOnBarrierTap;

  final Color collapsedPanelBackgroundColor;
  final Color expandedPanelBackgroundColor;
  final Color topBarCollapsedBackgroundColor;
  final Color topBarExpandedBackgroundColor;

  final double expandedPanelParallax;
  final double collapsedPanelParallax;

  /// 1= the body moves up a whole body height while the panel is expanded, 0 = the body doesn't move at all
  final double bodyParallaxMultiplier;

  final double openPanelTopBarOverlap;

  final BoxConstraints constraints;

  double justExpandedPanelTopMargin(EdgeInsets safe) =>
      safe.top + topBarExpandedHeight - openPanelTopBarOverlap;

  // TODO: move all the size computations here

  PanelFrameStyleData._({
    required this.duration,
    required this.curve,
    required this.collapsedPanelHeight,
    required this.collapsedPanelBorderSide,
    required this.expandedPanelBorderSide,
    required this.collapsedPanelBorderRadius,
    required this.expandedPanelBorderRadius,
    required this.expandedPanelMargin,
    required this.collapsedPanelHorizontalMargin,
    required this.topBarCollapsedHeight,
    required this.topBarExpandedHeight,
    required this.bodyParallaxOffset,
    required this.fullScreenExpandedPanel,
    required this.showDragHandleInHeaders,
    required this.collapsedElevation,
    required this.expandedElevation,
    required this.scaffoldBackgroundColor,
    required this.headerColor,
    required this.barrierColor,
    required this.dismissOnBarrierTap,
    required this.collapsedPanelBackgroundColor,
    required this.expandedPanelBackgroundColor,
    required this.topBarCollapsedBackgroundColor,
    required this.topBarExpandedBackgroundColor,
    required this.expandedPanelParallax,
    required this.collapsedPanelParallax,
    required this.bodyParallaxMultiplier,
    required this.openPanelTopBarOverlap,
    required this.constraints,
  });

  static PanelFrameStyleData _from({
    required ThemeData theme,
    required BuildContext context,
    required PanelFrameStyleCustomizations customizations,
    required PanelFrameDefaultsThemeData defaults,
    required BoxConstraints constraints,
  }) {
    return PanelFrameStyleData._(
      constraints: constraints,
      duration: customizations.duration,
      curve: customizations.curve,
      collapsedPanelHeight: customizations.collapsedPanelHeight,
      collapsedPanelBorderSide:
          customizations.collapsedPanelBorderSide ??
          defaults.collapsedPanelBorderSide(context, theme),
      expandedPanelBorderSide:
          customizations.expandedPanelBorderSide ??
          defaults.expandedPanelBorderSide(context, theme),
      collapsedPanelBorderRadius:
          customizations.collapsedPanelBorderRadius ??
          defaults.collapsedPanelBorderRadius(context, theme),
      expandedPanelBorderRadius:
          customizations.expandedPanelBorderRadius ??
          defaults.expandedPanelBorderRadius(context, theme),
      expandedPanelMargin:
          customizations.expandedPanelMargin ??
          defaults.expandedPanelMargin(context, theme),
      scaffoldBackgroundColor:
          customizations.scaffoldBackgroundColor ??
          defaults.scaffoldBackgroundColor(context, theme),
      headerColor:
          customizations.headerColor ?? defaults.headerColor(context, theme),
      collapsedPanelBackgroundColor:
          customizations.collapsedPanelBackgroundColor ??
          defaults.collapsedPanelBackgroundColor(context, theme),
      expandedPanelBackgroundColor:
          customizations.expandedPanelBackgroundColor ??
          defaults.expandedPanelBackgroundColor(context, theme),
      topBarCollapsedBackgroundColor:
          customizations.topBarCollapsedBackgroundColor ??
          defaults.topBarCollapsedBackgroundColor(context, theme),
      topBarExpandedBackgroundColor:
          customizations.topBarExpandedBackgroundColor ??
          defaults.topBarExpandedBackgroundColor(context, theme),
      collapsedPanelHorizontalMargin:
          customizations.collapsedPanelHorizontalMargin ??
          defaults.collapsedPanelHorizontalMargin(context, theme),
      topBarCollapsedHeight: customizations.topBarCollapsedHeight,
      topBarExpandedHeight: customizations.topBarExpandedHeight,
      bodyParallaxOffset: customizations.bodyParallaxOffset,
      fullScreenExpandedPanel: customizations.fullScreenExpandedPanel,
      showDragHandleInHeaders: customizations.showDragHandleInHeaders,
      collapsedElevation: customizations.collapsedElevation,
      expandedElevation: customizations.expandedElevation,
      barrierColor: customizations.barrierColor,
      dismissOnBarrierTap: customizations.dismissOnBarrierTap,
      expandedPanelParallax: customizations.expandedPanelParallax,
      collapsedPanelParallax: customizations.collapsedPanelParallax,
      bodyParallaxMultiplier: customizations.bodyParallaxMultiplier,
      openPanelTopBarOverlap:
          customizations.openPanelTopBarOverlap ??
          defaults.openPanelTopBarOverlap(context, theme, customizations),
    );
  }

  @override
  bool operator ==(covariant PanelFrameStyleData other) {
    if (identical(this, other)) return true;

    return other.duration == duration &&
        other.curve == curve &&
        other.collapsedPanelHeight == collapsedPanelHeight &&
        other.collapsedPanelBorderSide == collapsedPanelBorderSide &&
        other.expandedPanelBorderSide == expandedPanelBorderSide &&
        other.collapsedPanelBorderRadius == collapsedPanelBorderRadius &&
        other.expandedPanelBorderRadius == expandedPanelBorderRadius &&
        other.expandedPanelMargin == expandedPanelMargin &&
        other.collapsedPanelHorizontalMargin ==
            collapsedPanelHorizontalMargin &&
        other.topBarCollapsedHeight == topBarCollapsedHeight &&
        other.topBarExpandedHeight == topBarExpandedHeight &&
        other.bodyParallaxOffset == bodyParallaxOffset &&
        other.fullScreenExpandedPanel == fullScreenExpandedPanel &&
        other.showDragHandleInHeaders == showDragHandleInHeaders &&
        other.collapsedElevation == collapsedElevation &&
        other.expandedElevation == expandedElevation &&
        other.scaffoldBackgroundColor == scaffoldBackgroundColor &&
        other.headerColor == headerColor &&
        other.barrierColor == barrierColor &&
        other.dismissOnBarrierTap == dismissOnBarrierTap &&
        other.collapsedPanelBackgroundColor == collapsedPanelBackgroundColor &&
        other.expandedPanelBackgroundColor == expandedPanelBackgroundColor &&
        other.topBarCollapsedBackgroundColor ==
            topBarCollapsedBackgroundColor &&
        other.topBarExpandedBackgroundColor == topBarExpandedBackgroundColor &&
        other.expandedPanelParallax == expandedPanelParallax &&
        other.collapsedPanelParallax == collapsedPanelParallax &&
        other.bodyParallaxMultiplier == bodyParallaxMultiplier &&
        other.openPanelTopBarOverlap == openPanelTopBarOverlap &&
        other.constraints == constraints;
  }

  @override
  int get hashCode {
    return duration.hashCode ^
        curve.hashCode ^
        collapsedPanelHeight.hashCode ^
        collapsedPanelBorderSide.hashCode ^
        expandedPanelBorderSide.hashCode ^
        collapsedPanelBorderRadius.hashCode ^
        expandedPanelBorderRadius.hashCode ^
        expandedPanelMargin.hashCode ^
        collapsedPanelHorizontalMargin.hashCode ^
        topBarCollapsedHeight.hashCode ^
        topBarExpandedHeight.hashCode ^
        bodyParallaxOffset.hashCode ^
        fullScreenExpandedPanel.hashCode ^
        showDragHandleInHeaders.hashCode ^
        collapsedElevation.hashCode ^
        expandedElevation.hashCode ^
        scaffoldBackgroundColor.hashCode ^
        headerColor.hashCode ^
        barrierColor.hashCode ^
        dismissOnBarrierTap.hashCode ^
        collapsedPanelBackgroundColor.hashCode ^
        expandedPanelBackgroundColor.hashCode ^
        topBarCollapsedBackgroundColor.hashCode ^
        topBarExpandedBackgroundColor.hashCode ^
        expandedPanelParallax.hashCode ^
        collapsedPanelParallax.hashCode ^
        bodyParallaxMultiplier.hashCode ^
        openPanelTopBarOverlap.hashCode ^
        constraints.hashCode;
  }
}

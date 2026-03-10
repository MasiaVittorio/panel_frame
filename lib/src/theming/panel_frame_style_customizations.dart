part of '../../panel_frame.dart';

/// class for the app user to customize and provide to [PanelFrame]
class PanelFrameStyleCustomizations {
  final Duration duration;
  final Curve curve;

  final double collapsedPanelHeight;
  final BorderSide? collapsedPanelBorderSide;
  final BorderSide? expandedPanelBorderSide;
  final double? collapsedPanelBorderRadius;
  final double? expandedPanelBorderRadius;
  final EdgeInsets? expandedPanelMargin;
  final double? collapsedPanelHorizontalMargin;

  final double topBarCollapsedHeight;
  final double topBarExpandedHeight;
  final double bodyParallaxOffset;
  final bool fullScreenExpandedPanel;

  final bool showDragHandleInHeaders;

  final double collapsedElevation;
  final double expandedElevation;
  final Color? scaffoldBackgroundColor;
  final Color? headerColor;
  final Color barrierColor;
  final bool dismissOnBarrierTap;

  final Color? collapsedPanelBackgroundColor;
  final Color? expandedPanelBackgroundColor;
  final Color? topBarCollapsedBackgroundColor;
  final Color? topBarExpandedBackgroundColor;

  final double expandedPanelParallax;
  final double collapsedPanelParallax;

  /// 1= the body moves up a whole body height while the panel is expanded, 0 = the body doesn't move at all
  final double bodyParallaxMultiplier;

  final double? openPanelTopBarOverlap;

  const PanelFrameStyleCustomizations({
    this.collapsedPanelHeight = 64,
    this.collapsedPanelHorizontalMargin,
    this.collapsedPanelBorderRadius,
    this.expandedPanelBorderRadius,
    this.collapsedPanelBorderSide,
    this.expandedPanelBorderSide,
    this.expandedPanelMargin,
    this.headerColor,
    this.topBarCollapsedHeight = kToolbarHeight,
    this.topBarExpandedHeight = 96,
    this.bodyParallaxOffset = 64,
    this.fullScreenExpandedPanel = false,
    this.collapsedElevation = 0,
    this.expandedElevation = 0,
    this.bodyParallaxMultiplier = 0.2,
    this.barrierColor = Colors.black54,
    this.dismissOnBarrierTap = true,
    this.collapsedPanelParallax = 0.3,
    this.expandedPanelParallax = 0.1,
    this.collapsedPanelBackgroundColor,
    this.expandedPanelBackgroundColor,
    this.topBarCollapsedBackgroundColor,
    this.topBarExpandedBackgroundColor,
    this.scaffoldBackgroundColor,
    this.duration = Durations.medium4,
    this.curve = Easings.emphasized,
    this.showDragHandleInHeaders = true,
    this.openPanelTopBarOverlap,
  });

  PanelFrameStyleCustomizations copyWith({
    Duration? duration,
    Curve? curve,
    double? collapsedPanelHeight,
    double? collapsedPanelBorderRadius,
    double? expandedPanelBorderRadius,
    EdgeInsets? expandedPanelMargin,
    double? collapsedPanelHorizontalMargin,
    double? topBarCollapsedHeight,
    double? topBarExpandedHeight,
    double? bodyParallaxOffset,
    bool? fullScreenExpandedPanel,
    bool? showDragHandleInHeaders,
    double? collapsedElevation,
    double? expandedElevation,
    Color? scaffoldBackgroundColor,
    Color? headerColor,
    Color? barrierColor,
    bool? dismissOnBarrierTap,
    Color? collapsedPanelBackgroundColor,
    Color? expandedPanelBackgroundColor,
    Color? topBarCollapsedBackgroundColor,
    Color? topBarExpandedBackgroundColor,
    double? expandedPanelParallax,
    double? collapsedPanelParallax,
    double? bodyParallaxMultiplier,
    BorderSide? collapsedPanelBorderSide,
    BorderSide? expandedPanelBorderSide,
    double? openPanelTopBarOverlap,
  }) {
    return PanelFrameStyleCustomizations(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      collapsedPanelHeight: collapsedPanelHeight ?? this.collapsedPanelHeight,
      collapsedPanelBorderRadius:
          collapsedPanelBorderRadius ?? this.collapsedPanelBorderRadius,
      expandedPanelBorderRadius:
          expandedPanelBorderRadius ?? this.expandedPanelBorderRadius,
      expandedPanelMargin: expandedPanelMargin ?? this.expandedPanelMargin,
      collapsedPanelHorizontalMargin:
          collapsedPanelHorizontalMargin ?? this.collapsedPanelHorizontalMargin,
      topBarCollapsedHeight:
          topBarCollapsedHeight ?? this.topBarCollapsedHeight,
      topBarExpandedHeight: topBarExpandedHeight ?? this.topBarExpandedHeight,
      bodyParallaxOffset: bodyParallaxOffset ?? this.bodyParallaxOffset,
      fullScreenExpandedPanel:
          fullScreenExpandedPanel ?? this.fullScreenExpandedPanel,
      showDragHandleInHeaders:
          showDragHandleInHeaders ?? this.showDragHandleInHeaders,
      collapsedElevation: collapsedElevation ?? this.collapsedElevation,
      expandedElevation: expandedElevation ?? this.expandedElevation,
      scaffoldBackgroundColor:
          scaffoldBackgroundColor ?? this.scaffoldBackgroundColor,
      headerColor: headerColor ?? this.headerColor,
      barrierColor: barrierColor ?? this.barrierColor,
      dismissOnBarrierTap: dismissOnBarrierTap ?? this.dismissOnBarrierTap,
      collapsedPanelBackgroundColor:
          collapsedPanelBackgroundColor ?? this.collapsedPanelBackgroundColor,
      expandedPanelBackgroundColor:
          expandedPanelBackgroundColor ?? this.expandedPanelBackgroundColor,
      topBarCollapsedBackgroundColor:
          topBarCollapsedBackgroundColor ?? this.topBarCollapsedBackgroundColor,
      topBarExpandedBackgroundColor:
          topBarExpandedBackgroundColor ?? this.topBarExpandedBackgroundColor,
      openPanelTopBarOverlap:
          openPanelTopBarOverlap ?? this.openPanelTopBarOverlap,
      expandedPanelParallax:
          expandedPanelParallax ?? this.expandedPanelParallax,
      collapsedPanelParallax:
          collapsedPanelParallax ?? this.collapsedPanelParallax,
      bodyParallaxMultiplier:
          bodyParallaxMultiplier ?? this.bodyParallaxMultiplier,
      collapsedPanelBorderSide:
          collapsedPanelBorderSide ?? this.collapsedPanelBorderSide,
      expandedPanelBorderSide:
          expandedPanelBorderSide ?? this.expandedPanelBorderSide,
    );
  }
}

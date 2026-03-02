// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../panel_frame.dart';

class PanelFrameStyle {
  final Duration duration;
  final Curve curve;

  final double collapsedPanelHeight;
  final BorderSide Function(BuildContext context) collapsedPanelBorderSide;
  final BorderSide Function(BuildContext context) expandedPanelBorderSide;
  final double Function(BuildContext context) collapsedPanelBorderRadius;
  final double Function(BuildContext context) expandedPanelBorderRadius;
  final EdgeInsets Function(BuildContext context) expandedPanelMargin;
  final double Function(BuildContext context) collapsedPanelHorizontalMargin;

  final double topBarCollapsedHeight;
  final double topBarExpandedHeight;
  final double bodyParallaxOffset;
  final bool fullScreenExpandedPanel;

  final bool showDragHandleInHeaders;

  final double collapsedElevation;
  final double expandedElevation;
  final Color Function(BuildContext context) scaffoldBackgroundColor;
  final Color Function(BuildContext context) headerColor;
  final Color barrierColor;
  final bool dismissOnBarrierTap;

  final Color Function(BuildContext context) collapsedPanelBackgroundColor;
  final Color Function(BuildContext context) expandedPanelBackgroundColor;
  final Color Function(BuildContext context) topBarCollapsedBackgroundColor;
  final Color Function(BuildContext context) topBarExpandedBackgroundColor;

  final double Function(double? desiredOverlap) computeOpenPanelTopBarOverlap;

  final double expandedPanelParallax;
  final double collapsedPanelParallax;

  /// 1= the body moves up a whole body height while the panel is expanded, 0 = the body doesn't move at all
  final double bodyParallaxMultiplier;

  static const defaultStyle = PanelFrameStyle(collapsedPanelHeight: 64);

  const PanelFrameStyle({
    required this.collapsedPanelHeight,
    this.collapsedPanelHorizontalMargin = defaultCollapsedPanelHorizontalMargin,
    this.collapsedPanelBorderRadius = defaultCollapsedPanelBorderRadius,
    this.expandedPanelBorderRadius = defaultExpandedPanelBorderRadius,
    this.collapsedPanelBorderSide = defaultCollapsedPanelBorderSide,
    this.expandedPanelBorderSide = defaultExpandedPanelBorderSide,
    this.expandedPanelMargin = defaultExpandedPanelMargin,
    this.headerColor = defaultHeaderColor,
    this.topBarCollapsedHeight = kToolbarHeight,
    this.topBarExpandedHeight = 120,
    this.bodyParallaxOffset = 64,
    this.fullScreenExpandedPanel = false,
    this.collapsedElevation = 0,
    this.expandedElevation = 0,
    this.bodyParallaxMultiplier = 0.2,
    this.barrierColor = Colors.black54,
    this.dismissOnBarrierTap = true,
    this.collapsedPanelParallax = 0.3,
    this.expandedPanelParallax = 0.1,
    this.collapsedPanelBackgroundColor = defaultCollapsedPanelBackgroundColor,
    this.expandedPanelBackgroundColor = defaultExpandedPanelBackgroundColor,
    this.topBarCollapsedBackgroundColor = defaultTopBarCollapsedBackgroundColor,
    this.topBarExpandedBackgroundColor = defaultTopBarExpandedBackgroundColor,
    this.scaffoldBackgroundColor = defaultScaffoldBackgroundColor,
    this.computeOpenPanelTopBarOverlap = defaultComputeOpenPanelTopBarOverlap,
    this.duration = Durations.medium3,
    this.curve = Easings.emphasized,
    this.showDragHandleInHeaders = true,
  });

  static double defaultComputeOpenPanelTopBarOverlap(double? desiredOverlap) =>
      desiredOverlap ?? 0;

  double get openPanelTopBarOverlap => computeOpenPanelTopBarOverlap(
    topBarExpandedHeight > collapsedPanelHeight / 2
        ? collapsedPanelHeight / 2
        : 0,
  );

  double justExpandedPanelTopMargin(EdgeInsets safe) {
    return safe.top + topBarExpandedHeight - openPanelTopBarOverlap;
  }

  static BorderSide defaultCollapsedPanelBorderSide(BuildContext context) =>
      BorderSide.none;

  static BorderSide defaultExpandedPanelBorderSide(BuildContext context) =>
      BorderSide.none;

  static double defaultCollapsedPanelBorderRadius(BuildContext context) =>
      context.theme.layout.radius.large;

  static double defaultExpandedPanelBorderRadius(BuildContext context) =>
      context.theme.layout.radius.small;

  /// only left and right are important, bottom will be added based on the bottom bar height since the PanelFrame widget will only accept a PreferredSizeWidget there
  static double defaultCollapsedPanelHorizontalMargin(BuildContext context) =>
      context.theme.layout.margin.large;

  static EdgeInsets defaultExpandedPanelMargin(BuildContext context) {
    final s = context.theme.layout.margin.small;
    return EdgeInsets.fromLTRB(s, 0, s, s);
  }

  static Color defaultCollapsedPanelBackgroundColor(BuildContext context) =>
      context.theme.colorScheme.surfaceContainerHigh;

  static Color defaultExpandedPanelBackgroundColor(BuildContext context) =>
      context.theme.colorScheme.surface;
  static Color defaultHeaderColor(BuildContext context) =>
      context.theme.colorScheme.surface.withValues(alpha: 0.5);

  static Color defaultTopBarCollapsedBackgroundColor(BuildContext context) =>
      context.theme.colorScheme.surface;

  static Color defaultTopBarExpandedBackgroundColor(BuildContext context) =>
      context.theme.colorScheme.surface;

  static Color defaultScaffoldBackgroundColor(BuildContext context) =>
      context.theme.colorScheme.surface;

  PanelFrameStyle copyWith({
    Duration? duration,
    Curve? curve,
    double? collapsedPanelHeight,
    double Function(BuildContext context)? collapsedPanelBorderRadius,
    double Function(BuildContext context)? expandedPanelBorderRadius,
    EdgeInsets Function(BuildContext context)? expandedPanelMargin,
    double Function(BuildContext context)? collapsedPanelHorizontalMargin,
    double? topBarCollapsedHeight,
    double? topBarExpandedHeight,
    double? bodyParallaxOffset,
    bool? fullScreenExpandedPanel,
    bool? showDragHandleInHeaders,
    double? collapsedElevation,
    double? expandedElevation,
    Color Function(BuildContext context)? scaffoldBackgroundColor,
    Color Function(BuildContext context)? headerColor,
    Color? barrierColor,
    bool? dismissOnBarrierTap,
    Color Function(BuildContext context)? collapsedPanelBackgroundColor,
    Color Function(BuildContext context)? expandedPanelBackgroundColor,
    Color Function(BuildContext context)? topBarCollapsedBackgroundColor,
    Color Function(BuildContext context)? topBarExpandedBackgroundColor,
    double Function(double? desiredOverlap)? computeOpenPanelTopBarOverlap,
    double? expandedPanelParallax,
    double? collapsedPanelParallax,
    double? bodyParallaxMultiplier,
    BorderSide Function(BuildContext context)? collapsedPanelBorderSide,
    BorderSide Function(BuildContext context)? expandedPanelBorderSide,
  }) {
    return PanelFrameStyle(
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
      computeOpenPanelTopBarOverlap:
          computeOpenPanelTopBarOverlap ?? this.computeOpenPanelTopBarOverlap,
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

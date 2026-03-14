// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../../panel_frame.dart';

/// class for the app user to customize and provide to [PanelFrame]
class PanelFrameStyleCustomizations {
  final Duration duration;
  final Curve curve;

  final double collapsedPanelHeight;

  final BorderSide? collapsedPanelBorderSide;
  final BorderSide? expandedPanelBorderSide;
  final BorderSide? alertsBorderSide;

  final double? collapsedPanelBorderRadius;
  final double? expandedPanelBorderRadius;
  final double? alertsBorderRadius;

  final double? collapsedPanelHorizontalMargin;
  final EdgeInsets? expandedPanelMargin;
  final EdgeInsets? alertsMargin;

  final double? openPanelTopBarOverlap;

  /// only applied if the expanded panel margins are all zero, otherwise the safe areas are added around the expanded panel margins
  final bool expandedPanelCanCoverViewPadding;

  /// only applied if alerts margins are all zero (alerts margin can vary between alerts if specified in the [PanelAlert] mixin)
  final bool alertsCanCoverViewPadding;

  final double topBarCollapsedHeight;
  final double topBarExpandedHeight;

  final bool showDragHandleInHeaders;

  final List<BoxShadow>? collapsedShadows;
  final List<BoxShadow>? expandedShadows;
  final List<BoxShadow>? alertsShadows;

  final Color? scaffoldBackgroundColor;
  final Color? headerColor;
  final Color barrierColor;
  final Color? collapsedPanelBackgroundColor;
  final Color? expandedPanelBackgroundColor;
  final Color? alertsBackgroundColor;
  final Color? topBarCollapsedBackgroundColor;
  final Color? topBarExpandedBackgroundColor;

  final bool dismissOnBarrierTap;

  final double expandedPanelParallax;
  final double collapsedPanelParallax;
  final double bodyParallax;

  const PanelFrameStyleCustomizations({
    this.collapsedPanelHeight = 64,
    this.collapsedPanelHorizontalMargin,
    this.collapsedPanelBorderRadius,
    this.expandedPanelBorderRadius,
    this.alertsBorderRadius,
    this.collapsedPanelBorderSide,
    this.expandedPanelBorderSide,
    this.expandedPanelMargin,
    this.headerColor,
    this.topBarCollapsedHeight = kToolbarHeight,
    this.topBarExpandedHeight = 96,
    this.alertsCanCoverViewPadding = true,
    this.expandedPanelCanCoverViewPadding = true,
    this.collapsedShadows,
    this.alertsShadows,
    this.expandedShadows,
    this.barrierColor = Colors.black54,
    this.dismissOnBarrierTap = true,
    this.bodyParallax = 0.2,
    this.collapsedPanelParallax = 0.3,
    this.expandedPanelParallax = 0.1,
    this.collapsedPanelBackgroundColor,
    this.expandedPanelBackgroundColor,
    this.alertsBackgroundColor,
    this.topBarCollapsedBackgroundColor,
    this.topBarExpandedBackgroundColor,
    this.scaffoldBackgroundColor,
    this.duration = Durations.medium4,
    this.curve = Easings.emphasized,
    this.showDragHandleInHeaders = true,
    this.openPanelTopBarOverlap,
    this.alertsBorderSide,
    this.alertsMargin,
  });

  PanelFrameStyleCustomizations copyWith({
    Duration? duration,
    Curve? curve,
    double? collapsedPanelHeight,
    BorderSide? collapsedPanelBorderSide,
    BorderSide? expandedPanelBorderSide,
    BorderSide? alertsBorderSide,
    double? collapsedPanelBorderRadius,
    double? expandedPanelBorderRadius,
    double? alertsBorderRadius,
    double? collapsedPanelHorizontalMargin,
    EdgeInsets? expandedPanelMargin,
    EdgeInsets? alertsMargin,
    double? openPanelTopBarOverlap,
    bool? expandedPanelCanCoverViewPadding,
    bool? alertsCanCoverViewPadding,
    double? topBarCollapsedHeight,
    double? topBarExpandedHeight,
    bool? showDragHandleInHeaders,
    List<BoxShadow>? collapsedShadows,
    List<BoxShadow>? expandedShadows,
    List<BoxShadow>? alertsShadows,
    Color? scaffoldBackgroundColor,
    Color? headerColor,
    Color? barrierColor,
    Color? collapsedPanelBackgroundColor,
    Color? expandedPanelBackgroundColor,
    Color? alertsBackgroundColor,
    Color? topBarCollapsedBackgroundColor,
    Color? topBarExpandedBackgroundColor,
    bool? dismissOnBarrierTap,
    double? expandedPanelParallax,
    double? collapsedPanelParallax,
    double? bodyParallax,
  }) {
    return PanelFrameStyleCustomizations(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      collapsedPanelHeight: collapsedPanelHeight ?? this.collapsedPanelHeight,
      collapsedPanelBorderSide:
          collapsedPanelBorderSide ?? this.collapsedPanelBorderSide,
      expandedPanelBorderSide:
          expandedPanelBorderSide ?? this.expandedPanelBorderSide,
      alertsBorderSide: alertsBorderSide ?? this.alertsBorderSide,
      collapsedPanelBorderRadius:
          collapsedPanelBorderRadius ?? this.collapsedPanelBorderRadius,
      expandedPanelBorderRadius:
          expandedPanelBorderRadius ?? this.expandedPanelBorderRadius,
      alertsBorderRadius: alertsBorderRadius ?? this.alertsBorderRadius,
      collapsedPanelHorizontalMargin:
          collapsedPanelHorizontalMargin ?? this.collapsedPanelHorizontalMargin,
      expandedPanelMargin: expandedPanelMargin ?? this.expandedPanelMargin,
      alertsMargin: alertsMargin ?? this.alertsMargin,
      openPanelTopBarOverlap:
          openPanelTopBarOverlap ?? this.openPanelTopBarOverlap,
      expandedPanelCanCoverViewPadding:
          expandedPanelCanCoverViewPadding ??
          this.expandedPanelCanCoverViewPadding,
      alertsCanCoverViewPadding:
          alertsCanCoverViewPadding ?? this.alertsCanCoverViewPadding,
      topBarCollapsedHeight:
          topBarCollapsedHeight ?? this.topBarCollapsedHeight,
      topBarExpandedHeight: topBarExpandedHeight ?? this.topBarExpandedHeight,
      showDragHandleInHeaders:
          showDragHandleInHeaders ?? this.showDragHandleInHeaders,
      collapsedShadows: collapsedShadows ?? this.collapsedShadows,
      expandedShadows: expandedShadows ?? this.expandedShadows,
      alertsShadows: alertsShadows ?? this.alertsShadows,
      scaffoldBackgroundColor:
          scaffoldBackgroundColor ?? this.scaffoldBackgroundColor,
      headerColor: headerColor ?? this.headerColor,
      barrierColor: barrierColor ?? this.barrierColor,
      collapsedPanelBackgroundColor:
          collapsedPanelBackgroundColor ?? this.collapsedPanelBackgroundColor,
      expandedPanelBackgroundColor:
          expandedPanelBackgroundColor ?? this.expandedPanelBackgroundColor,
      alertsBackgroundColor:
          alertsBackgroundColor ?? this.alertsBackgroundColor,
      topBarCollapsedBackgroundColor:
          topBarCollapsedBackgroundColor ?? this.topBarCollapsedBackgroundColor,
      topBarExpandedBackgroundColor:
          topBarExpandedBackgroundColor ?? this.topBarExpandedBackgroundColor,
      dismissOnBarrierTap: dismissOnBarrierTap ?? this.dismissOnBarrierTap,
      expandedPanelParallax:
          expandedPanelParallax ?? this.expandedPanelParallax,
      collapsedPanelParallax:
          collapsedPanelParallax ?? this.collapsedPanelParallax,
      bodyParallax: bodyParallax ?? this.bodyParallax,
    );
  }
}

part of '../../panel_frame.dart';

/// resolved class that is composed of customizations and evaluated defaults.
/// used both internally in panel frame to build the actual layouts and by the user to consume information via [PanelFrameStyle]'s of(context) method.
class PanelFrameStyleData {
  final Duration duration;
  final Curve curve;

  // decoration properties
  final double collapsedPanelBorderRadius;
  final double expandedPanelBorderRadius;
  final double alertsBorderRadius;

  final BorderSide collapsedPanelBorderSide;
  final BorderSide expandedPanelBorderSide;
  final BorderSide alertsBorderSide;

  final List<BoxShadow>? collapsedShadows;
  final List<BoxShadow>? expandedShadows;
  final List<BoxShadow>? alertsShadows;

  final Color bodyBackgroundColor;
  final Color headerColor;
  final Color alertsBarrierColor;
  final Color panelBarrierColor;
  final Color collapsedPanelColor;
  final Color expandedPanelColor;
  final Color alertsColor;
  final Color topBarCollapsedColor;
  final Color topBarExpandedColor;

  // behavior

  final bool showDragHandleInHeaders;
  final bool dismissOnBarrierTap;
  final double expandedPanelParallax;
  final double collapsedPanelParallax;
  final double bodyParallax;

  // sizing

  /// the height of the collapsed panel is fixed during the animation,
  /// and a parallax translation effect is applied on top
  final double collapsedPanelHeight;

  final double topBarCollapsedHeight;
  final double topBarExpandedHeight;

  /// used to precompute the width of the collapsed panel to keep it
  /// static during the animation, in order to avoid text shifting
  final double collapsedPanelHorizontalMargin;

  /// used to precompute the width of the expanded panel to keep it
  /// static during the animation, in order to avoid text shifting
  final EdgeInsets expandedPanelMargin;

  /// used to precompute the width of the expanded panel to keep it
  /// static during the animation, in order to avoid text shifting
  final EdgeInsets alertsMargin;

  final double openPanelTopBarOverlap;

  /// only applied if the margins are zero on the relevant side
  final bool expandedPanelCanCoverViewPadding;

  /// only applied if the margins are zero on the relevant side
  final bool alertsCanCoverViewPadding;

  late final EdgeInsets _viewPadding; // static doesn't change with keyboard
  late final BoxConstraints _constraints; // provided on creation
  late final double _bottomBarHeight; // provided on creation

  // pre-computed derived parameters

  late final double _expandedPanelHeight;
  late final double _expandedPanelInternalBottomSafe;
  late final double _expandedPanelBottomMargin;

  late final double _expandedPanelWidth;

  late final Size _expandedPanelSize;

  late final BoxDecoration _collapsedDecoration;
  late final BoxDecoration _expandedPanelDecoration;
  late final double _collapsedPanelBottomMargin;

  late final Size _collapsedPanelSize;

  PanelFrameStyleData._({
    required this.duration,
    required this.curve,
    required this.collapsedPanelHeight,
    required this.collapsedPanelBorderSide,
    required this.expandedPanelBorderSide,
    required this.alertsBorderSide,
    required this.collapsedPanelBorderRadius,
    required this.expandedPanelBorderRadius,
    required this.alertsBorderRadius,
    required this.collapsedPanelHorizontalMargin,
    required this.expandedPanelMargin,
    required this.alertsMargin,
    required this.openPanelTopBarOverlap,
    required this.expandedPanelCanCoverViewPadding,
    required this.alertsCanCoverViewPadding,
    required this.topBarCollapsedHeight,
    required this.topBarExpandedHeight,
    required this.showDragHandleInHeaders,
    required this.collapsedShadows,
    required this.expandedShadows,
    required this.alertsShadows,
    required this.bodyBackgroundColor,
    required this.headerColor,
    required this.alertsBarrierColor,
    required this.panelBarrierColor,
    required this.collapsedPanelColor,
    required this.expandedPanelColor,
    required this.alertsColor,
    required this.topBarCollapsedColor,
    required this.topBarExpandedColor,
    required this.dismissOnBarrierTap,
    required this.expandedPanelParallax,
    required this.collapsedPanelParallax,
    required this.bodyParallax,
    required BoxConstraints constraints,
    required EdgeInsets viewPadding,
    required double bottomBarHeight,
  }) {
    _constraints = constraints;
    _viewPadding = viewPadding;
    _bottomBarHeight = bottomBarHeight;
    _expandedPanelBottomMargin =
        expandedPanelMargin.bottom +
        (expandedPanelCanCoverViewPadding && expandedPanelMargin.bottom == 0
            ? 0
            : viewPadding.bottom);
    _expandedPanelHeight =
        constraints.maxHeight -
        viewPadding.top -
        topBarExpandedHeight +
        openPanelTopBarOverlap -
        expandedPanelMargin.top -
        _expandedPanelBottomMargin;
    _expandedPanelInternalBottomSafe = _expandedPanelBottomMargin == 0
        ? _viewPadding.bottom
        : 0;

    _expandedPanelWidth =
        _constraints.maxWidth - expandedPanelMargin.horizontal;
    _expandedPanelSize = Size(_expandedPanelWidth, _expandedPanelHeight);

    _collapsedDecoration = BoxDecoration(
      border: Border.fromBorderSide(collapsedPanelBorderSide),
      color: collapsedPanelColor,
      borderRadius: BorderRadius.circular(collapsedPanelBorderRadius),
      boxShadow: collapsedShadows,
    );
    _expandedPanelDecoration = BoxDecoration(
      boxShadow: expandedShadows,
      border: Border.fromBorderSide(expandedPanelBorderSide),
      color: expandedPanelColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(expandedPanelBorderRadius),
        bottom: Radius.circular(switch ((
          _expandedPanelBottomMargin,
          expandedPanelMargin.horizontal,
        )) {
          (0, 0) => 0,
          _ => expandedPanelBorderRadius,
        }),
      ),
    );
    _collapsedPanelBottomMargin = _bottomBarHeight + _viewPadding.bottom;
    _collapsedPanelSize = Size(
      _constraints.maxWidth - collapsedPanelHorizontalMargin * 2,
      collapsedPanelHeight,
    );
  }

  bool _canAlertCoverViewPadding(Widget? alert) {
    return switch (alert) {
          final PanelAlert a => a.overrideCanCoverViewPadding,
          _ => null,
        } ??
        alertsCanCoverViewPadding;
  }

  EdgeInsets _alertBaseMargin(Widget? alert) {
    return switch (alert) {
      final PanelAlert a => a.overridePanelMargin ?? alertsMargin,
      _ => alertsMargin,
    };
  }

  double _alertBottomMargin(Widget? alert) {
    final double value = _alertBaseMargin(alert).bottom;
    return value +
        (_canAlertCoverViewPadding(alert) && value == 0
            ? 0
            : _viewPadding.bottom);
  }

  /// doesn't need to really be applied to the layout process, we pass this information
  /// to the render widget through [_alertBoxConstraints] and the height is computed correctly
  /// then the panel is aligned to the bottom of the screen anyway even if the real margin on top is zero nothing bad should happen
  double _alertTopMargin(Widget? alert) {
    final double value = _alertBaseMargin(alert).top;
    return value +
        (_canAlertCoverViewPadding(alert) && value == 0 ? 0 : _viewPadding.top);
  }

  double _alertInternalTopViewPadding({
    required double topMargin,
    required double bottomMargin,
    required double desiredAlertHeight, // updated by the render widget
  }) {
    /// if we're already not able to extend to the top of the screen, no need to provide a safe area inside the alert
    if (topMargin > 0) return 0;
    if (desiredAlertHeight == 0) return 0;

    final topSafe = _viewPadding.top;
    final double available = _constraints.maxHeight - bottomMargin - topSafe;

    if (desiredAlertHeight <= available) return 0;

    return (desiredAlertHeight - available).clamp(0, topSafe);
  }

  double _alertInternalBottomViewPadding(double bottomMargin) =>
      bottomMargin > 0 ? 0 : _viewPadding.bottom;

  EdgeInsets _alertResultingMargin(Widget? alert) {
    final EdgeInsets m = _alertBaseMargin(alert);

    return EdgeInsets.only(
      left: m.left,
      right: m.right,
      top: _alertTopMargin(alert),
      bottom: _alertBottomMargin(alert),
    );
  }

  /// passed to the render widget to properly compute the resulting size of the alert
  /// (maxWidth resulting from this will always be the static alert width, even while animating
  /// in size during the panel expansion, in order to avoid text shifting during the animation)
  BoxConstraints _alertBoxConstraints(
    double topMargin,
    double bottomMargin,
    Widget? alert,
  ) {
    final EdgeInsets m = _alertBaseMargin(alert);

    return _constraints
        .deflate(
          EdgeInsets.only(
            left: m.left,
            right: m.right,
            top: topMargin,
            bottom: bottomMargin,
          ),
        )
        .loosen();
  }

  BoxDecoration _alertDecoration({
    required Widget? alert,
    required double bottomMargin,
    required double topMargin,
    required double topInternalSafeArea, // if > 0, touches top of the screen
  }) {
    final double horizontal = _alertBaseMargin(alert).horizontal;
    return BoxDecoration(
      boxShadow: alertsShadows,
      border: horizontal.abs() + topMargin.abs() + bottomMargin.abs() == 0
          ? null
          : Border.fromBorderSide(alertsBorderSide),
      color: alertsColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(switch ((horizontal, topInternalSafeArea > 0)) {
          (0, true) => 0,
          _ => alertsBorderRadius,
        }),
        bottom: Radius.circular(switch ((horizontal, bottomMargin)) {
          (0, 0) => 0,
          _ => alertsBorderRadius,
        }),
      ),
    );
  }

  static PanelFrameStyleData _from({
    required BuildContext context,
    required PanelFrameStyleCustomizations customizations,
    required BoxConstraints constraints,
    required PreferredSizeWidget bottomBar,
  }) {
    final defaults = PanelFrameDefaultsTheme.of(context);
    final theme = Theme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    return PanelFrameStyleData._(
      constraints: constraints,
      viewPadding: viewPadding,
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
      bodyBackgroundColor:
          customizations.scaffoldBackgroundColor ??
          defaults.scaffoldBackgroundColor(context, theme),
      headerColor:
          customizations.headerColor ?? defaults.headerColor(context, theme),
      collapsedPanelColor:
          customizations.collapsedPanelBackgroundColor ??
          defaults.collapsedPanelBackgroundColor(context, theme),
      expandedPanelColor:
          customizations.expandedPanelBackgroundColor ??
          defaults.expandedPanelBackgroundColor(context, theme),
      topBarCollapsedColor:
          customizations.topBarCollapsedBackgroundColor ??
          defaults.topBarCollapsedBackgroundColor(context, theme),
      topBarExpandedColor:
          customizations.topBarExpandedBackgroundColor ??
          defaults.topBarExpandedBackgroundColor(context, theme),
      collapsedPanelHorizontalMargin:
          customizations.collapsedPanelHorizontalMargin ??
          defaults.collapsedPanelHorizontalMargin(context, theme),
      topBarCollapsedHeight: customizations.topBarCollapsedHeight,
      topBarExpandedHeight: customizations.topBarExpandedHeight,
      expandedPanelCanCoverViewPadding:
          customizations.expandedPanelCanCoverViewPadding,
      alertsCanCoverViewPadding: customizations.alertsCanCoverViewPadding,
      showDragHandleInHeaders: customizations.showDragHandleInHeaders,
      alertsBarrierColor: customizations.alertsBarrierColor,
      panelBarrierColor: customizations.panelBarrierColor,
      dismissOnBarrierTap: customizations.dismissOnBarrierTap,
      expandedPanelParallax: customizations.expandedPanelParallax,
      collapsedPanelParallax: customizations.collapsedPanelParallax,
      bodyParallax: customizations.bodyParallax,
      openPanelTopBarOverlap:
          customizations.openPanelTopBarOverlap ??
          defaults.openPanelTopBarOverlap(context, theme, customizations),
      alertsColor:
          customizations.alertsBackgroundColor ??
          defaults.alertsBackgroundColor(context, theme),
      alertsBorderSide:
          customizations.alertsBorderSide ??
          defaults.alertsBorderSide(context, theme),
      alertsBorderRadius:
          customizations.alertsBorderRadius ??
          defaults.alertsBorderRadius(context, theme),
      alertsMargin:
          customizations.alertsMargin ?? defaults.alertsMargin(context, theme),
      alertsShadows:
          customizations.alertsShadows ??
          defaults.alertsShadows(context, theme),
      collapsedShadows:
          customizations.collapsedShadows ??
          defaults.collapsedShadows(context, theme),
      expandedShadows:
          customizations.expandedShadows ??
          defaults.expandedShadows(context, theme),
      bottomBarHeight: bottomBar.preferredSize.height,
    );
  }
}

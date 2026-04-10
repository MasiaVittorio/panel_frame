part of '../../panel_frame.dart';

class _PanelFrame extends StatefulWidget {
  const _PanelFrame({
    required this.collapsedPanel,
    required this.expandedPanel,
    required this.body,
    required this.topBarBuilder,
    required this.bottomBar,
    required this.topBarChild,
    required this.style,
    required this.onPanelToggled,
    required this.redirectPopInvocations,
  });

  final PreferredSizeWidget bottomBar;
  final Widget collapsedPanel;
  final Widget expandedPanel;
  final Widget body;
  final Widget Function(BuildContext context, Widget? child, double openValue)
  topBarBuilder;
  final Widget? topBarChild;

  final PanelFrameStyleData style;
  final ValueChanged<bool>? onPanelToggled;
  final bool redirectPopInvocations;

  @override
  State<_PanelFrame> createState() => _PanelFrameState();
}

class _PanelFrameState extends State<_PanelFrame>
    with TickerProviderStateMixin, PanelFrameState {
  late AnimationController _panelAnimation;
  late AnimationController _snackbarAnimation;

  final Reactive<List<_PanelAlert>> _alerts = Reactive([]);
  final Reactive<List<double>> _alertsInternalTopViewPaddings = Reactive([]);
  final Reactive<bool> _openedFirstAlertFromExpandedPanel = Reactive(false);
  final Reactive<bool> _isAnimatingBack = Reactive(false);

  /// updated by listening to the panel's open value controller
  final Reactive<bool> _isMostlyOpened = Reactive(false);

  final Reactive<PanelSnackBar?> _snackBar = Reactive(null);
  final Reactive<Curve> _snackBarCurve = Reactive(Easings.emphasizedDecelerate);

  /// related to the others
  late final Reactive<bool> _isShowingAlert;
  late final Reactive<bool> _canTopBarExpand;
  late final Reactive<bool> _isTopBarExpanded;

  @override
  void dispose() {
    _snackbarAnimation.dispose();
    _panelAnimation.dispose();
    _alerts.dispose();
    _alertsInternalTopViewPaddings.dispose();
    _openedFirstAlertFromExpandedPanel.dispose();
    _isAnimatingBack.dispose();
    _isMostlyOpened.dispose();
    _snackBar.dispose();
    _snackBarCurve.dispose();
    _isShowingAlert.dispose();
    _canTopBarExpand.dispose();
    _isTopBarExpanded.dispose();
    super.dispose();
  }

  PanelFrameStyleData get style => widget.style;

  bool _dragOngoing = false;

  /// this is updated by the proportional stack inside [_ExpandedPanelAlertContents]
  /// and is used by the gestures to drive the open / close value of the animation based on the movement of the finger relative to the size of the alert
  double _alertsHeight = 0;

  /// used to be sure we want to update the animating back to false after the removing alert delay, since if we went back again then we want to keep _animatingBack to true even after removing the topmost alert
  int _animatingBackId = 0;

  /// used to be sure we want to close a snackbar after waiting for its delay duration
  int _snackBarId = 0;

  @override
  void initState() {
    super.initState();

    _isMostlyOpened.addListener(_openedListener);

    _panelAnimation = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      lowerBound: 0,
      upperBound: 1,
      debugLabel: 'Panel open value',
      value: 0,
    );
    _snackbarAnimation = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      lowerBound: 0,
      upperBound: 1,
      debugLabel: 'Snackbar animation',
      value: 0,
    );
    _panelAnimation.addListener(_listener);
    _isShowingAlert = (_alerts, _isAnimatingBack).related(
      (alerts, back) => switch ((alerts.length, back)) {
        (1, true) => false,
        (> 0, _) => true,
        _ => false,
      },
    );
    _canTopBarExpand =
        (_alerts, _openedFirstAlertFromExpandedPanel, _isAnimatingBack).related(
          (alerts, toExpandedPanel, animatingBack) {
            if (alerts.isEmpty) return true;
            // assert(alerts.isNotEmpty);
            if (alerts.length > 1) return false;
            // assert(alerts.length == 1);
            if (!animatingBack) return false;
            // assert(animatingBack);
            return toExpandedPanel;
          },
        );
    _isTopBarExpanded = (
      _isMostlyOpened,
      _canTopBarExpand,
    ).related((open, can) => can && open);
  }

  void _openedListener() {
    widget.onPanelToggled?.call(_isMostlyOpened.value);
  }

  double? _lastListenedValue;
  void _listener() {
    if (_panelAnimation.value >= _Gestures.openedThreshold) {
      _isMostlyOpened.update(true);
      if (_snackbarAnimation.value > 0 && !_snackbarAnimation.isAnimating) {
        closeSnackBar();
      }
    } else if (_panelAnimation.value < _Gestures.closedThreshold) {
      _isMostlyOpened.update(false);
    }
    if (_panelAnimation.value == 0 &&
        (_lastListenedValue ?? 0) > 0 &&
        !_dragOngoing) {
      _clearAlerts();
    }
    _lastListenedValue = _panelAnimation.value;
  }

  void _alertsSizesChanged(List<double> heights) {
    final List<double> newSafes = [
      for (int i = 0; i < heights.length; i++)
        if (_alerts.value.length > i)
          if (_alerts.value[i].child case Widget child)
            if (style._alertResultingMargin(child) case EdgeInsets m)
              style._alertInternalTopViewPadding(
                topMargin: m.top,
                bottomMargin: m.bottom,
                desiredAlertHeight: heights[i],
              ),
    ];
    if (listEquals(newSafes, _alertsInternalTopViewPaddings.value)) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _alertsInternalTopViewPaddings.update(newSafes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildContent(context);
  }

  /// the future is always completed when the alert is closed, either with a value or with null if the alert is dismissed without returning a value
  @override
  Future<T?> showAlert<T>(Widget alert) {
    openPanel();
    final future = _addAlert<T>(
      child: alert,
      isMostlyOpened: _isMostlyOpened.value,
    );
    return future;
  }

  @override
  Future<void> previousAlert<T extends Object?>([T? result]) => _goBackAlert(
    closePanel: closePanel,
    mountedGetter: () => mounted,
    result: result,
  );

  @override
  Future<void> closePanel() async {
    if (!mounted) return;

    if (_alerts.value.isNotEmpty) {
      _isAnimatingBack.update(true);
    }
    context.unfocus();

    if (_panelAnimation.value == 0 && !_panelAnimation.isAnimating) {
      _clearAlerts();
      return;
    }

    await _panelAnimation.animateBack(
      0.0,
      duration: style.duration,
      curve: style.curve,
    );
    if (!mounted) return;
    _clearAlerts();
  }

  @override
  Future<void> openPanel() async {
    if (!mounted) return;
    if (_panelAnimation.value == 1 && !_panelAnimation.isAnimating) return;
    return _panelAnimation.animateTo(
      1.0,
      duration: widget.style.duration,
      curve: widget.style.curve,
    );
  }

  @override
  Future<void> togglePanel() async {
    if (!mounted) return;
    if (_panelAnimation.value > 0.5) {
      return closePanel();
    } else {
      return openPanel();
    }
  }

  @override
  ScrollPhysics get panelContentScrollPhysics {
    return CallbackScrollPhysics(
      bottomBounce: false,
      topBounce: true,
      topBounceCallback: closePanel,
    );
  }

  @override
  Future<void> closeSnackBar<T>([T? result]) async {
    if (!mounted) return;
    _snackBarCurve.update(Easings.emphasizedAccelerate);
    await _snackbarAnimation.animateTo(
      0,
      duration: Durations.short4,
      curve: Curves.linear, // curves are applied in the widget
    );
    if (!mounted) return;
    _snackBar.update(null);
  }

  @override
  Future<T?> showSnackBar<T>(PanelSnackBar snackBar) async {
    if (!mounted) return Future.value(null);
    if (_snackbarAnimation.value > 0) {
      await closeSnackBar();
    }
    if (!mounted) return Future.value(null);
    _snackBar.update(snackBar);
    _snackBarId++;
    final int id = _snackBarId;
    _snackBarCurve.update(Easings.emphasizedDecelerate);
    await _snackbarAnimation.animateTo(1, duration: Durations.medium3);
    if (!mounted) return Future.value(null);
    if (snackBar.duration case Duration duration) {
      await Future.delayed(duration);
      if (!mounted) return Future.value(null);
      if (_snackBarId != id) return Future.value(null);
      await closeSnackBar();
    }
    return Future.value(null);
  }

  @override
  Widget buildWithIsTopBarExpanded({
    required Widget Function(BuildContext context, bool isAppBarExpanded)
    builder,
  }) {
    return _isTopBarExpanded.build(builder);
  }

  @override
  Widget buildWithAlertsCount({
    required Widget Function(BuildContext context, int alertsCount) builder,
  }) => _alerts.build((context, alerts) => builder(context, alerts.length));

  @override
  Widget buildWithIsPanelOpen({
    required Widget Function(BuildContext context, bool isPanelOpen) builder,
  }) => _isMostlyOpened.build(builder);

  @override
  Widget _buildCanTopBarExpand({
    required Widget Function(
      BuildContext context,
      int alertsCount,
      bool wasAlertShownFromExpandedPanel,
      bool canTopBarExpand,
    )
    builder,
  }) => Reactive.build3(
    _alerts,
    _openedFirstAlertFromExpandedPanel,
    _canTopBarExpand,
    builder: (context, aVal, bVal, cVal) =>
        builder(context, aVal.length, bVal, cVal),
  );

  @override
  Widget buildWithIsSnackBarShown({
    required Widget Function(BuildContext context, bool isSnackBarShown)
    builder,
  }) => _snackBar.build(
    (context, snackBar) => builder(context, snackBar != null),
  );

  @override
  Widget buildWithAlertShownFromExpandedPanel({
    required Widget Function(
      BuildContext context,
      bool wasAlertShownFromExpandedPanel,
    )
    builder,
  }) {
    return _openedFirstAlertFromExpandedPanel.build(builder);
  }

  @override
  Widget buildWithPanelInformation({
    required Widget Function(
      BuildContext context,
      bool isTopBarExpanded,
      int alertsCount,
      bool isSnackBarShown,
      bool isPanelOpen,
      bool wasAlertShownFromExpandedPanel,
    )
    builder,
  }) => Reactive.build5(
    _isTopBarExpanded,
    _alerts,
    _snackBar,
    _isMostlyOpened,
    _openedFirstAlertFromExpandedPanel,
    builder:
        (
          context,
          topBarExpanded,
          alerts,
          snackBar,
          isPanelOpen,
          wasAlertShownFromExpandedPanel,
        ) => builder(
          context,
          topBarExpanded,
          alerts.length,
          snackBar != null,
          isPanelOpen,
          wasAlertShownFromExpandedPanel,
        ),
  );
}

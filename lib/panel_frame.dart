import 'dart:async';
import 'dart:math' as math;

import 'package:call_to_action/call_to_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_insets/keyboard_insets.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:panel_frame/src/override_media_query_padding.dart';
import 'package:segmented_slider/segmented_slider.dart';
import 'package:sid_base/sid_base.dart';

part 'src/alerts_state.dart';
part 'src/animated_padding_builder.dart';
part 'src/animated_panel.dart';
part 'src/animated_switching_stack.dart';
part 'src/barrier.dart';
part 'src/body.dart';
part 'src/bottom_bar.dart';
part 'src/bottom_gestures.dart';
part 'src/expanded_margin_builder.dart';
part 'src/panel.dart';
part 'src/panel_alert_contents.dart';
part 'src/panel_alert_widget.dart';
part 'src/panel_frame_layout.dart';
part 'src/panel_frame_logic.dart';
part 'src/panel_frame_style.dart';
part 'src/panel_frame_style_data.dart';
part 'src/proportional_stack.dart';
part 'src/ready_components/alternatives_panel_alert.dart';
part 'src/ready_components/color_picker_panel.dart';
part 'src/ready_components/confirm_panel_alert.dart';
part 'src/ready_components/frame_app_bar.dart';
part 'src/ready_components/headered_list.dart';
part 'src/ready_components/insert_panel_alert.dart';
part 'src/ready_components/panel_header.dart';
part 'src/ready_components/theme_variant_picker.dart';
part 'src/snackbar.dart';
part 'src/top_bar.dart';

extension PanelFrameStateExtension on BuildContext {
  PanelFrameState get panelFrame => provide<PanelFrameState>();
  PanelFrameStyleData get panelFrameStyle => PanelFrameStyle.of(this);
}

class PanelFrame extends StatelessWidget {
  static PanelFrame of(BuildContext context) => context.provide<PanelFrame>();
  const PanelFrame({
    super.key,
    required this.collapsedPanel,
    required this.expandedPanel,
    required this.body,
    required this.topBarBuilder,
    required this.bottomBar,
    this.topBarChild,
    this.style,
  });

  final PreferredSizeWidget bottomBar;
  final Widget collapsedPanel;
  final Widget expandedPanel;
  final Widget body;
  final Widget Function(BuildContext context, Widget? child, double openValue)
  topBarBuilder;
  final Widget? topBarChild;

  final PanelFrameStyleData? style;

  @override
  Widget build(BuildContext context) {
    final style =
        this.style ??
        PanelFrameStyle.maybeOf(context) ??
        PanelFrameStyleData.defaultStyle;
    return PanelFrameStyle(
      style: style,
      child: _PanelFrame(
        collapsedPanel: collapsedPanel,
        expandedPanel: expandedPanel,
        body: body,
        topBarBuilder: topBarBuilder,
        bottomBar: bottomBar,
        topBarChild: topBarChild,
        style: style,
      ),
    );
  }
}

class _PanelFrame extends StatefulWidget {
  const _PanelFrame({
    required this.collapsedPanel,
    required this.expandedPanel,
    required this.body,
    required this.topBarBuilder,
    required this.bottomBar,
    required this.topBarChild,
    required this.style,
  });

  final PreferredSizeWidget bottomBar;
  final Widget collapsedPanel;
  final Widget expandedPanel;
  final Widget body;
  final Widget Function(BuildContext context, Widget? child, double openValue)
  topBarBuilder;
  final Widget? topBarChild;

  final PanelFrameStyleData style;

  @override
  State<_PanelFrame> createState() => PanelFrameState();
}

class PanelFrameState extends State<_PanelFrame> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _snackbarAnimationController;

  /// this is updated by the proportional stack inside [_ExpandedPanelAlertContents]
  /// and is used by the gestures to drive the open / close value of the animation based on the movement of the finger relative to the size of the alert
  double _expandedHeight = 0;

  final _AlertsState _alertsState = _AlertsState();

  late final Reactive<bool> _isMostlyOpened;
  late final Reactive<bool> _isAppBarExpanded;
  late final Reactive<bool> _isShowingAlert;
  late final Reactive<double> _neededAlertTopSafeArea;

  PanelSnackBar? _snackBar;
  Curve _snackBarCurve = Easings.emphasizedDecelerate;

  @override
  void initState() {
    super.initState();
    _isMostlyOpened = Reactive(false);
    _isShowingAlert = Reactive(false);
    _neededAlertTopSafeArea = Reactive(0);
    _controller = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      lowerBound: 0,
      upperBound: 1,
      debugLabel: 'Panel open value',
      value: 0,
    );
    _snackbarAnimationController = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      lowerBound: 0,
      upperBound: 1,
      debugLabel: 'Snackbar animation',
      value: 0,
    );
    _controller.addListener(_listener);
    _isAppBarExpanded = _isMostlyOpened.related(
      (value) => value && !_alertsState.isShowingAlert,
    );
    _alertsState.addListener(_updateIsAppBarExpanded);
  }

  void _updateIsAppBarExpanded() {
    _isShowingAlert.update(
      _alertsState.isShowingAlert &&
          !(_alertsState.getAnimatingBack &&
              _alertsState.howManyCurrentAlerts == 1),
    );
    _isAppBarExpanded.update(
      _isMostlyOpened.value &&
          ((!_alertsState.isShowingAlert) ||
              _alertsState.isGoingBackToExpandedPanelFromFirstAlert),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _snackbarAnimationController.dispose();
    _controller.dispose();
    _isMostlyOpened.dispose();
    _isShowingAlert.dispose();
    _isAppBarExpanded.dispose();
    _alertsState.removeListener(_updateIsAppBarExpanded);
    _alertsState.dispose();
    _neededAlertTopSafeArea.dispose();
    super.dispose();
  }

  Widget buildFromIsAppBarExpanded({
    required Widget Function(BuildContext context, bool isAppBarExpanded)
    builder,
  }) {
    return _isAppBarExpanded.build(builder);
  }

  double? _lastListenedValue;
  void _listener() {
    if (_controller.value >= openedThreshold) {
      _isMostlyOpened.update(true);
      if (_snackbarAnimationController.value > 0 &&
          !_snackbarAnimationController.isAnimating) {
        closeSnackBar();
      }
    } else if (_controller.value < closedThreshold) {
      _isMostlyOpened.update(false);
    }
    if (_controller.value == 0 &&
        (_lastListenedValue ?? 0) > 0 &&
        !_dragOngoing) {
      setState(() {
        _alertsState.clear();
      });
    }
    _lastListenedValue = _controller.value;
  }

  void _onPanelSizeChanged(Size size) {
    _expandedHeight = size.height;
  }

  void _onTargetAlertSizeChanged(Size size, Size screenSize) {
    final result = _computeNeededSafeArea(screenSize, size.height);
    if (result != _neededAlertTopSafeArea.value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _neededAlertTopSafeArea.update(result);
      });
    }
  }

  double _computeNeededSafeArea(Size screenSize, double targetAlertHeight) {
    final safe = MediaQuery.viewPaddingOf(context);

    final currentExpandedPanelMargin = _alertsState
        .resultingExpandedPanelMargin(widget.style, context);

    double topMargin = currentExpandedPanelMargin.top.clamp(0, double.infinity);

    if (topMargin > safe.top) {
      if (_alertsState.isGoingBackToExpandedPanelFromFirstAlert) {
        topMargin = 0;
      } else {
        return 0;
      }
    }

    final double topSafe = safe.top - topMargin;

    if (topSafe <= 0) return 0;

    final double screenHeight = screenSize.height - topMargin;

    final double remaining =
        screenHeight - targetAlertHeight - currentExpandedPanelMargin.bottom;

    return remaining < topSafe ? topSafe - remaining : 0;
  }

  /// the future is always complete when the alert is closed, either with a value or with null if the alert is dismissed without returning a value
  Future<T?> showAlert<T>(Widget alert) {
    final future = _alertsState.addAlert<T>(
      child: alert,
      isMostlyOpened: _isMostlyOpened.value,
    );
    openPanel();
    return future;
  }

  Future<void> previousAlert<T extends Object?>([T? result]) =>
      _alertsState.goBack(
        duration: widget.style.duration,
        closePanel: closePanel,
        mountedGetter: () => mounted,
        result: result,
      );

  Future<void> closePanel() async {
    if (!mounted) return;
    context.unfocus();

    if (_controller.value == 0 && !_controller.isAnimating) {
      _alertsState.clear();
      return;
    }

    await _controller.animateBack(
      0.0,
      duration: widget.style.duration,
      curve: widget.style.curve,
    );
    if (!mounted) return;
    _alertsState.clear();
  }

  Future<void> openPanel() async {
    if (!mounted) return;
    if (_controller.value == 1 && !_controller.isAnimating) return;
    return _controller.animateTo(
      1.0,
      duration: widget.style.duration,
      curve: widget.style.curve,
    );
  }

  Future<void> togglePanel() async {
    if (!mounted) return;
    if (_controller.value > 0.5) {
      return closePanel();
    } else {
      return openPanel();
    }
  }

  ScrollPhysics get panelContentScrollPhysics {
    return CallbackScrollPhysics(
      bottomBounce: false,
      topBounce: true,
      topBounceCallback: closePanel,
    );
  }

  Future<void> closeSnackBar() async {
    if (!mounted) return;
    _snackBarCurve = Easings.emphasizedAccelerate;
    await _snackbarAnimationController.animateTo(
      0,
      duration: Durations.short4,
      curve: Curves.linear, // curves are applied in the widget
    );
    if (!mounted) return;
    setState(() {
      _snackBar = null;
    });
  }

  int _snackBarId = 0;
  Future<void> showSnackBar(PanelSnackBar snackBar) async {
    if (!mounted) return;
    if (_snackbarAnimationController.value > 0) {
      await closeSnackBar();
    }
    if (!mounted) return;
    setState(() {
      _snackBar = snackBar;
      _snackBarId++;
    });
    final int id = _snackBarId;
    _snackBarCurve = Easings.emphasizedDecelerate;
    await _snackbarAnimationController.animateTo(
      1,
      duration: Durations.medium3,
    );
    if (!mounted) return;
    if (snackBar.duration case Duration duration) {
      await Future.delayed(duration);
      if (!mounted) return;
      if (_snackBarId != id) return;
      await closeSnackBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);

    final theme = context.theme;

    final bottomBar = _BottomBar(
      bottomBarHeight: widget.bottomBar.preferredSize.height,
      viewPadding: viewPadding,
      style: widget.style,
      child: widget.bottomBar,
    );

    final barrier = _Barrier(
      style: widget.style,
      controller: _controller,
      closePanel: closePanel,
    );

    final topBar = _TopBar(
      alertsState: _alertsState,
      controller: _controller,
      collapsedTopBarHeight: widget.style.topBarCollapsedHeight,
      expandedTopBarHeight: widget.style.topBarExpandedHeight,
      viewPadding: viewPadding,
      topBarBuilder: widget.topBarBuilder,
      topBarChild: widget.topBarChild,
      barrier: barrier,
      duration: widget.style.duration,
      curve: widget.style.curve,
    );

    final collapsedPanel = Stack(
      children: [
        SizedBox(
          height: widget.style.collapsedPanelHeight,
          child: widget.collapsedPanel,
        ),
        Positioned.fill(
          child: _SnackBar(
            snackbarAnimation: _snackbarAnimationController,
            curve: _snackBarCurve,
            snackBar: _snackBar,
          ),
        ),
      ],
    );

    void onDragUpdate(DragUpdateDetails details) => _onPanelDrag(
      details,
      (_expandedHeight - widget.style.collapsedPanelHeight).abs(),
    );

    final panel = _Panel(
      neededAlertTopSafeArea: _neededAlertTopSafeArea,
      alertsState: _alertsState,
      style: widget.style,
      duration: widget.style.duration,
      curve: widget.style.curve,
      controller: _controller,
      collapsedPanel: collapsedPanel,
      bottomBarHeight: widget.bottomBar.preferredSize.height,
      viewPadding: viewPadding,
      theme: theme,
      onDragEnd: _onDragEnd,
      onDragUpdate: onDragUpdate,
      panelContentScrollPhysics: panelContentScrollPhysics,
      onTargetAlertSizeChanged: (s) => _onTargetAlertSizeChanged(s, screenSize),
      onPanelSizeChanged: _onPanelSizeChanged,
      expandedPanel: widget.expandedPanel,
    );

    final body = _Body(
      controller: _controller,
      alertsState: _alertsState,
      style: widget.style,
      child: widget.body,
    );

    final bottomGestures = _BottomGestures(
      onDragEnd: _onDragEnd,
      onDragUpdate: onDragUpdate,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_alertsState.isShowingAlert) {
          previousAlert();
          return;
        }
        if (_controller.value > 0) {
          closePanel();
          return;
        }
        final navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.pop();
        } else {
          SystemNavigator.pop();
        }
      },
      child: CleanProvider(
        data: this,
        child: _PanelFrameLayout(
          style: widget.style,
          theme: theme,
          viewPadding: viewPadding,
          body: body,
          bottomBar: bottomBar,
          barrier: barrier,
          topBar: topBar,
          panel: panel,
          bottomGestures: bottomGestures,
          bottomBarHeight: widget.bottomBar.preferredSize.height,
        ),
      ),
    );
  }

  static const double minFlingVelocity = 365.0;

  static const double openedThreshold = 0.6;
  static const double closedThreshold = 0.4;

  bool _dragOngoing = false;
  bool? _onDragEnd(DragEndDetails details) {
    _dragOngoing = false;
    // let the current animation finish before starting a new one
    if (_controller.isAnimating) return null;
    // (can happen if you swipe up and down like a maniac)

    //check if the velocity is sufficient to constitute fling
    double vel = -details.velocity.pixelsPerSecond.dy;
    if (vel.abs() >= minFlingVelocity) {
      _flingPanel(
        v: vel.abs() * 2,
        S: (_expandedHeight - widget.style.collapsedPanelHeight).abs(),
        target: switch (vel) {
          > 0 => 1,
          _ => 0,
        },
      );
      return vel > 0;
    }
    switch (_controller.value.clamp(0.0, 1.0)) {
      case >= openedThreshold:
        openPanel();
        return true;
      case <= closedThreshold:
        closePanel();
        return false;
      default:
        if (_isMostlyOpened.value) {
          openPanel();
          return true;
        }
        closePanel();
        return false;
    }
  }

  void _onPanelDrag(DragUpdateDetails details, double delta) {
    context.unfocus();
    _dragOngoing = true;
    if (details.primaryDelta case double d) {
      _controller.value = (_controller.value - 1.2 * d / delta).clamp(0, 1);
    }
  }

  Future<void> _flingPanel({
    /// desired fling velocity (in pixels per second)
    required double v,

    /// total distance travelled by the panel while opening completely (in pixels)
    required double S,

    /// target value of the animation (0 for closing, 1 for opening)
    required double target,
  }) async {
    if (!mounted) return;

    if (target == 0 && _controller.value == 0 && !_controller.isAnimating) {
      _alertsState.clear();
      return;
    }

    await _animateFling(v: v, S: S, target: target);

    if (!mounted) return;
    if (target == 0) _alertsState.clear();
  }

  Future<void> _animateFling({
    /// desired fling velocity (in pixels per second)
    required double v,

    /// total distance travelled by the panel while opening completely (in pixels)
    required double S,

    /// target value of the animation (0 for closing, 1 for opening)
    required double target,
  }) async {
    await _controller.animateTo(
      target,
      duration: Duration(
        microseconds:
            (widget.style.duration.inMicroseconds *
                    0.9 *
                    (target - _controller.value).abs())
                .round(),
      ),
      curve: Easings.emphasizedDecelerate,
    );
  }
}

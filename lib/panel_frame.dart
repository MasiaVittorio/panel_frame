import 'dart:math' as math;

import 'package:call_to_action/call_to_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:panel_frame/panel_frame.dart';
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
part 'src/ready_components/color_picker_panel.dart';
part 'src/ready_components/frame_app_bar.dart';
part 'src/ready_components/headered_list.dart';
part 'src/ready_components/panel_header.dart';
part 'src/ready_components/theme_variant_picker.dart';
part 'src/snackbar.dart';
part 'src/top_bar.dart';

extension PanelFrameStateExtension on BuildContext {
  PanelFrameState get panelFrame => provide<PanelFrameState>();
  PanelFrameStyleData get panelFrameStyle => PanelFrameStyle.of(this);
}

class PanelFrame extends StatelessWidget {
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
  late AnimationController controller;
  late AnimationController snackbarAnimationController;

  /// this is updated by the proportional stack inside [_ExpandedPanelAlertContents]
  /// and is used by the gestures to drive the open / close value of the animation based on the movement of the finger relative to the size of the alert
  double _expandedHeight = 0;

  final _AlertsState _alertsState = _AlertsState();

  late final Reactive<bool> isMostlyOpened;
  late final Reactive<bool> isAppBarExpanded;
  late final Reactive<bool> isShowingAlert;
  late final Reactive<double> _neededAlertTopSafeArea;

  PanelSnackBar? _snackBar;
  Curve _snackBarCurve = Easings.emphasizedDecelerate;

  @override
  void initState() {
    super.initState();
    isMostlyOpened = Reactive(false);
    isShowingAlert = Reactive(false);
    _neededAlertTopSafeArea = Reactive(0);
    controller = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      lowerBound: 0,
      upperBound: 1,
      debugLabel: 'Panel open value',
      value: 0,
    );
    snackbarAnimationController = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      lowerBound: 0,
      upperBound: 1,
      debugLabel: 'Snackbar animation',
      value: 0,
    );
    controller.addListener(_listener);
    isAppBarExpanded = isMostlyOpened.related(
      (value) => value && !_alertsState.isShowingAlert,
    );
    _alertsState.addListener(_updateIsAppBarExpanded);
  }

  void _updateIsAppBarExpanded() {
    isShowingAlert.update(
      _alertsState.isShowingAlert &&
          !(_alertsState.isAnimatingBack && _alertsState.alerts.length == 1),
    );
    isAppBarExpanded.update(
      isMostlyOpened.value &&
          ((!_alertsState.isShowingAlert) ||
              _alertsState.isGoingBackToExpandedPanelFromFirstAlert),
    );
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    snackbarAnimationController.dispose();
    controller.dispose();
    isMostlyOpened.dispose();
    isShowingAlert.dispose();
    isAppBarExpanded.dispose();
    _alertsState.removeListener(_updateIsAppBarExpanded);
    _alertsState.dispose();
    _neededAlertTopSafeArea.dispose();
    super.dispose();
  }

  double? _lastListenedValue;
  void _listener() {
    if (controller.value >= openedThreshold) {
      isMostlyOpened.update(true);
    } else if (controller.value < closedThreshold) {
      isMostlyOpened.update(false);
    }
    if (controller.value == 0 && (_lastListenedValue ?? 0) > 0) {
      if (!_dragOngoing) {
        setState(() {
          _alertsState.clear();
        });
      }
    }
    _lastListenedValue = controller.value;
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
    final safe = context.safe;

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

  void showAlert(Widget alert) {
    _alertsState.addAlert(alert: alert, isMostlyOpened: isMostlyOpened.value);
    openPanel();
  }

  Future<void> previousAlert() => _alertsState.goBack(
    duration: widget.style.duration,
    closePanel: closePanel,
    mountedGetter: () => mounted,
  );

  Future<void> closePanel() async {
    if (!mounted) return;

    if (controller.value > 0) {
      await controller.animateBack(
        0.0,
        duration: widget.style.duration,
        curve: widget.style.curve,
      );
      _alertsState.clear();
      if (!mounted) return;
    } else {
      _alertsState.clear();
    }
  }

  Future<void> openPanel() async {
    if (!mounted) return;
    if (controller.value < 1) {
      return controller.animateTo(
        1.0,
        duration: widget.style.duration,
        curve: widget.style.curve,
      );
    }
  }

  Future<void> togglePanel() async {
    if (!mounted) return;
    if (controller.value > 0.5) {
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
    await snackbarAnimationController.animateTo(
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
    if (snackbarAnimationController.value > 0) {
      await closeSnackBar();
    }
    if (!mounted) return;
    setState(() {
      _snackBar = snackBar;
      _snackBarId++;
    });
    final int id = _snackBarId;
    _snackBarCurve = Easings.emphasizedDecelerate;
    await snackbarAnimationController.animateTo(1, duration: Durations.medium3);
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
    final mediaQuery = MediaQuery.of(context);
    final safe = mediaQuery.padding;

    final theme = context.theme;

    final bottomBar = _BottomBar(
      bottomBarHeight: widget.bottomBar.preferredSize.height,
      safe: safe,
      style: widget.style,
      mediaQuery: mediaQuery,
      child: widget.bottomBar,
    );

    final barrier = _Barrier(
      style: widget.style,
      controller: controller,
      closePanel: closePanel,
    );

    final topBar = _TopBar(
      alertsState: _alertsState,
      controller: controller,
      collapsedTopBarHeight: widget.style.topBarCollapsedHeight,
      expandedTopBarHeight: widget.style.topBarExpandedHeight,
      safe: safe,
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
            snackbarAnimation: snackbarAnimationController,
            curve: _snackBarCurve,
            snackBar: _snackBar,
          ),
        ),
      ],
    );

    void onDragUpdate(DragUpdateDetails details) => onPanelDrag(
      details,
      (_expandedHeight - widget.style.collapsedPanelHeight).abs(),
    );

    final panel = _Panel(
      neededAlertTopSafeArea: _neededAlertTopSafeArea,
      mediaQuery: mediaQuery,
      alertsState: _alertsState,
      style: widget.style,
      duration: widget.style.duration,
      curve: widget.style.curve,
      controller: controller,
      collapsedPanel: collapsedPanel,
      bottomBarHeight: widget.bottomBar.preferredSize.height,
      safe: safe,
      theme: theme,
      onDragEnd: onDragEnd,
      onDragUpdate: onDragUpdate,
      panelContentScrollPhysics: panelContentScrollPhysics,
      onTargetAlertSizeChanged: (s) =>
          _onTargetAlertSizeChanged(s, mediaQuery.size),
      onPanelSizeChanged: _onPanelSizeChanged,
      expandedPanel: widget.expandedPanel,
    );

    final body = _Body(
      controller: controller,
      alertsState: _alertsState,
      style: widget.style,
      child: widget.body,
    );

    final bottomGestures = _BottomGestures(
      onDragEnd: onDragEnd,
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
        if (controller.value > 0) {
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
          safe: safe,
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
  bool? onDragEnd(DragEndDetails details) {
    _dragOngoing = false;
    // let the current animation finish before starting a new one
    if (controller.isAnimating) return null;
    // (can happen if you swipe up and down like a maniac)

    //check if the velocity is sufficient to constitute fling
    double vel = -details.velocity.pixelsPerSecond.dy;
    if (vel.abs() >= minFlingVelocity) {
      if (vel > 0) {
        // TODO: craft a better curve / duration based on the velocity and the current position of the panel
        openPanel();
        return true;
      } else {
        closePanel();
        return false;
      }
    }
    switch (controller.value.clamp(0.0, 1.0)) {
      case >= openedThreshold:
        openPanel();
        return true;
      case <= closedThreshold:
        closePanel();
        return false;
      default:
        if (isMostlyOpened.value) {
          openPanel();
          return true;
        }
        closePanel();
        return false;
    }
  }

  void onPanelDrag(DragUpdateDetails details, double delta) {
    _dragOngoing = true;
    if (details.primaryDelta case double d) {
      controller.value = (controller.value - 1.2 * d / delta).clamp(0, 1);
    }
  }
}

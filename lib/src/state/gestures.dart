part of '../../panel_frame.dart';

extension _Gestures on _PanelFrameState {
  static const double minFlingVelocity = 365.0;

  static const double openedThreshold = 0.6;
  static const double closedThreshold = 0.4;

  double _delta() {
    final result =
        ((_isShowingAlert.value ? _alertsHeight : style._expandedPanelHeight) -
                style.collapsedPanelHeight)
            .abs();
    return result;
  }

  bool? _onDragEnd(DragEndDetails details) {
    _dragOngoing = false;
    // let the current animation finish before starting a new one
    if (_panelAnimation.isAnimating) return null;
    // (can happen if you swipe up and down like a maniac)

    //check if the velocity is sufficient to constitute fling
    double vel = -details.velocity.pixelsPerSecond.dy;
    if (vel.abs() >= minFlingVelocity) {
      _flingPanel(
        v: vel.abs() * 2,
        S: _delta(),
        target: switch (vel) {
          > 0 => 1,
          _ => 0,
        },
      );
      return vel > 0;
    }
    switch (_panelAnimation.value.clamp(0.0, 1.0)) {
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

  void _onDragUpdate(DragUpdateDetails details) {
    final delta = _delta();
    context.unfocus();
    _dragOngoing = true;
    if (details.primaryDelta case double d) {
      _panelAnimation.value = (_panelAnimation.value - 1.2 * d / delta).clamp(
        0,
        1,
      );
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

    if (target == 0 &&
        _panelAnimation.value == 0 &&
        !_panelAnimation.isAnimating) {
      _clearAlerts();
      return;
    }

    await _animateFling(v: v, S: S, target: target);

    if (!mounted) return;
    if (target == 0) _clearAlerts();
  }

  Future<void> _animateFling({
    /// desired fling velocity (in pixels per second)
    required double v,

    /// total distance travelled by the panel while opening completely (in pixels)
    required double S,

    /// target value of the animation (0 for closing, 1 for opening)
    required double target,
  }) async {
    await _panelAnimation.animateTo(
      target,
      duration: Duration(
        microseconds:
            (widget.style.duration.inMicroseconds *
                    0.9 *
                    (target - _panelAnimation.value).abs())
                .round(),
      ),
      curve: Easings.emphasizedDecelerate,
    );
  }
}

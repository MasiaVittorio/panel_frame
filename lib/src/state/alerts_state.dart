part of '../../panel_frame.dart';

class _PanelAlert<T> {
  final Widget child;

  T? registeredValueForCompletion;
  late final Completer<T?> completer;
  _PanelAlert({required this.child}) {
    completer = Completer<T?>();
  }

  void complete(T? value) {
    if (completer.isCompleted) return;
    completer.complete(value ?? registeredValueForCompletion);
  }

  void register(T value) {
    registeredValueForCompletion = value;
  }
}

extension _AlertsState on _PanelFrameState {
  Future<T?> _addAlert<T>({
    required Widget child,
    required bool isMostlyOpened,
  }) {
    if (_alerts.value.isEmpty) {
      _openedFirstAlertFromExpandedPanel.update(isMostlyOpened);
    }
    if (_isAnimatingBack.value) {
      _isAnimatingBack.update(false);
      if (_alerts.value.isNotEmpty) {
        _alerts.value.removeLast();
        _alerts.refresh();
      }
    }
    final _PanelAlert<T> alert = _PanelAlert<T>(child: child);
    _alerts.value.add(alert);
    _alerts.refresh();
    return alert.completer.future;
  }

  Future<void> _goBackAlert({
    required Duration duration,
    required VoidCallback closePanel,
    required bool Function() mountedGetter,
    required dynamic result,
  }) async {
    if (_isAnimatingBack.value) return;
    if (!mountedGetter()) return;
    if (_alerts.value.isEmpty) {
      return closePanel();
    }

    _alerts.value.last.register(result);

    if (_alerts.value.length == 1 &&
        !_openedFirstAlertFromExpandedPanel.value) {
      // will trigger clear anyway
      return closePanel();
    }

    _isAnimatingBack.update(true);
    _animatingBackId++;
    final id = _animatingBackId;
    // so the stack changes focus to the previous child, and when the current child is out of view we can remove it from the widget tree
    await Future.delayed(duration);
    if (!mountedGetter()) return;
    _finishRemovingAlert(id);
  }

  void _finishRemovingAlert(int id) {
    if (_isAnimatingBack.value &&
        id == _animatingBackId &&
        _alerts.value.isNotEmpty) {
      // if not, it means we called add alert during the back animation,
      // in which case the last children was already replaced instead of removed
      _alerts.value.removeLast();
      if (_alerts.value.isEmpty) {
        _openedFirstAlertFromExpandedPanel.update(false);
      }
    }
    _isAnimatingBack.update(false);
    _alerts.refresh();
  }

  void _clearAlerts() {
    for (final a in _alerts.value) {
      a.complete(null);
    }
    _alerts.value.clear();
    _openedFirstAlertFromExpandedPanel.update(false);
    _isAnimatingBack.update(false);
    _alerts.refresh();
  }
}

class _AlertMetadata {
  final bool canGoBack;

  const _AlertMetadata({required this.canGoBack});
}

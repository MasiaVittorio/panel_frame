part of '../../panel_frame.dart';

class _PanelAlert<T> {
  final Widget child;
  late final String id;

  T? registeredValueForCompletion;
  late final Completer<T?> _completer;
  _PanelAlert({required this.child}) {
    _completer = Completer<T?>();
    _alertId++;
    id = 'panel_frame_alert_$_alertId';
  }

  void complete(T? value) {
    if (_completer.isCompleted) return;
    _completer.complete(value ?? registeredValueForCompletion);
  }

  void register(T? value) {
    registeredValueForCompletion = value;
  }
}

int _alertId = 0;

extension _AlertsState on _PanelFrameState {
  Future<T?> _addAlert<T>({
    required Widget child,
    required bool isMostlyOpened,
  }) {
    if (_alerts.value.isEmpty) {
      _openedFirstAlertFromExpandedPanel.update(isMostlyOpened);
    }
    final alert = _PanelAlert<T>(child: child);
    if (_isAnimatingBack.value && _alerts.value.isNotEmpty) {
      /// open panel is called outside of this anyway, so dont worry about if the closed alert was the last one and triggered a closePanel
      _alerts.value.last.complete(null);
      _alerts.value.last = alert;
      _isAnimatingBack.update(false);
    } else {
      _alerts.value.add(alert);
    }
    _alerts.refresh();
    return alert._completer.future;
  }

  Future<void> _goBackAlert({
    required VoidCallback closePanel,
    required bool Function() mountedGetter,
    required dynamic result,
  }) async {
    if (!mountedGetter()) return;
    if (_alerts.value.isEmpty) return closePanel();
    if (_isAnimatingBack.value) return;

    _alerts.value.last.register(result);
    final id = _alerts.value.last.id;
    _animatingBackId++;
    final int thisAnimateBackId = _animatingBackId + 0;
    _isAnimatingBack.update(true);

    if (_alerts.value.length == 1 &&
        !_openedFirstAlertFromExpandedPanel.value) {
      closePanel(); // will trigger clear anyway
      return;
    }

    // so the stack changes focus to the previous child, and when the current child is out of view we can remove it from the widget tree
    await Future.delayed(style.duration);
    if (!mountedGetter()) return;
    _finishRemovingAlert(id, thisAnimateBackId);
  }

  void _finishRemovingAlert(String id, int thisAnimateBackId) {
    final int foundIndex = _alerts.value.indexWhere((e) => e.id == id);
    if (foundIndex != -1) {
      _alerts.value[foundIndex].complete(null);
      _alerts.value.removeAt(foundIndex);
      if (_alerts.value.isEmpty) {
        _openedFirstAlertFromExpandedPanel.update(false);
      }
      _alerts.refresh();
    }
    if (thisAnimateBackId == _animatingBackId) {
      _isAnimatingBack.update(false);
    }
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

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

class _AlertsState extends ChangeNotifier {
  final List<_PanelAlert> _alerts = [];
  bool openedFirstAlertFromExpandedPanel = false;
  bool _isAnimatingBack = false;
  int _animatingBackId = 0;

  List<Widget> get alertChildren => [for (final a in _alerts) a.child];
  int get howManyCurrentAlerts => _alerts.length;

  Widget? get currentAlert => (switch (_alerts) {
    [] => null,
    final list => switch (getAnimatingBack) {
      true => list.length > 1 ? list[list.length - 2] : list.last,
      false => list.last,
    },
  })?.child;

  bool get isShowingAlert => _alerts.isNotEmpty;
  bool get isGoingBackToExpandedPanelFromFirstAlert =>
      openedFirstAlertFromExpandedPanel &&
      howManyCurrentAlerts == 1 &&
      getAnimatingBack;

  bool get getAnimatingBack => _isAnimatingBack;

  bool get isCurrentAlertFullScreen => switch (currentAlert) {
    final PanelAlertWidget w => w.wantsToBeFullScreen ?? false,
    _ => false,
  };

  Future<T?> addAlert<T>({
    required Widget child,
    required bool isMostlyOpened,
  }) {
    if (_alerts.isEmpty) {
      openedFirstAlertFromExpandedPanel = isMostlyOpened;
    }
    if (getAnimatingBack) {
      _isAnimatingBack = false;
      if (_alerts.isNotEmpty) {
        _alerts.removeLast();
      }
    }
    final _PanelAlert<T> alert = _PanelAlert<T>(child: child);
    _alerts.add(alert);
    notifyListeners();
    return alert.completer.future;
  }

  Future<void> goBack({
    required Duration duration,
    required VoidCallback closePanel,
    required bool Function() mountedGetter,
    required dynamic result,
  }) async {
    if (getAnimatingBack) return;
    if (!mountedGetter()) return;
    if (_alerts.isEmpty) {
      notifyListeners();
      return closePanel();
    }

    _alerts.last.register(result);

    if (_alerts.length == 1 && !openedFirstAlertFromExpandedPanel) {
      notifyListeners();
      // will trigger clear anyway
      return closePanel();
    }

    _isAnimatingBack = true;
    _animatingBackId++;
    notifyListeners();
    final id = _animatingBackId;
    // so the stack changes focus to the previous child, and when the current child is out of view we can remove it from the widget tree
    await Future.delayed(duration);
    if (!mountedGetter()) return;
    _finishRemovingAlert(id);
  }

  void _finishRemovingAlert(int id) {
    if (getAnimatingBack && id == _animatingBackId && _alerts.isNotEmpty) {
      // if not, it means we called add alert during the back animation,
      // in which case the last children was already replaced instead of removed
      _alerts.removeLast();
      if (_alerts.isEmpty) {
        openedFirstAlertFromExpandedPanel = false;
      }
    }
    _isAnimatingBack = false;
    notifyListeners();
  }

  void clear() {
    for (final a in _alerts) {
      a.complete(null);
    }
    _alerts.clear();
    openedFirstAlertFromExpandedPanel = false;
    _isAnimatingBack = false;
    notifyListeners();
  }

  /// doesn't account for the keyboard, that is added inside animated_panel
  EdgeInsets resultingExpandedPanelMargin(
    PanelFrameStyleData style,
    BuildContext context,
  ) {
    final focusedAlert = switch (isGoingBackToExpandedPanelFromFirstAlert) {
      true => null,
      false => currentAlert,
    };

    final EdgeInsets desiredMargins = switch (focusedAlert) {
      final PanelAlertWidget w =>
        w.overridePanelMargin ?? style.expandedPanelMargin,
      _ => style.expandedPanelMargin,
    };

    final bool forceExtendToFullScreen = switch (focusedAlert) {
      final PanelAlertWidget w => w.wantsToBeFullScreen ?? false,
      _ => false,
    };

    final bool touchEdges =
        forceExtendToFullScreen || style.fullScreenExpandedPanel;

    final EdgeInsets safe = MediaQuery.paddingOf(context);

    final double expandedTopMargin = style.justExpandedPanelTopMargin(safe);

    final baseMargins = forceExtendToFullScreen
        ? EdgeInsets.zero
        : desiredMargins;

    return baseMargins +
        EdgeInsets.only(
          bottom: touchEdges && baseMargins.bottom == 0 ? 0 : safe.bottom,
          top: switch ((focusedAlert, touchEdges)) {
            (null, _) => expandedTopMargin,
            (_, true) => baseMargins.top == 0 ? 0 : safe.top,
            (_, false) => safe.top,
          },
        );
  }
}

part of '../panel_frame.dart';

class _AlertsState extends ChangeNotifier {
  List<Widget> alerts = [];

  Widget? get currentAlert => switch (alerts) {
    [] => null,
    final list => switch (isAnimatingBack) {
      true => list.length > 1 ? list[list.length - 2] : list.last,
      false => list.last,
    },
  };

  bool get isShowingAlert => alerts.isNotEmpty;
  bool get isGoingBackToExpandedPanelFromFirstAlert =>
      openedFirstAlertFromExpandedPanel &&
      alerts.length == 1 &&
      isAnimatingBack;

  bool openedFirstAlertFromExpandedPanel = false;
  bool isAnimatingBack = false;
  int _animatingBackId = 0;

  void addAlert({required Widget alert, required bool isMostlyOpened}) {
    if (alerts.isEmpty) {
      openedFirstAlertFromExpandedPanel = isMostlyOpened;
    }
    if (isAnimatingBack) {
      if (alerts.isNotEmpty) {
        alerts.removeLast();
      }
      isAnimatingBack = false;
    }
    alerts.add(alert);
    notifyListeners();
  }

  Future<void> goBack({
    required Duration duration,
    required VoidCallback closePanel,
    required bool Function() mountedGetter,
  }) async {
    if (isAnimatingBack) return;
    if (!mountedGetter()) return;
    if (alerts.isEmpty) {
      notifyListeners();
      return closePanel();
    }
    if (alerts.length == 1 && !openedFirstAlertFromExpandedPanel) {
      notifyListeners();
      return closePanel();
    }
    isAnimatingBack = true;
    _animatingBackId++;
    notifyListeners();
    final id = _animatingBackId;
    // so the stack changes focus to the previous child, and when the current child is out of view we can remove it from the widget tree
    await Future.delayed(duration);
    if (!mountedGetter()) return;
    _finishRemovingAlert(id);
  }

  void _finishRemovingAlert(int id) {
    if (isAnimatingBack && id == _animatingBackId && alerts.isNotEmpty) {
      // if not, it means we called add alert during the back animation,
      // in which case the last children was already replaced instead of removed
      alerts.removeLast();
      if (alerts.isEmpty) {
        openedFirstAlertFromExpandedPanel = false;
      }
    }
    isAnimatingBack = false;
    notifyListeners();
  }

  void clear() {
    alerts.clear();
    openedFirstAlertFromExpandedPanel = false;
    isAnimatingBack = false;
    notifyListeners();
  }

  EdgeInsets resultingExpandedPanelMargin(
    PanelFrameStyleData style,
    BuildContext context,
  ) {
    final focusedAlert = isGoingBackToExpandedPanelFromFirstAlert
        ? null
        : currentAlert;

    final EdgeInsets desiredExpandedPanelMargins = switch (focusedAlert) {
      final PanelAlertWidget w =>
        w.overridePanelMargin ?? style.expandedPanelMargin(context),
      _ => style.expandedPanelMargin(context),
    };

    final bool forceExtendToFullScreen = switch (focusedAlert) {
      final PanelAlertWidget w => w.wantsToBeFullScreen ?? false,
      _ => false,
    };

    final bool removeSafeAreas = forceExtendToFullScreen
        ? true
        : switch (focusedAlert) {
            final PanelAlertWidget w =>
              w.wantsToBeFullScreen ?? style.fullScreenExpandedPanel,
            _ => style.fullScreenExpandedPanel,
          };

    final safe = context.safe;

    final double justExpandedPanelTopMargin = style.justExpandedPanelTopMargin(
      safe,
    );

    final baseMargins = forceExtendToFullScreen
        ? EdgeInsets.zero
        : desiredExpandedPanelMargins;

    return baseMargins +
        EdgeInsets.only(
          bottom: removeSafeAreas && baseMargins.bottom == 0 ? 0 : safe.bottom,
          top: switch ((focusedAlert, removeSafeAreas)) {
            (null, _) => justExpandedPanelTopMargin,
            (_, true) => baseMargins.top == 0 ? 0 : safe.top,
            (_, false) => safe.top,
          },
        );
  }

  bool get isCurrentAlertFullScreen => switch (currentAlert) {
    final PanelAlertWidget w => w.wantsToBeFullScreen ?? false,
    _ => false,
  };
}

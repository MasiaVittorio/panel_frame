part of '../../panel_frame.dart';

mixin PanelFrameState {
  /// the future should complete immediately when the alert is dismissed, even if the back animation is still ongoing.
  /// if called again with a new alert while the previous alert has been dismissed but not finished its back animation, the new alert should immediately replace the old one, reverting the back animation
  Future<T?> showAlert<T>(Widget alert);

  /// the future completes when the alert close animation finishes or is canceled. the [result] is the value that completes the future returned by the [showAlert] method that showed the alert being dismissed.
  Future<void> previousAlert<T>([T? result]);

  /// the future should complete immediately when the snackbar is dismissed, even if the back animation is still ongoing.
  /// if called again with a new snackbar while the previous snackbar has been dismissed but not finished its back animation, the new snackbar should immediately replace the old one, reverting the back animation
  Future<T?> showSnackBar<T>(PanelSnackBar snackBar);

  /// the future completes when the snackbar close animation finishes. the [result] is the value that completes the future returned by the [showSnackBar] method that showed the snackbar being dismissed.
  Future<void> closeSnackBar<T>([T? result]);

  /// the future completes when the panel finishes its open animation. if the panel is already open, it completes immediately. if the panel is currently in the process of opening or closing, it completes when that animation finishes.
  Future<void> openPanel();

  /// the future completes when the panel finishes its close animation. if the panel is already closed, it completes immediately. if the panel is currently in the process of opening or closing, it completes when that animation finishes.
  Future<void> closePanel();

  /// the future completes when the panel finishes its open or close animation. if the panel is currently in the process of opening or closing, it completes when that animation finishes.
  Future<void> togglePanel();

  /// the user can build widgets that consume the necessary information without being able to interfere with the State's internal logic
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
  });

  Widget _buildCanTopBarExpand({
    required Widget Function(
      BuildContext context,
      int alertsCount,
      bool wasAlertShownFromExpandedPanel,
      bool canTopBarExpand,
    )
    builder,
  });
  Widget buildWithIsTopBarExpanded({
    required Widget Function(BuildContext context, bool isTopBarExpanded)
    builder,
  });

  Widget buildWithAlertsCount({
    required Widget Function(BuildContext context, int alertsCount) builder,
  });

  Widget buildWithIsSnackBarShown({
    required Widget Function(BuildContext context, bool isSnackBarShown)
    builder,
  });

  Widget buildWithIsPanelOpen({
    required Widget Function(BuildContext context, bool isPanelOpen) builder,
  });

  Widget buildWithAlertShownFromExpandedPanel({
    required Widget Function(
      BuildContext context,
      bool wasAlertShownFromExpandedPanel,
    )
    builder,
  });

  ScrollPhysics get panelContentScrollPhysics;
}

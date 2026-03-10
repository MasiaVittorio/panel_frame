part of '../panel_frame.dart';

mixin PanelAlertWidget on Widget {
  bool? get wantsToBeFullScreen;
  EdgeInsets? get overridePanelMargin => null;
}

// class MyFullScreenWidget extends StatelessWidget with PanelAlertWidget {
//   const MyFullScreenWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
//
//   @override
//   bool? get wantsToBeFullScreen => true;
// }

class PanelSnackBarAction {
  final Widget icon;
  final VoidCallback onPressed;

  PanelSnackBarAction({required this.icon, required this.onPressed});
}

class PanelSnackBar {
  final Widget child;
  final bool fromLeft;
  final bool scrollable;
  final bool dismissible;
  final PanelSnackBarAction? action;

  // null means indefinite
  final Duration? duration;

  PanelSnackBar({
    required this.child,
    this.fromLeft = true,
    this.scrollable = false,
    this.dismissible = true,
    this.action,
    this.duration = const Duration(seconds: 3),
  });
}

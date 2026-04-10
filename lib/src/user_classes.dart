part of '../panel_frame.dart';

/// class MyFullScreenWidget extends StatelessWidget with PanelAlert {
///   const MyFullScreenWidget({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return const Placeholder();
///   }
///
///   @override
///   bool? get wantsToBeFullScreen => false; // never full screen
/// }
mixin PanelAlert on Widget {
  bool? get overrideCanCoverViewPadding => null;
  EdgeInsets? get overridePanelMargin => null;
  bool get avoidKeyboard => true;
}

/// class MyFullScreenWidget extends StatelessWidget
///     with PanelAlert, FullScreenPanelAlert {
///   const MyFullScreenWidget({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return const Placeholder();
///   }
/// }
mixin FullScreenPanelAlert on PanelAlert {
  @override
  bool get avoidKeyboard => false;

  @override
  bool? get overrideCanCoverViewPadding => true;

  @override
  EdgeInsets? get overridePanelMargin => EdgeInsets.zero;
}

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

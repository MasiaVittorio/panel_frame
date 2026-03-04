part of '../panel_frame.dart';

class _Body extends StatelessWidget {
  const _Body({
    required this.controller,
    required this.alertsState,
    required this.style,
    required this.child,
  });

  final AnimationController controller;
  final Widget child;
  final PanelFrameStyleData style;
  final _AlertsState alertsState;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      removeBottom: true,
      context: context,
      child: ValueListenableBuilder(
        valueListenable: controller,
        child: child,
        builder: (context, value, child) => ListenableBuilder(
          listenable: alertsState,
          child: child,
          builder: (context, child) {
            return FractionalTranslation(
              translation: Offset(
                0,
                -(alertsState.isShowingAlert ? 0 : value) *
                    style.bodyParallaxMultiplier,
              ),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}

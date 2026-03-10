part of '../../../panel_frame.dart';

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.controller,
    required this.collapsedTopBarHeight,
    required this.viewPadding,
    required this.expandedTopBarHeight,
    required this.topBarBuilder,
    required this.topBarChild,
    required this.alertsState,
    required this.barrier,
    required this.duration,
    required this.curve,
  });

  final _Barrier barrier;
  final _AlertsState alertsState;
  final AnimationController controller;
  final double collapsedTopBarHeight;
  final EdgeInsets viewPadding; // static, non keyboard
  final double expandedTopBarHeight;

  final Widget Function(BuildContext context, Widget? child, double openValue)
  topBarBuilder;
  final Widget? topBarChild;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final e = expandedTopBarHeight + viewPadding.top;
    final c = collapsedTopBarHeight + viewPadding.top;

    return ListenableBuilder(
      listenable: alertsState,
      builder: (context, child) {
        double desiredExpandedHeight = e;
        if (alertsState.isShowingAlert) {
          desiredExpandedHeight = c;
        }
        if (alertsState.isGoingBackToExpandedPanelFromFirstAlert) {
          desiredExpandedHeight = e;
        }

        return GenericAnimatedBuilder(
          value: desiredExpandedHeight,
          duration: duration,
          curve: curve,
          builder: (context, animatedExpandedHeight, _) {
            return ValueListenableBuilder(
              valueListenable: controller,
              child: topBarChild,
              builder: (context, value, child) {
                final definitiveHeight =
                    alertsState.howManyCurrentAlerts == 1 &&
                        !alertsState.openedFirstAlertFromExpandedPanel
                    ? c
                    : value.rangeMap(to: (c, animatedExpandedHeight));

                final double barrierOpacity = !alertsState.isShowingAlert
                    ? 0
                    : definitiveHeight.rangeMap(from: (e, c));
                return Stack(
                  children: [
                    SizedBox(
                      height: definitiveHeight,
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: false,
                        removeBottom: true,
                        child: topBarBuilder(context, child, value),
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        ignoring: barrierOpacity < 0.1,
                        child: Opacity(opacity: barrierOpacity, child: barrier),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

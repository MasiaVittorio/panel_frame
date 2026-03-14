part of '../../../panel_frame.dart';

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.barrier,
    required this.panelAnimation,
    required this.style,
    required this.topBarChild,
    required this.alerts,
    required this.isAnimatingBack,
    required this.openedFirstAlertFromExpandedPanel,
    required this.topBarBuilder,
  });

  final _Barrier barrier;
  final AnimationController panelAnimation;
  final PanelFrameStyleData style;

  final Widget Function(BuildContext context, Widget? child, double openValue)
  topBarBuilder;
  final Widget? topBarChild;

  final Reactive<List<_PanelAlert>> alerts;
  final Reactive<bool> isAnimatingBack;
  final Reactive<bool> openedFirstAlertFromExpandedPanel;

  @override
  Widget build(BuildContext context) {
    final e = style.topBarExpandedHeight + style._viewPadding.top;
    final c = style.topBarCollapsedHeight + style._viewPadding.top;

    return Reactive.build3(
      alerts,
      isAnimatingBack,
      openedFirstAlertFromExpandedPanel,
      builder: (context, alerts, animatingBack, toExpanded) {
        final alertsCount = alerts.length;
        final backFromFirst = animatingBack && alertsCount == 1;
        final bool isShowingAlert = alertsCount > 0 && !backFromFirst;
        return GenericAnimatedBuilder(
          curve: style.curve,
          duration: style.duration,
          value: switch ((isShowingAlert, backFromFirst && toExpanded)) {
            (true, false) => c,
            _ => e,
          },
          child: topBarChild,
          builder: (context, animatedExpandedHeight, topBarChild) {
            return ValueListenableBuilder(
              valueListenable: panelAnimation,
              child: topBarChild,
              builder: (context, value, child) {
                final definitiveHeight = alertsCount == 1 && !toExpanded
                    ? c
                    : value.rangeMap(to: (c, animatedExpandedHeight));

                final double barrierOpacity = !isShowingAlert
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

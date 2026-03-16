part of '../../../panel_frame.dart';

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.barrier,
    required this.panelAnimation,
    required this.style,
    required this.topBarChild,
    required this.topBarBuilder,
    required this.alerts,
    required this.openedFirstAlertFromExpandedPanel,
    required this.isAnimatingBack,
  });

  final _Barrier barrier;
  final AnimationController panelAnimation;
  final PanelFrameStyleData style;

  final Widget Function(BuildContext context, Widget? child, double openValue)
  topBarBuilder;
  final Widget? topBarChild;

  final Reactive<List<_PanelAlert>> alerts;
  final Reactive<bool> openedFirstAlertFromExpandedPanel;
  final Reactive<bool> isAnimatingBack;

  @override
  Widget build(BuildContext context) {
    final e = style.topBarExpandedHeight + style._viewPadding.top;
    final c = style.topBarCollapsedHeight + style._viewPadding.top;

    return Reactive.build3(
      alerts,
      isAnimatingBack,
      openedFirstAlertFromExpandedPanel,
      builder: (context, alerts, animatingBack, toPanel) {
        final count = alerts.length;
        final bool canExpand = (() {
          if (count == 0) return true;
          if (count > 1) return false;
          // assert(count == 1);
          if (!animatingBack) return false;
          // assert(animatingBack);
          return toPanel;
        })();
        final bool shouldStayCollapsed = count == 1 && !toPanel;
        final bool clearBarrier =
            (count == 1 && animatingBack && toPanel) || (count == 0);

        return GenericAnimatedBuilder(
          curve: style.curve,
          duration: style.duration,
          value: canExpand ? e : c,
          child: topBarChild,
          builder: (context, animatedExpandedHeight, topBarChild) {
            return ValueListenableBuilder(
              valueListenable: panelAnimation,
              child: topBarChild,
              builder: (context, openValue, child) {
                final definitiveHeight = shouldStayCollapsed
                    ? c
                    : openValue.rangeMap(to: (c, animatedExpandedHeight));

                return Stack(
                  children: [
                    SizedBox(
                      height: definitiveHeight,
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: false,
                        removeBottom: true,
                        child: topBarBuilder(context, child, openValue),
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        ignoring: clearBarrier,
                        child: GenericAnimatedBuilder(
                          duration: style.duration,
                          curve: style.curve,
                          value: clearBarrier ? 0 : 1,
                          child: barrier,
                          builder: (context, animatedOpacity, barrier) =>
                              Opacity(
                                opacity: count == 0 ? 0 : animatedOpacity,
                                child: barrier,
                              ),
                        ),
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

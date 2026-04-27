part of '../../../panel_frame.dart';

class _Body extends StatelessWidget {
  const _Body({
    required this.controller,
    required this.style,
    required this.child,
    required this.redirectPops,
    required this.removeTopSafe,
  });

  final AnimationController controller;
  final PanelFrameStyleData style;

  /// the body as provided by the user to the [PanelFrame] widget's body parameter
  final bool redirectPops;
  final Widget child;
  final bool removeTopSafe;

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    final double p = style.bodyParallax;

    return _OverrideMediaQueryPadding(
      // for scaffold's fab location
      alsoViewPadding: true,
      bottom: style.collapsedPanelHeight / 2,
      top: removeTopSafe ? 0 : null,
      child: frame.buildWithAlertsCount(
        // avoid parallax if showing alert
        builder: (context, alerts) => ValueListenableBuilder(
          // animate parallax translation
          valueListenable: controller,
          child: child,
          builder: (context, value, child) => PopScope(
            canPop: redirectPops ? value < 0.1 : true,
            onPopInvokedWithResult: redirectPops
                ? (didPop, result) {
                    if (didPop) return;
                    if (value >= 0.1) {
                      context.unfocus();
                      frame.closePanel();
                    }
                  }
                : null,
            child: FractionalTranslation(
              translation: alerts > 0 ? Offset.zero : Offset(0, -value * p),
              child: child!,
            ),
          ),
        ),
      ),
    );
  }
}

part of '../../../panel_frame.dart';

class _Body extends StatelessWidget {
  const _Body({
    required this.controller,
    required this.style,
    required this.child,
  });

  final AnimationController controller;
  final PanelFrameStyleData style;

  /// the body as provided by the user to the [PanelFrame] widget's body parameter
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    final double p = style.bodyParallax;

    return _OverrideMediaQueryPadding(
      // for scaffold's fab location
      alsoViewPadding: true,
      bottom: style.collapsedPanelHeight / 2,
      top: 0,
      child: frame.buildWithAlertsCount(
        // avoid parallax if showing alert
        builder: (context, alerts) => ValueListenableBuilder(
          // animate parallax translation
          valueListenable: controller,
          child: child,
          builder: (context, value, child) => FractionalTranslation(
            translation: alerts > 0 ? Offset.zero : Offset(0, -value * p),
            child: child!,
          ),
        ),
      ),
    );
  }
}

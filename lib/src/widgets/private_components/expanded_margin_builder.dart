part of '../../../panel_frame.dart';

class _ExpandedMarginBuilder extends StatelessWidget {
  const _ExpandedMarginBuilder({
    required this.child,
    required this.builder,
    required this.alertsStateValue,
    required this.style,
    required this.duration,
    required this.curve,
  });

  final Widget Function(
    BuildContext context,
    Widget child,
    EdgeInsetsGeometry openPanelMargin,
  )
  builder;

  final Widget child;

  final _AlertsState alertsStateValue;

  final PanelFrameStyleData style;

  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return _AnimatedPaddingBuilder(
      duration: duration,
      curve: curve,
      padding: alertsStateValue.resultingExpandedPanelMargin(style, context),
      child: child,
      builder: (context, child, padding) => builder(context, child!, padding),
    );
  }
}

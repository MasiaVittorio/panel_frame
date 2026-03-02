part of '../panel_frame.dart';

class _AnimatedPanel extends StatelessWidget {
  const _AnimatedPanel({
    required this.expandedContents,
    required this.collapsedContents,
    required this.value,
    required this.collapsedMargins,
    required this.openPanelMargin,
    required this.cc,
    required this.ec,
    required this.cr,
    required this.er,
    required this.cb,
    required this.eb,
    required this.collapsedParallax,
    required this.expandedParallax,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final BorderSide cb;
  final BorderSide eb;

  final double collapsedParallax;
  final double expandedParallax;

  final Widget expandedContents;
  final Widget collapsedContents;

  final double value;

  final EdgeInsetsGeometry collapsedMargins;

  final EdgeInsetsGeometry openPanelMargin;

  final void Function(DragUpdateDetails details) onDragUpdate;

  final void Function(DragEndDetails details) onDragEnd;

  final Color cc;
  final Color ec;

  final double cr;
  final double er;

  @override
  Widget build(BuildContext context) {
    final resolved = openPanelMargin.resolve(Directionality.of(context));
    return Al.bottomCenter(
      child: Padding(
        padding: EdgeInsetsGeometry.lerp(
          collapsedMargins,
          openPanelMargin,
          value,
        )!,
        child: Container(
          decoration: ShapeDecoration(
            color: Color.lerp(cc, ec, value),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: switch ((
                  resolved.bottom,
                  resolved.left,
                  resolved.right,
                )) {
                  (0, 0, 0) => Radius.circular(value.rangeMap(to: (cr, 0))),
                  _ => Radius.circular(value.rangeMap(to: (cr, er))),
                },
                top: Radius.circular(value.rangeMap(to: (cr, er))),
              ),
              side: BorderSide.lerp(cb, eb, value),
            ),
          ),
          // elevation: value.rangeMap(to: (ce, ee)),
          clipBehavior: Clip.antiAlias,
          child: Material(
            type: MaterialType.transparency,
            child: GestureDetector(
              onVerticalDragEnd: onDragEnd,
              onVerticalDragUpdate: onDragUpdate,
              child: Container(
                color: Colors.transparent,
                child: AnimatedSwitchingStack(
                  t: value,
                  first: collapsedContents,
                  second: expandedContents,
                  firstParallax: collapsedParallax,
                  secondParallax: expandedParallax,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

part of '../panel_frame.dart';

class _AnimatedPanel extends StatelessWidget {
  const _AnimatedPanel({
    required this.expandedContents,
    required this.collapsedContents,
    required this.value,
    required this.collapsedMargins,
    required this.expandedMargins,
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
    required this.neededAlertTopSafeArea,
    required this.isCurrentAlertFullScreen,
  });

  final bool Function() isCurrentAlertFullScreen;

  final Reactive<double> neededAlertTopSafeArea;

  final BorderSide cb;
  final BorderSide eb;

  final double collapsedParallax;
  final double expandedParallax;

  final Widget expandedContents;
  final Widget collapsedContents;

  final double value;

  final EdgeInsetsGeometry collapsedMargins;

  final EdgeInsetsGeometry expandedMargins;

  final void Function(DragUpdateDetails details) onDragUpdate;

  final void Function(DragEndDetails details) onDragEnd;

  final Color cc;
  final Color ec;

  final double cr;
  final double er;

  @override
  Widget build(BuildContext context) {
    final r = expandedMargins.resolve(Directionality.of(context));
    return Al.bottomCenter(
      child: Padding(
        padding: EdgeInsetsGeometry.lerp(
          collapsedMargins,
          expandedMargins,
          value,
        )!,
        child: MediaQuery.removePadding(
          removeTop: false,
          context: context,
          removeBottom:
              expandedMargins.resolve(Directionality.of(context)).bottom > 0,
          child: Container(
            decoration: ShapeDecoration(
              color: Color.lerp(cc, ec, value),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(
                    value.rangeMap(
                      to: (
                        cr,
                        switch ((r.bottom, r.left, r.right)) {
                          (0, 0, 0) => 0,
                          _ => er,
                        },
                      ),
                    ),
                  ),
                  top: Radius.circular(
                    value.rangeMap(
                      to: (
                        cr,
                        switch (neededAlertTopSafeArea.value > 0 ||
                            isCurrentAlertFullScreen()) {
                          true => 0,
                          false => er,
                        },
                      ),
                    ),
                  ),
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
      ),
    );
  }
}

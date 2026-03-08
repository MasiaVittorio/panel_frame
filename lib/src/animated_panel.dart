// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    final resolved = expandedMargins.resolve(Directionality.of(context));
    final borderRadius = BorderRadius.vertical(
      bottom: Radius.circular(
        value.rangeMap(
          to: (
            cr,
            switch ((resolved.bottom, resolved.left, resolved.right)) {
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
    );

    return FixedKeyboardHeight(
      child: MediaQuery.removePadding(
        removeTop: false,
        context: context,
        removeBottom: resolved.bottom > 0,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: Color.lerp(cc, ec, value),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: BorderSide.lerp(cb, eb, value),
            ),
          ),
          // elevation: value.rangeMap(to: (ce, ee)),
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: borderRadius,
            child: Material(
              type: MaterialType.transparency,
              child: GestureDetector(
                onVerticalDragEnd: onDragEnd,
                onVerticalDragUpdate: onDragUpdate,
                child: Container(
                  color: Colors.transparent,
                  child: AnimatedSwitchingStack(
                    forceExpandHorizontally: true,
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
      builder: (context, keyboardHeight, child) {
        return Al.bottomCenter(
          child: Padding(
            padding: EdgeInsetsGeometry.lerp(
              collapsedMargins,
              resolved + EdgeInsets.only(bottom: keyboardHeight),
              value,
            )!,
            child: child,
          ),
        );
      },
    );
  }
}

class FixedKeyboardHeight extends StatefulWidget {
  const FixedKeyboardHeight({
    super.key,
    required this.child,
    required this.builder,
  });

  final Widget? child;
  final Widget Function(
    BuildContext context,
    double keyboardHeight,
    Widget? child,
  )
  builder;

  @override
  State<FixedKeyboardHeight> createState() => _FixedKeyboardHeightState();
}

class _FixedKeyboardHeightState extends State<FixedKeyboardHeight> {
  @override
  Widget build(BuildContext context) {
    final staticSafe = MediaQuery.viewPaddingOf(context).bottom;
    return StreamBuilder(
      stream: KeyboardInsets.insets,
      builder: (context, snapshot) {
        final double keyboard = snapshot.data ?? 0;
        return widget.builder(
          context,
          keyboard <= 2 ? keyboard : keyboard + staticSafe,
          widget.child,
        );
      },
    );
  }
}

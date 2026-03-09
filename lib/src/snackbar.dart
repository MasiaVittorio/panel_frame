// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../panel_frame.dart';

class PanelSnackBarAction {
  final Widget icon;
  final VoidCallback onPressed;

  PanelSnackBarAction({required this.icon, required this.onPressed});
}

class PanelSnackBar {
  final Widget child;
  final bool fromLeft;
  final bool scrollable;
  final bool dismissible;
  final PanelSnackBarAction? action;

  // null means indefinite
  final Duration? duration;

  PanelSnackBar({
    required this.child,
    this.fromLeft = false,
    this.scrollable = false,
    this.dismissible = true,
    this.action,
    this.duration = const Duration(seconds: 3),
  });
}

class _SnackBar extends StatelessWidget {
  const _SnackBar({
    required this.snackBar,
    required this.snackbarAnimation,
    required this.curve,
  });

  final PanelSnackBar? snackBar;
  final AnimationController snackbarAnimation;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final snackBar = this.snackBar;
    if (snackBar == null) {
      return const Center(child: SizedBox.shrink());
    }
    final theme = context.theme;
    final layout = theme.layout;
    final style = PanelFrameStyle.of(context);
    final height = style.collapsedPanelHeight;
    final Offset center = Offset(height / 2, height / 2);
    final radius = BorderRadius.circular(
      style.collapsedPanelBorderRadius(context),
    );

    final frame = context.panelFrame;

    final Widget insideContent = Pad(
      horizontal: layout.margin.large,
      child: Center(child: snackBar.child),
    );

    final content = DefaultTextStyle(
      style: DefaultTextStyle.of(context).style.merge(
        theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      textAlign: TextAlign.center,
      child: IconTheme(
        data: IconTheme.of(
          context,
        ).copyWith(color: theme.colorScheme.onPrimaryContainer),
        child: Row(
          children: [
            if (snackBar.action case PanelSnackBarAction action)
              BiggestSquare(
                child: InkResponse(
                  highlightColor: Colors.transparent,
                  containedInkWell: false,
                  borderRadius: radius,
                  onTap: () {
                    action.onPressed();
                    frame.closeSnackBar();
                  },
                  child: Center(child: action.icon),
                ),
              ),
            snackBar.scrollable
                ? insideContent
                : Expanded(child: insideContent),
            const BiggestSquare(),
          ].modalReversed(snackBar.fromLeft),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: snackbarAnimation,
      child: snackBar.child,
      builder: (context, child) {
        final value = snackbarAnimation.value;
        final closeScale = curve.transform(value.rangeMap(from: (0, 0.95)));
        final clip = curve.transform(value.rangeMap(from: (0.4, 1)));
        final childOpacity = curve.transform(value.rangeMap(from: (0.5, 1)));
        final closeOpacity = curve.transform(value.rangeMap(from: (0.3, 1)));

        return Stack(
          children: [
            Positioned.fill(
              child: ClipOval(
                clipper: _CircleClipper(
                  center: center,
                  radiusFraction: clip,
                  offsetFromRight: !snackBar.fromLeft,
                ),
                child: Material(
                  color: theme.colorScheme.primaryContainer,
                  child: Opacity(
                    opacity: childOpacity,
                    child: _ScrollWrapped(snackBar: snackBar, content: content),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: snackBar.fromLeft
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: BiggestSquare(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: radius,
                      child: Align(
                        widthFactor: closeScale,
                        heightFactor: closeScale,
                        alignment: Alignment.center,
                        child: Material(
                          color: theme.colorScheme.primary,
                          child: InkWell(
                            onTap: value >= 0.9 ? frame.closeSnackBar : null,
                            child: Center(
                              child: Opacity(
                                opacity: closeOpacity,
                                child: Icon(
                                  Icons.close,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CircleClipper extends CustomClipper<Rect> {
  _CircleClipper({
    required this.center,
    required this.radiusFraction,
    required this.offsetFromRight,
  });

  final Offset center;
  final double radiusFraction;
  final bool offsetFromRight;

  @override
  Rect getClip(Size size) {
    final double xRemaining = math.max(size.width - center.dx, center.dx);
    final double yRemaining = math.max(size.height - center.dy, center.dy);
    final double maxRadius = math.sqrt(
      xRemaining * xRemaining + yRemaining * yRemaining,
    );

    final Rect rect = Rect.fromCircle(
      radius: radiusFraction * maxRadius,
      center: offsetFromRight
          ? Offset(size.width - center.dx, center.dy)
          : center,
    );

    return rect;
  }

  @override
  bool shouldReclip(_CircleClipper oldClipper) =>
      oldClipper.radiusFraction != radiusFraction ||
      oldClipper.center != center ||
      oldClipper.offsetFromRight != offsetFromRight;
}

extension _A<T> on List<T> {
  List<T> modalReversed(bool apply) => apply ? reversed.toList() : this;
}

class _ScrollWrapped extends StatelessWidget {
  const _ScrollWrapped({required this.snackBar, required this.content});

  final PanelSnackBar snackBar;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    if (!snackBar.scrollable) return content;
    return SingleChildScrollView(
      physics: switch (snackBar.dismissible) {
        false => null,
        true => CallbackScrollPhysics(
          topBounce: true,
          topBounceCallback: context.panelFrame.closeSnackBar,
          alwaysScrollable: true,
        ),
      },
      reverse: snackBar.fromLeft,
      scrollDirection: Axis.horizontal,
      child: content,
    );
  }
}

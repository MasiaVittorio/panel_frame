part of '../panel_frame.dart';

class PanelSnackBar {
  final Widget child;
  final bool fromRight;
  final bool scrollable;
  final bool dismissible;

  // null means indefinite
  final Duration? duration;

  PanelSnackBar({
    required this.child,
    this.fromRight = true,
    this.scrollable = false,
    this.dismissible = true,
    this.duration = const Duration(seconds: 3),
  });
}

// TODO: make a bunch of snackbars variants ready to use

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
      return Center(child: SizedBox.shrink());
    }
    final theme = context.theme;
    final style = PanelFrameStyle.of(context);
    final height = style.collapsedPanelHeight;
    final Offset center = Offset(height / 2, height / 2);
    final radius = BorderRadius.circular(
      style.collapsedPanelBorderRadius(context),
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
                  offsetFromRight: snackBar.fromRight,
                ),
                child: Material(
                  color: theme.colorScheme.primaryContainer,
                  child: Opacity(
                    opacity: childOpacity,
                    child: DefaultTextStyle(
                      style: DefaultTextStyle.of(context).style.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      child: IconTheme(
                        data: IconTheme.of(
                          context,
                        ).copyWith(color: theme.colorScheme.onPrimaryContainer),
                        child: snackBar.child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: snackBar.fromRight
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
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
                            onTap: value >= 0.9
                                ? context.panelFrame.closeSnackBar
                                : null,
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

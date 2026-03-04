part of '../panel_frame.dart';

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.bottomBarHeight,
    required this.safe,
    required this.style,
    required this.mediaQuery,
    required this.child,
  });

  final double bottomBarHeight;
  final EdgeInsets safe;
  final PanelFrameStyleData style;
  final MediaQueryData mediaQuery;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: bottomBarHeight + safe.bottom + style.collapsedPanelHeight / 2,
      child: MediaQuery(
        data: mediaQuery.copyWith(
          padding: mediaQuery.padding.copyWith(
            top: style.collapsedPanelHeight / 2,
          ),
        ),
        child: child,
      ),
    );
  }
}

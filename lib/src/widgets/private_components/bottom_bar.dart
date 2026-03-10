part of '../../../panel_frame.dart';

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.bottomBarHeight,
    required this.viewPadding,
    required this.style,
    required this.child,
  });

  final double bottomBarHeight;
  final EdgeInsets viewPadding; // static, non keyboard
  final PanelFrameStyleData style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          bottomBarHeight + viewPadding.bottom + style.collapsedPanelHeight / 2,
      child: _OverrideMediaQueryPadding(
        top: style.collapsedPanelHeight / 2,
        child: child,
      ),
    );
  }
}

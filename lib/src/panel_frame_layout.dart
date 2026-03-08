part of '../panel_frame.dart';

class _PanelFrameLayout extends StatelessWidget {
  const _PanelFrameLayout({
    required this.style,
    required this.theme,
    required this.viewPadding,
    required this.body,
    required this.bottomBar,
    required this.barrier,
    required this.topBar,
    required this.panel,
    required this.bottomGestures,
    required this.bottomBarHeight,
  });

  final PanelFrameStyleData style;
  final ThemeData theme;
  final EdgeInsets viewPadding; // static, non keyboard
  final _Body body;
  final _BottomBar bottomBar;
  final _Barrier barrier;
  final _TopBar topBar;
  final _Panel panel;
  final _BottomGestures bottomGestures;
  final double bottomBarHeight;

  @override
  Widget build(BuildContext context) {
    return CleanProvider(
      data: style,
      child: Scaffold(
        backgroundColor: style.scaffoldBackgroundColor(context),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Space.vertical(style.topBarCollapsedHeight + viewPadding.top),
                  Expanded(child: body),
                  bottomBar,
                ],
              ),
            ),
            Positioned(
              bottom: viewPadding.bottom,
              left: 0,
              right: 0,
              height: bottomBarHeight,
              child: bottomGestures,
            ),
            Positioned.fill(child: barrier),
            Positioned.fill(child: Al.topCenter(child: topBar)),
            Positioned.fill(child: panel),
          ],
        ),
      ),
    );
  }
}

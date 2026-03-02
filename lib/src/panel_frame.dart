part of '../panel_frame.dart';

class _PanelFrame extends StatelessWidget {
  const _PanelFrame({
    required this.style,
    required this.theme,
    required this.safe,
    required this.body,
    required this.bottomBar,
    required this.barrier,
    required this.topBar,
    required this.panel,
    required this.bottomGestures,
    required this.bottomBarHeight,
  });

  final PanelFrameStyle style;
  final ThemeData theme;
  final EdgeInsets safe;
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
        body: Stack(
          children: [
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Space.vertical(style.topBarCollapsedHeight + safe.top),
                  Expanded(child: body),
                  bottomBar,
                ],
              ),
            ),
            Positioned(
              bottom: safe.bottom,
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

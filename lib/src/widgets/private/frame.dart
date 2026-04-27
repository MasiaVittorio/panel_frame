part of '../../../panel_frame.dart';

class _Frame extends StatelessWidget {
  const _Frame({
    required this.topBar,
    required this.panel,
    required this.body,
    required this.bottomBar,
    required this.style,
    required this.barrier,
  });

  final PanelFrameStyleData style;

  /// with optional extra barrier already laid on top
  final _TopBar? topBar;

  /// with size and contents inside already animated
  final _DecoratedPanel panel;

  /// with controller animation already applied, and dismiss gestures applied if enabled
  final _Barrier barrier;

  /// with parallax translation already applied, and bottom safe area overridden with half of the collapsed panel height
  final _Body body;

  /// already has bottom gestures detector laid on top, static safe area and top padding equal to half of the collapsed panel height
  final _BottomBar bottomBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.bodyBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            top: topBar == null
                ? 0
                : style.topBarCollapsedHeight + style._viewPadding.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: body),
                bottomBar,
              ],
            ),
          ),
          Positioned.fill(child: barrier),
          if (topBar case _TopBar topBar)
            Positioned.fill(child: Al.topCenter(child: topBar)),
          Positioned.fill(child: Al.bottomCenter(child: panel)),
        ],
      ),
    );
  }
}

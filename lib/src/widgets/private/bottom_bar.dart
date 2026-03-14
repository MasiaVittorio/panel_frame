part of '../../../panel_frame.dart';

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.style,
    required this.content,
    required this.onDragEnd,
    required this.onDragUpdate,
  });

  final PanelFrameStyleData style;

  final void Function(DragEndDetails details) onDragEnd;
  final void Function(DragUpdateDetails details) onDragUpdate;

  /// the bottom bar as provided by the user to the [PanelFrame] widget's bottomBar parameter
  final PreferredSizeWidget content;

  @override
  Widget build(BuildContext context) {
    final height = content.preferredSize.height;

    return Stack(
      children: [
        SizedBox(
          height:
              height +
              style._viewPadding.bottom +
              style.collapsedPanelHeight / 2,
          child: _OverrideMediaQueryPadding(
            top: style.collapsedPanelHeight / 2,
            bottom: style._viewPadding.bottom,
            alsoViewPadding: true,
            child: content,
          ),
        ),
        Positioned(
          bottom: style._viewPadding.bottom,
          height: height,
          left: 0,
          right: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: onDragUpdate,
            onVerticalDragEnd: onDragEnd,
            child: Container(),
          ),
        ),
      ],
    );
  }
}

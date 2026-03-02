part of '../panel_frame.dart';

class _BottomGestures extends StatelessWidget {
  const _BottomGestures({required this.onDragEnd, required this.onDragUpdate});

  final void Function(DragEndDetails details) onDragEnd;
  final void Function(DragUpdateDetails details) onDragUpdate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: onDragUpdate,
      onVerticalDragEnd: onDragEnd,
      child: Container(),
    );
  }
}

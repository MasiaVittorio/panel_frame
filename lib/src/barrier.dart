part of '../panel_frame.dart';

class _Barrier extends StatelessWidget {
  const _Barrier({
    required this.style,
    required this.controller,
    required this.closePanel,
  });

  final PanelFrameStyleData style;
  final AnimationController controller;
  final VoidCallback closePanel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        return IgnorePointer(
          ignoring: value < 0.1,
          child: GestureDetector(
            onTap: style.dismissOnBarrierTap && value > 0.5 ? closePanel : null,
            child: Container(
              color: style.barrierColor.withValues(
                alpha: value.rangeMap(to: (0, style.barrierColor.a)),
              ),
              child: SizedBox.expand(),
            ),
          ),
        );
      },
    );
  }
}

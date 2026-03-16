part of '../../../panel_frame.dart';

class _Barrier extends StatelessWidget {
  const _Barrier({
    required this.style,
    required this.controller,
    required this.closePanel,
    required this.isShowingAlert,
  });

  final PanelFrameStyleData style;
  final AnimationController controller;
  final VoidCallback closePanel;
  final Reactive<bool> isShowingAlert;

  @override
  Widget build(BuildContext context) {
    void dismiss() {
      context.unfocus();
      closePanel();
    }

    return isShowingAlert.build((context, bool isShowingAlert) {
      return GenericAnimatedBuilder(
        duration: style.duration,
        curve: style.curve,
        value: isShowingAlert ? 1 : 0,
        builder: (context, alertValue, _) {
          final color = Color.lerp(
            style.panelBarrierColor,
            style.alertsBarrierColor,
            alertValue,
          );
          return ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              return IgnorePointer(
                ignoring: value < 0.1,
                child: GestureDetector(
                  onTap: style.dismissOnBarrierTap && value > 0.5
                      ? dismiss
                      : null,
                  child: Container(
                    color: color!.withValues(
                      alpha: value.rangeMap(
                        to: (0, style.alertsBarrierColor.a),
                      ),
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }
}

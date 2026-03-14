part of '../../../panel_frame.dart';

class _CollapsedPanel extends StatelessWidget {
  const _CollapsedPanel({
    required this.style,
    required this.content,
    required this.snackBar,
  });

  final PanelFrameStyleData style;
  final _SnackBar snackBar;

  /// the widget as provided by the user to the [PanelFrame] widget's collapsedPanel parameter
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: style.collapsedPanelHeight,
          width: style._collapsedPanelSize.width,
          child: content,
        ),
        Positioned.fill(child: snackBar),
      ],
    );
  }
}

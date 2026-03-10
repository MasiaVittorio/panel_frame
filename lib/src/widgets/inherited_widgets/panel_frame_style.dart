part of '../../../panel_frame.dart';

class PanelFrameStyle extends InheritedWidget {
  final PanelFrameStyleData data;

  const PanelFrameStyle({super.key, required this.data, required super.child});

  static PanelFrameStyleData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PanelFrameStyle>()!.data;
  }

  @override
  bool updateShouldNotify(PanelFrameStyle oldWidget) {
    return oldWidget.data != data;
  }
}

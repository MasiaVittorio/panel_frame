part of '../panel_frame.dart';

class PanelFrameStyle extends InheritedWidget {
  final PanelFrameStyleData style;

  const PanelFrameStyle({super.key, required this.style, required super.child});

  static PanelFrameStyleData of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<PanelFrameStyle>();
    if (inherited == null) {
      return PanelFrameStyleData.defaultStyle;
    }
    return inherited.style;
  }

  static PanelFrameStyleData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PanelFrameStyle>()?.style;
  }

  @override
  bool updateShouldNotify(PanelFrameStyle oldWidget) {
    return oldWidget.style != style;
  }
}

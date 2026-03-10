part of '../../../panel_frame.dart';

class PanelFrameDefaultsTheme extends InheritedWidget {
  final PanelFrameDefaultsThemeData data;

  const PanelFrameDefaultsTheme({
    super.key,
    required this.data,
    required super.child,
  });

  static PanelFrameDefaultsThemeData of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<PanelFrameDefaultsTheme>();
    if (inherited == null) {
      return const PanelFrameDefaultsThemeData();
    }
    return inherited.data;
  }

  static PanelFrameDefaultsThemeData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PanelFrameDefaultsTheme>()
        ?.data;
  }

  @override
  bool updateShouldNotify(PanelFrameDefaultsTheme oldWidget) {
    return oldWidget.data != data;
  }
}

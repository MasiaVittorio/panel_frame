part of '../panel_frame.dart';

abstract class PanelAlertWidget implements Widget {
  bool? get wantsToBeFullScreen;
  EdgeInsets? get overridePanelMargin => null;
}

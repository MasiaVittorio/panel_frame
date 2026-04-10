import 'dart:async';
import 'dart:math' as math;

import 'package:call_to_action/call_to_action.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:segmented_slider/segmented_slider.dart';
import 'package:sid_base/sid_base.dart';

part 'src/contracts/panel_frame_state.dart';
part 'src/state/alerts_state.dart';
part 'src/state/build_content.dart';
part 'src/state/gestures.dart';
part 'src/state/state.dart';
part 'src/theming/panel_frame_defaults_theme.dart';
part 'src/theming/panel_frame_style.dart';
part 'src/theming/panel_frame_style_customizations.dart';
part 'src/user_classes.dart';
part 'src/widgets/custom_renders/animated_switching_stack.dart';
part 'src/widgets/custom_renders/proportional_stack.dart';
part 'src/widgets/inherited_widgets/panel_frame_defaults_theme.dart';
part 'src/widgets/inherited_widgets/panel_frame_style.dart';
part 'src/widgets/private/alerts.dart';
part 'src/widgets/private/barrier.dart';
part 'src/widgets/private/body.dart';
part 'src/widgets/private/bottom_bar.dart';
part 'src/widgets/private/collapsed_panel.dart';
part 'src/widgets/private/decorated_panel.dart';
part 'src/widgets/private/expanded_panel.dart';
part 'src/widgets/private/frame.dart';
part 'src/widgets/private/override_media_query_padding.dart';
part 'src/widgets/private/snackbar.dart';
part 'src/widgets/private/top_bar.dart';
part 'src/widgets/user_components/alternatives_panel_alert.dart';
part 'src/widgets/user_components/color_picker_panel.dart';
part 'src/widgets/user_components/confirm_panel_alert.dart';
part 'src/widgets/user_components/frame_app_bar.dart';
part 'src/widgets/user_components/insert_panel_alert.dart';
part 'src/widgets/user_components/panel_header.dart';
part 'src/widgets/user_components/panel_list.dart';
part 'src/widgets/user_components/theme_variant_picker.dart';

extension PanelFrameStateExtension on BuildContext {
  PanelFrameState get panelFrame => provide<_PanelFrameState>();
  PanelFrameStyleData get panelFrameStyle => PanelFrameStyle.of(this);
}

class PanelFrame extends StatelessWidget {
  static PanelFrameState of(BuildContext context) =>
      context.provide<_PanelFrameState>();

  const PanelFrame({
    super.key,
    required this.collapsedPanel,
    required this.expandedPanel,
    required this.body,
    required this.topBarBuilder,
    required this.bottomBar,
    this.topBarChild,
    this.style,
    this.onPanelToggled,
    this.redirectPopInvocations = true,
  });

  final PreferredSizeWidget bottomBar;
  final Widget collapsedPanel;
  final Widget expandedPanel;
  final Widget body;
  final Widget Function(BuildContext context, Widget? child, double openValue)
  topBarBuilder;
  final Widget? topBarChild;

  final PanelFrameStyleCustomizations? style;
  final ValueChanged<bool>? onPanelToggled;
  final bool redirectPopInvocations;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolved = PanelFrameStyleData._from(
          context: context,
          customizations: style ?? const PanelFrameStyleCustomizations(),
          constraints: constraints,
          bottomBar: bottomBar,
        );
        return ConstrainedBox(
          constraints: constraints,
          child: PanelFrameStyle(
            data: resolved,
            child: _PanelFrame(
              collapsedPanel: collapsedPanel,
              expandedPanel: expandedPanel,
              body: body,
              topBarBuilder: topBarBuilder,
              bottomBar: bottomBar,
              topBarChild: topBarChild,
              style: resolved,
              onPanelToggled: onPanelToggled,
              redirectPopInvocations: redirectPopInvocations,
            ),
          ),
        );
      },
    );
  }
}

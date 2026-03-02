part of '../panel_frame.dart';

class _Panel extends StatelessWidget {
  const _Panel({
    required this.alertsState,
    required this.style,
    required this.duration,
    required this.curve,
    required this.controller,
    required this.collapsedPanel,
    required this.theme,
    required this.safe,
    required this.bottomBarHeight,
    required this.onDragEnd,
    required this.onDragUpdate,
    required this.expandedPanel,
    required this.onTargetAlertSizeChanged,
    required this.onPanelSizeChanged,
    required this.panelContentScrollPhysics,
    required this.neededAlertTopSafeArea,
    required this.mediaQuery,
  });

  final Reactive<double> neededAlertTopSafeArea;
  final MediaQueryData mediaQuery;
  final Widget expandedPanel;
  final ValueChanged<Size> onTargetAlertSizeChanged;
  final ValueChanged<Size> onPanelSizeChanged;
  final _AlertsState alertsState;
  final PanelFrameStyle style;
  final Duration duration;
  final Curve curve;
  final AnimationController controller;
  final Widget collapsedPanel;
  final ThemeData theme;
  final EdgeInsets safe;
  final double bottomBarHeight;
  final void Function(DragEndDetails details) onDragEnd;
  final void Function(DragUpdateDetails details) onDragUpdate;

  final ScrollPhysics panelContentScrollPhysics;

  @override
  Widget build(BuildContext context) {
    // this animates the target padding of the expanded panel
    // depending on the current alert child's requirements

    final collapsedMargins =
        EdgeInsets.symmetric(
          horizontal: style.collapsedPanelHorizontalMargin(context),
        ) +
        safe +
        EdgeInsets.only(bottom: bottomBarHeight);

    // computed once instead of inside the value builder
    final cc = style.collapsedPanelBackgroundColor(context);
    final ec = style.expandedPanelBackgroundColor(context);

    final cr = style.collapsedPanelBorderRadius(context);
    final er = style.expandedPanelBorderRadius(context);

    final cb = style.collapsedPanelBorderSide(context);
    final eb = style.expandedPanelBorderSide(context);

    final expandedPanel = Builder(
      builder: (context) {
        return MediaQuery.removePadding(
          context: context,
          removeBottom: false,
          removeTop: true,
          child: this.expandedPanel,
        );
      },
    );

    return ListenableBuilder(
      listenable: alertsState,
      builder: (context, child) {
        final expandedPanelAlertContents = _ExpandedPanelAlertContents(
          neededAlertTopSafeArea: neededAlertTopSafeArea,
          isAnimatingBack: alertsState.isAnimatingBack,
          duration: duration,
          curve: curve,
          onTargetSizeChanged: onTargetAlertSizeChanged,
          children: [...alertsState.alerts],
        );

        final double panelOrAlertTarget = switch ((
          alertsState.alerts.length,
          alertsState.isAnimatingBack,
        )) {
          (0, _) => 0,
          (1, true) => 0,
          (_, _) => 1,
        };

        final expandedPanelContents = ScrollConfiguration(
          behavior: ScrollConfiguration.of(
            context,
          ).copyWith(physics: panelContentScrollPhysics),
          child: GenericAnimatedBuilder(
            duration: duration,
            curve: curve,
            value: panelOrAlertTarget,
            child: expandedPanelAlertContents,
            builder: (context, value, child) {
              return AnimatedSwitchingStack(
                upParallaxForEqualChildren: true,
                onSizesChanged: (first, second) {
                  if (panelOrAlertTarget > 0.5) {
                    onPanelSizeChanged(second);
                  } else {
                    onPanelSizeChanged(first);
                  }
                },
                t: switch ((
                  alertsState.alerts.length,
                  alertsState.openedFirstAlertFromExpandedPanel,
                )) {
                  (1, false) => 1,
                  _ => value,
                },
                first: expandedPanel,
                second: child!,
                firstParallax: style.expandedPanelParallax,
                secondParallax: style.expandedPanelParallax,
              );
            },
          ),
        );

        return _ExpandedMarginBuilder(
          duration: duration,
          curve: curve,
          alertsStateValue: alertsState,
          style: style,
          child: expandedPanelContents,
          builder: (context, child, expandedMargins) {
            // this animates the transition of the panel from the collapsed state
            // to the open state, and all the properties entailed
            return ValueListenableBuilder(
              valueListenable: controller,
              child: child,
              builder: (context, value, child) {
                return _AnimatedPanel(
                  isCurrentAlertFullScreen: () =>
                      alertsState.isCurrentAlertFullScreen,
                  neededAlertTopSafeArea: neededAlertTopSafeArea,
                  expandedParallax: style.expandedPanelParallax,
                  collapsedParallax: style.collapsedPanelParallax,
                  value: value,
                  expandedContents: child!,
                  collapsedContents: collapsedPanel,
                  collapsedMargins: collapsedMargins,
                  expandedMargins: expandedMargins,
                  cb: cb,
                  eb: eb,
                  cc: cc,
                  ec: ec,
                  cr: cr,
                  er: er,
                  onDragUpdate: onDragUpdate,
                  onDragEnd: onDragEnd,
                );
              },
            );
          },
        );
      },
    );
  }
}

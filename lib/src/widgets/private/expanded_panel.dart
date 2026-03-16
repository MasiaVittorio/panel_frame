part of '../../../panel_frame.dart';

class _ExpandedPanel extends StatelessWidget {
  const _ExpandedPanel({
    required this.style,
    required this.expandedPanelContent,
    required this.animatedAlerts,
    required this.alertsHeightUpdate,
    required this.scrollBehavior,
    required this.showingAlertValue,
    required this.openedFirstAlertFromExpandedPanel,
    required this.isAnimatingBack,
    required this.alertsCount,
  });

  // implicitly animated outside of this widget from 0 to 1 when showing alerts compared to just having the expanded panel as the panel contents
  final double showingAlertValue;

  final PanelFrameStyleData style;

  /// already wrapped with the appropriate media query paddings and static pre-computed width and height
  final _ExpandedPanelContents expandedPanelContent;

  /// already animating between current alerts
  final _Alerts animatedAlerts;

  /// used to cache the height of the expanded panel in order to compute a delta that drives the gestures to drag the panel up and down
  final ValueChanged<double> alertsHeightUpdate;

  final ScrollBehavior scrollBehavior;

  final Reactive<bool> openedFirstAlertFromExpandedPanel;
  final bool isAnimatingBack;
  final int alertsCount;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: scrollBehavior,
      child: openedFirstAlertFromExpandedPanel.build((context, fromExpanded) {
        return _PanelAlertStack(
          t: switch ((alertsCount, fromExpanded)) {
            (0, _) => 0,
            // keep showing alert if we are animating back from the first alert
            // or animating towards the first alert and the alert was not opened
            // from the expanded panel
            // (so that the alert is still visible while the panel closes
            //  down instead of showing the expanded panel behind it)
            (1, false) => 1,
            _ => showingAlertValue,
          },
          panel: expandedPanelContent,
          alerts: animatedAlerts,
          firstParallax: style.expandedPanelParallax,
          secondParallax: style.expandedPanelParallax,
          upParallaxForEqualChildren: true,
          rightParallaxForEqualChildren: true,
          onAlertsHeightChanged: alertsHeightUpdate,
          panelSize: style._expandedPanelSize,
        );
      }),
    );
  }
}

class _PanelAlertStack extends StatelessWidget {
  const _PanelAlertStack({
    required this.t, // interpolation parameter 0..1
    required this.panel,
    required this.alerts,
    required this.onAlertsHeightChanged,
    required this.firstParallax,
    required this.secondParallax,
    required this.upParallaxForEqualChildren,
    required this.rightParallaxForEqualChildren,
    required this.panelSize,
  }) : assert(t >= 0 && t <= 1);

  final double t;
  final ValueChanged<double>? onAlertsHeightChanged;
  final double firstParallax;
  final double secondParallax;
  final bool? upParallaxForEqualChildren;
  final bool? rightParallaxForEqualChildren;
  final Size panelSize;

  final _ExpandedPanelContents panel;
  final _Alerts alerts;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: _AnimatedPAS(
        onAlertsHeightChanged: onAlertsHeightChanged,
        panelSize: panelSize,
        firstParallax: firstParallax,
        secondParallax: secondParallax,
        upParallaxForEqualChildren: upParallaxForEqualChildren,
        rightParallaxForEqualChildren: rightParallaxForEqualChildren,
        panel: Opacity(
          opacity: t.rangeMap(from: (0, .5), to: (1, 0)),
          child: panel,
        ),
        alerts: Opacity(
          opacity: t.rangeMap(from: (.5, 1), to: (0, 1)),
          child: alerts,
        ),
        t: t,
      ),
    );
  }
}

class _AnimatedPAS extends MultiChildRenderObjectWidget {
  _AnimatedPAS({
    required this.t, // interpolation parameter 0..1
    required Widget panel,
    required Widget alerts,
    required this.onAlertsHeightChanged,
    required this.firstParallax,
    required this.secondParallax,
    required this.upParallaxForEqualChildren,
    required this.rightParallaxForEqualChildren,
    required this.panelSize,
  }) : assert(t >= 0 && t <= 1),
       super(children: [panel, alerts]);

  final double t;
  final ValueChanged<double>? onAlertsHeightChanged;
  final double firstParallax;
  final double secondParallax;
  final bool? upParallaxForEqualChildren;
  final bool? rightParallaxForEqualChildren;
  final Size panelSize;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderPAS(
      t: t,
      onAlertsHeightChanged: onAlertsHeightChanged,
      firstParallax: firstParallax,
      secondParallax: secondParallax,
      upParallaxForEqualChildren: upParallaxForEqualChildren,
      rightParallaxForEqualChildren: rightParallaxForEqualChildren,
      panelSize: panelSize,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderPAS renderObject,
  ) {
    renderObject.t = t;
    renderObject.onAlertsHeightChanged = onAlertsHeightChanged;
    renderObject.panelParallax = firstParallax;
    renderObject.alertsParallax = secondParallax;
    renderObject.upParallaxForEqualChildren = upParallaxForEqualChildren;
    renderObject.rightParallaxForEqualChildren = rightParallaxForEqualChildren;
    renderObject.panelSize = panelSize;
  }
}

class _PASPD extends ContainerBoxParentData<RenderBox> {}

class _RenderPAS extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _PASPD>,
        RenderBoxContainerDefaultsMixin<RenderBox, _PASPD> {
  _RenderPAS({
    required double t,
    required this.onAlertsHeightChanged,
    required double firstParallax,
    required double secondParallax,
    required bool? upParallaxForEqualChildren,
    required bool? rightParallaxForEqualChildren,
    required Size panelSize,
  }) : _t = t,
       _panelParallax = firstParallax,
       _upParallaxForEqualChildren = upParallaxForEqualChildren,
       _rightParallaxForEqualChildren = rightParallaxForEqualChildren,
       _alertsParallax = secondParallax,
       _panelSize = panelSize;

  ValueChanged<double>? onAlertsHeightChanged;

  double get t => _t;
  double _t;
  set t(double value) {
    if (_t == value) return;
    assert(value >= 0 && value <= 1);
    _t = value;
    markNeedsLayout();
  }

  bool? get upParallaxForEqualChildren => _upParallaxForEqualChildren;
  bool? _upParallaxForEqualChildren;
  set upParallaxForEqualChildren(bool? value) {
    if (_upParallaxForEqualChildren == value) return;
    _upParallaxForEqualChildren = value;
    markNeedsLayout();
  }

  bool? get rightParallaxForEqualChildren => _rightParallaxForEqualChildren;
  bool? _rightParallaxForEqualChildren;
  set rightParallaxForEqualChildren(bool? value) {
    if (_rightParallaxForEqualChildren == value) return;
    _rightParallaxForEqualChildren = value;
    markNeedsLayout();
  }

  Size get panelSize => _panelSize;
  Size _panelSize;
  set panelSize(Size value) {
    if (_panelSize == value) return;
    _panelSize = value;
    markNeedsLayout();
  }

  double get panelParallax => _panelParallax;
  double _panelParallax;
  set panelParallax(double value) {
    if (_panelParallax == value) return;
    _panelParallax = value;
    markNeedsLayout();
  }

  double get alertsParallax => _alertsParallax;
  double _alertsParallax;
  set alertsParallax(double value) {
    if (_alertsParallax == value) return;
    _alertsParallax = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    RenderBox? a = firstChild;
    RenderBox? b = (a != null) ? (a.parentData as _PASPD).nextSibling : null;

    if (a != null) {
      a.layout(const BoxConstraints(), parentUsesSize: true);
      // panel size is provided as fixed
    }
    Size sizeB = Size.zero;
    if (b != null) {
      // alerts will still try to get the right size because their render widget already passes the right constraints to each of them
      b.layout(constraints.loosen(), parentUsesSize: true);
      sizeB = b.size;
    }

    // Interpolate dimensions between the two children using t
    double chosenWidth = _t.rangeMap(to: (panelSize.width, sizeB.width));
    double chosenHeight = _t.rangeMap(to: (panelSize.height, sizeB.height));

    size = constraints.constrain(Size(chosenWidth, chosenHeight));

    onAlertsHeightChanged?.call(sizeB.height);

    if (a != null) {
      final deltaY =
          switch (sizeB.height - panelSize.height) {
            > 0 => -1,
            < 0 => 1,
            _ => switch (_upParallaxForEqualChildren) {
              null => 0,
              true => -1,
              false => 1,
            },
          } *
          panelParallax *
          panelSize.height;
      final _PASPD apd = a.parentData as _PASPD;
      apd.offset =
          Alignment.topCenter.alongOffset(size - panelSize as Offset) +
          Offset(0, _t.rangeMap(from: (0, .6), to: (0, deltaY)));
    }
    if (b != null) {
      final _PASPD bpd = b.parentData as _PASPD;
      final deltaY =
          switch (sizeB.height - panelSize.height) {
            > 0 => 1,
            < 0 => -1,
            _ => switch (_upParallaxForEqualChildren) {
              null => 0,
              true => 1,
              false => -1,
            },
          } *
          alertsParallax *
          sizeB.height;

      bpd.offset =
          Alignment.topCenter.alongOffset(size - sizeB as Offset) +
          Offset(0, _t.rangeMap(from: (.4, 1), to: (deltaY, 0)));
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint children directly without clipping.
    RenderBox? child = firstChild;
    while (child != null) {
      final _PASPD pd = child.parentData as _PASPD;
      context.paintChild(child, offset + pd.offset);
      child = pd.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    // Only test inside the visible clipped region (size).
    if (position.dx < 0 ||
        position.dy < 0 ||
        position.dx > size.width ||
        position.dy > size.height) {
      return false;
    }
    RenderBox? child = firstChild;
    int index = 0;
    while (child != null) {
      final _PASPD pd = child.parentData as _PASPD;
      if (t.round() == index) {
        return result.addWithPaintOffset(
          offset: pd.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            return child!.hitTest(result, position: transformed);
          },
        );
      }

      child = pd.nextSibling;
      index++;
    }
    return false;
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _PASPD) {
      child.parentData = _PASPD();
    }
  }
}

class _ExpandedPanelContents extends StatelessWidget {
  const _ExpandedPanelContents({required this.child, required this.style});

  /// the expanded panel contents as provided by the user in the [PanelFrame]'s body parameter
  final Widget child;

  final PanelFrameStyleData style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: style._expandedPanelWidth,
      height: style._expandedPanelHeight,
      child: _OverrideMediaQueryPadding(
        alsoViewPadding: true,
        top: 0,
        bottom: style._expandedPanelInternalBottomSafe,
        child: child,
      ),
    );
  }
}

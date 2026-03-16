// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unused_element_parameter

part of '../../../panel_frame.dart';

class _Alerts extends StatelessWidget {
  const _Alerts({
    required this.alerts,
    required this.alertsHeightsUpdate,
    required this.neededTopSafeAreas,
    required this.style,
    required this.isAnimatingBack,
  });

  final PanelFrameStyleData style;
  final List<_PanelAlert> alerts;
  final bool isAnimatingBack;
  final List<double> neededTopSafeAreas;

  /// used to update neededTopSafeAreas
  final ValueChanged<List<double>> alertsHeightsUpdate;

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) return const SizedBox.shrink();
    final int index = switch (alerts.length) {
      1 => 0,
      final int n => isAnimatingBack ? n - 2 : n - 1,
    };

    final List<double> bottomMargins = [];
    final List<BoxConstraints> precomputedConstraints = [];
    for (final alert in alerts) {
      final topMargin = style._alertTopMargin(alert.child);
      final bottomMargin = style._alertBottomMargin(alert.child);
      bottomMargins.add(bottomMargin);
      precomputedConstraints.add(
        style._alertBoxConstraints(topMargin, bottomMargin, alert.child),
      );
    }

    return FixedKeyboardHeight(
      builder: (context, keyboardHeight, child) {
        return _AnimatedAlerts(
          index: index,
          style: style,
          precomputedConstraints: precomputedConstraints,
          alertsHeightsUpdate: alertsHeightsUpdate,
          wrappedChildren: [
            for (int i = 0; i < alerts.length; i++)
              if (style
                      ._alertInternalBottomViewPadding(bottomMargins[i])
                      .toDouble()
                  case double desiredBottom)
                CleanProvider(
                  data: _AlertMetadata(canGoBack: i != 0),
                  child: _OverrideMediaQueryPadding(
                    top: neededTopSafeAreas.tryGet(i),
                    bottom: keyboardHeight < desiredBottom
                        ? desiredBottom - keyboardHeight
                        : 0,
                    child: _SingleAlertSwitcher(
                      duration: style.duration,
                      curve: style.curve,
                      constraints: precomputedConstraints[i],
                      child: Builder(
                        builder: (context) => alerts[i].child,
                        key: ValueKey(alerts[i].id),
                      ),
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}

class _AnimatedAlerts extends StatelessWidget {
  const _AnimatedAlerts({
    required this.index,
    required this.style,
    required this.alertsHeightsUpdate,
    required this.wrappedChildren,
    required this.precomputedConstraints,
    this.positionOverlap = 0.3,
    this.opacityOverlap = 0.1,
  });

  final int index;
  final PanelFrameStyleData style;
  final ValueChanged<List<double>>? alertsHeightsUpdate;
  final List<Widget> wrappedChildren;
  final List<BoxConstraints> precomputedConstraints;

  /// 1 = the children only change opacity, never position. 0 = the children are translated by their full width so they fully avoid each other while moving
  final double positionOverlap;

  /// 0 = the children are never seen together on screen (the one that's disappearing is fully transparent by the time the one that's appearing starts to become opaque). 1 = the children begin animating their opacity immediately
  final double opacityOverlap;

  @override
  Widget build(BuildContext context) {
    final n = wrappedChildren.length;
    return GenericAnimatedBuilder(
      value: index.toDouble(),
      duration: style.duration,
      curve: style.curve,
      builder: (context, value, child) {
        return _AlertsStack(
          precomputedConstraints: precomputedConstraints,
          mainIndex: n == 1 ? 0.0 : value,
          alertsHeightsUpdate: alertsHeightsUpdate,
          children: [
            for (int i = 0; i < n; i++)
              if ((i - value).toDouble().clamp(-1, 1).toDouble()
                  case double delta)
                FractionalTranslation(
                  transformHitTests: true,
                  translation: Offset(
                    positionOverlap.rangeMap(to: (delta, 0)),
                    0,
                  ),
                  child: IgnorePointer(
                    ignoring: delta.abs() > 0.1,
                    child: Opacity(
                      opacity: delta.abs().rangeMap(
                        from: (0, opacityOverlap.rangeMap(to: (0.5, 1))),
                        to: (1, 0),
                      ),
                      child: wrappedChildren[i],
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}

extension on List<double> {
  double tryGet(int index) {
    if (index < length) return this[index];
    return 0;
  }
}

class _AlertsStack extends MultiChildRenderObjectWidget {
  const _AlertsStack({
    super.key,
    required this.mainIndex,
    required super.children,
    required this.alertsHeightsUpdate,
    required this.precomputedConstraints,
  });

  /// The index of the child that should be considered the "main" one, meaning the one that will determine the size of the _AlertsStack. It can be a non-integer value, in which case the size will be a linear interpolation between the sizes of the two closest children. If it's less than 0 or greater than the number of children - 1, it will be clamped to those values.
  final double mainIndex;

  /// to keep the target size of the children static and constant throughout the animation, in order to avoid content shifting during the animation
  final List<BoxConstraints> precomputedConstraints;

  final void Function(List<double> sizes)? alertsHeightsUpdate;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderAlertsStack(
      mainIndex: mainIndex,
      alertsHeightsUpdate: alertsHeightsUpdate,
      precomputedConstraints: precomputedConstraints,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderAlertsStack renderObject,
  ) {
    renderObject.mainIndex = mainIndex;
    renderObject.precomputedConstraints = precomputedConstraints;
    renderObject.alertsHeightsUpdate = alertsHeightsUpdate;
  }
}

class _ASPD extends ContainerBoxParentData<RenderBox> {}

class _RenderAlertsStack extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ASPD>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ASPD> {
  double _mainIndex;
  double get mainIndex => _mainIndex;
  set mainIndex(double value) {
    if (_mainIndex == value) return;
    _mainIndex = value;
    markNeedsLayout();
  }

  List<BoxConstraints> _precomputedConstraints;
  List<BoxConstraints> get precomputedConstraints => _precomputedConstraints;
  set precomputedConstraints(List<BoxConstraints> value) {
    if (listEquals(_precomputedConstraints, value)) return;
    _precomputedConstraints = value;
    markNeedsLayout();
  }

  void Function(List<double> sizes)? alertsHeightsUpdate;

  _RenderAlertsStack({
    required double mainIndex,
    required this.alertsHeightsUpdate,
    required List<BoxConstraints> precomputedConstraints,
  }) : _mainIndex = mainIndex,
       _precomputedConstraints = precomputedConstraints;

  // Sets up the data structure that holds the offset/position of each child
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ASPD) {
      child.parentData = _ASPD();
    }
  }

  static double _decideOptimalValue({
    required double mainIndex,
    required List<double> values,
    required double maxValue,
  }) {
    final int n = values.length;
    final int beforeIndex = mainIndex.floor().clamp(0, n - 1);
    final int afterIndex = mainIndex.ceil().clamp(0, n - 1);

    final double beforeValue = values[beforeIndex];
    final double afterValue = values[afterIndex];

    return switch ((mainIndex >= (n - 1), mainIndex <= 0)) {
      (true, _) => values.last,
      (_, true) => values.first,
      (false, false) => switch (beforeIndex == afterIndex) {
        true => values[beforeIndex],
        false => switch ((beforeValue.isFinite, afterValue.isFinite)) {
          (true, true) => mainIndex.rangeMap(
            from: (beforeIndex, afterIndex),
            to: (beforeValue, afterValue),
          ),
          (false, true) => afterValue,
          (true, false) => beforeValue,
          (false, false) => maxValue,
        },
      },
    };
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    final List<double> childWidths = [];
    final List<double> childHeights = [];
    int i = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final c = precomputedConstraints[i];
      child.layout(c, parentUsesSize: true);
      childWidths.add(c.maxWidth);
      childHeights.add(child.size.height);
      child = (child.parentData as _ASPD).nextSibling;
      i++;
    }

    double width = _decideOptimalValue(
      mainIndex: mainIndex,
      values: childWidths,
      maxValue: constraints.maxWidth,
    );

    double height = _decideOptimalValue(
      mainIndex: mainIndex,
      values: childHeights,
      maxValue: constraints.maxHeight,
    );

    if (!width.isFinite) width = constraints.maxWidth;
    if (!width.isFinite) width = constraints.minWidth;
    if (!height.isFinite) height = constraints.maxHeight;
    if (!height.isFinite) height = constraints.minHeight;

    size = constraints.constrain(Size(width, height));

    alertsHeightsUpdate?.call([
      for (int i = 0; i < childHeights.length; i++) childHeights[i],
    ]);

    child = firstChild;
    while (child != null) {
      final _ASPD childParentData = child.parentData as _ASPD;

      childParentData.offset = Alignment.center.alongOffset(
        size - child.size as Offset,
      );

      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = firstChild;
    int index = 0;
    while (child != null) {
      final _ASPD childParentData = child.parentData as _ASPD;

      if (index == mainIndex.round() && (index - mainIndex).abs() < 0.3) {
        // The x, y parameters have the top left of the node's box as the origin.
        return result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - childParentData.offset);
            return child!.hitTest(result, position: transformed);
          },
        );
      }

      child = childParentData.nextSibling;
      ++index;
    }
    return false;
  }
}

class _SingleAlertSwitcher extends StatefulWidget {
  const _SingleAlertSwitcher({
    super.key,
    required this.child,
    required this.constraints,
    required this.duration,
    required this.curve,
  });

  final Widget child;
  final BoxConstraints constraints;
  final Duration duration;
  final Curve curve;

  @override
  State<_SingleAlertSwitcher> createState() => _SingleAlertSwitcherState();
}

enum _ChildAim { a, b }

class _SingleAlertSwitcherState extends State<_SingleAlertSwitcher> {
  Widget? childA;
  BoxConstraints? childAConstraints;

  Widget? childB;
  BoxConstraints? childBConstraints;

  _ChildAim aim = _ChildAim.a;

  @override
  void initState() {
    super.initState();
    childA = widget.child;
    childAConstraints = widget.constraints;
  }

  @override
  void didUpdateWidget(covariant _SingleAlertSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child.key != oldWidget.child.key) {
      switch (aim) {
        case _ChildAim.a:
          childB = widget.child;
          childBConstraints = widget.constraints;
          aim = _ChildAim.b;
          return;
        case _ChildAim.b:
          childA = widget.child;
          childAConstraints = widget.constraints;
          aim = _ChildAim.a;
          return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GenericAnimatedBuilder(
      value: switch (aim) {
        _ChildAim.a => 0,
        _ChildAim.b => 1,
      },
      duration: widget.duration,
      curve: widget.curve,
      builder: (context, value, child) {
        return ClipRect(
          child: _AlertSwitcherRender(
            t: value,
            childA: Opacity(
              opacity: value.rangeMap(from: (0, 0.5), to: (1, 0)),
              child: childA,
            ),
            childB: Opacity(
              opacity: value.rangeMap(from: (0.5, 1), to: (0, 1)),
              child: childB,
            ),
            constraintsA: childAConstraints ?? BoxConstraints.tight(Size.zero),
            constraintsB: childBConstraints ?? BoxConstraints.tight(Size.zero),
          ),
        );
      },
    );
  }
}

class _AlertSwitcherRender extends MultiChildRenderObjectWidget {
  _AlertSwitcherRender({
    required this.t, // interpolation parameter 0..1 (a..b)
    required Widget childA,
    required Widget childB,
    required this.constraintsA,
    required this.constraintsB,
  }) : assert(t >= 0 && t <= 1),
       super(children: [childA, childB]);

  final double t;
  final BoxConstraints constraintsA;
  final BoxConstraints constraintsB;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSAS(
      t: t,
      constraintsA: constraintsA,
      constraintsB: constraintsB,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderSAS renderObject,
  ) {
    renderObject.t = t;
    renderObject.constraintsA = constraintsA;
    renderObject.constraintsB = constraintsB;
  }
}

class _SASPD extends ContainerBoxParentData<RenderBox> {}

class _RenderSAS extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _SASPD>,
        RenderBoxContainerDefaultsMixin<RenderBox, _SASPD> {
  _RenderSAS({
    required double t,
    required BoxConstraints constraintsA,
    required BoxConstraints constraintsB,
  }) : _t = t,
       _constraintsA = constraintsA,
       _constraintsB = constraintsB;

  double get t => _t;
  double _t;
  set t(double value) {
    if (_t == value) return;
    assert(value >= 0 && value <= 1);
    _t = value;
    markNeedsLayout();
  }

  BoxConstraints get constraintsA => _constraintsA;
  BoxConstraints _constraintsA;
  set constraintsA(BoxConstraints value) {
    if (_constraintsA == value) return;
    _constraintsA = value;
    markNeedsLayout();
  }

  BoxConstraints get constraintsB => _constraintsB;
  BoxConstraints _constraintsB;
  set constraintsB(BoxConstraints value) {
    if (_constraintsB == value) return;
    _constraintsB = value;
    markNeedsLayout();
  }

  bool get applyParallax => false;

  @override
  void performLayout() {
    RenderBox? a = firstChild;
    RenderBox? b = (a != null) ? (a.parentData as _SASPD).nextSibling : null;

    Size sizeA = Size.zero;
    if (a != null) {
      a.layout(_constraintsA, parentUsesSize: true);
      sizeA = a.size;
    }
    Size sizeB = Size.zero;
    if (b != null) {
      b.layout(_constraintsB, parentUsesSize: true);
      sizeB = b.size;
    }

    // Interpolate dimensions between the two children using t
    double chosenWidth = _t.rangeMap(to: (sizeA.width, sizeB.width));
    double chosenHeight = _t.rangeMap(to: (sizeA.height, sizeB.height));

    size = constraints.constrain(Size(chosenWidth, chosenHeight));

    if (a != null) {
      final deltaY =
          switch (sizeB.height - sizeA.height) {
            > 0 => -1,
            < 0 => 1,
            _ => -1,
          } *
          0.3 *
          sizeA.height;
      final _SASPD apd = a.parentData as _SASPD;
      apd.offset =
          Alignment.topCenter.alongOffset(size - sizeA as Offset) +
          (applyParallax
              ? Offset(0, _t.rangeMap(from: (0, .5), to: (0, deltaY)))
              : Offset.zero);
    }
    if (b != null) {
      final _SASPD bpd = b.parentData as _SASPD;
      final deltaY =
          switch (sizeB.height - sizeA.height) {
            > 0 => 1,
            < 0 => -1,
            _ => 1,
          } *
          0.3 *
          sizeB.height;

      bpd.offset =
          Alignment.topCenter.alongOffset(size - sizeB as Offset) +
          (applyParallax
              ? Offset(0, _t.rangeMap(from: (.5, 1), to: (deltaY, 0)))
              : Offset.zero);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint children directly without clipping.
    RenderBox? child = firstChild;
    while (child != null) {
      final _SASPD pd = child.parentData as _SASPD;
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
      final _SASPD pd = child.parentData as _SASPD;
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
    if (child.parentData is! _SASPD) {
      child.parentData = _SASPD();
    }
  }
}

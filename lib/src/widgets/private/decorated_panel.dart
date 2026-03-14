// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../../../panel_frame.dart';

class _DecoratedPanel extends StatelessWidget {
  const _DecoratedPanel({
    required this.panelAnimation,
    required this.collapsedPanel,
    required this.alerts,
    required this.isAnimatingBack,
    required this.style,
    required this.expandedPanelContent,
    required this.scrollBehavior,
    required this.neededTopSafeAreas,
    required this.alertsHeightsUpdate,
    required this.alertsHeightUpdate,
    required this.openedFirstAlertFromExpandedPanel,
    required this.onDragEnd,
    required this.onDragUpdate,
  });

  final void Function(DragEndDetails details) onDragEnd;
  final void Function(DragUpdateDetails details) onDragUpdate;

  final AnimationController panelAnimation;

  final _CollapsedPanel collapsedPanel;

  final Reactive<List<_PanelAlert>> alerts;
  final Reactive<bool> isAnimatingBack;
  final Reactive<bool> openedFirstAlertFromExpandedPanel;

  final PanelFrameStyleData style;

  /// already wrapped with the appropriate media query paddings and static pre-computed width and height
  final _ExpandedPanelContents expandedPanelContent;

  /// used to cache the height of the expanded panel in order to compute a delta that drives the gestures to drag the panel up and down
  /// (this animates when an alert is added or removed, we don't want to react by rebuilding widgets when this is called)
  final ValueChanged<double> alertsHeightUpdate;

  /// used to compute the needed internal safe areas on top of each alert
  /// (these don't animate, they just change when an alert is added or removed)
  final ValueChanged<List<double>> alertsHeightsUpdate;

  final ScrollBehavior scrollBehavior;

  final Reactive<List<double>> neededTopSafeAreas;

  @override
  Widget build(BuildContext context) {
    return Reactive.build2(
      alerts,
      isAnimatingBack,
      builder: (context, List<_PanelAlert> alerts, isAnimatingBack) {
        final Widget? alert = switch (alerts.length) {
          0 => null,
          1 => isAnimatingBack ? null : alerts.first.child,
          _ =>
            alerts[isAnimatingBack ? alerts.length - 2 : alerts.length - 1]
                .child,
        };

        final cd = style._collapsedDecoration;
        final epd = style._expandedPanelDecoration;
        final abm = style._alertBottomMargin(alert);

        return neededTopSafeAreas.build((context, topSafeAreas) {
          final double alertInternalTopSafe = switch (topSafeAreas.length) {
            0 => 0,
            1 => isAnimatingBack ? 0 : topSafeAreas.first,
            _ =>
              topSafeAreas[isAnimatingBack
                  ? topSafeAreas.length - 2
                  : topSafeAreas.length - 1],
          };
          final ad = style._alertDecoration(
            alert: alert,
            bottomMargin: abm,
            topInternalSafeArea: alertInternalTopSafe,
          );

          return GestureDetector(
            onVerticalDragEnd: onDragEnd,
            onVerticalDragUpdate: onDragUpdate,
            child: GenericAnimatedBuilder(
              duration: style.duration,
              curve: style.curve,
              value: abm,
              child: _Alerts(
                alerts: [for (final a in alerts) a.child],
                isAnimatingBack: isAnimatingBack,
                alertsHeightsUpdate: alertsHeightsUpdate,
                neededTopSafeAreas: topSafeAreas,
                style: style,
              ),
              builder: (context, animatedAlertBottomMargin, animatedAlerts) {
                return GenericAnimatedBuilder(
                  duration: style.duration,
                  curve: style.curve,
                  value: alert == null ? 0 : 1,
                  child: animatedAlerts,
                  builder: (context, alertValue, animatedAlerts) {
                    final ed = BoxDecoration.lerp(epd, ad, alertValue)!;

                    final double expandedBottomMargin = alertValue.rangeMap(
                      to: (
                        style._expandedPanelBottomMargin,
                        animatedAlertBottomMargin,
                      ),
                    );

                    return ValueListenableBuilder(
                      valueListenable: panelAnimation,
                      child: _ExpandedPanel(
                        alertsCount: alerts.length,
                        isAnimatingBack: isAnimatingBack,
                        expandedPanelContent: expandedPanelContent,
                        animatedAlerts: animatedAlerts as _Alerts,
                        showingAlertValue: alertValue,
                        openedFirstAlertFromExpandedPanel:
                            openedFirstAlertFromExpandedPanel,
                        alertsHeightUpdate: alertsHeightUpdate,
                        scrollBehavior: scrollBehavior,
                        style: style,
                      ),
                      builder: (context, openValue, expandedPanel) {
                        return _AnimatedDecoratedPanel(
                          collapsedPanel: collapsedPanel,
                          expandedPanel: expandedPanel as _ExpandedPanel,
                          style: style,
                          collapsedDecoration: cd,
                          expandedDecoration: ed,
                          expandedBottomMargin: expandedBottomMargin,
                          openValue: openValue,
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        });
      },
    );
  }
}

class _AnimatedDecoratedPanel extends StatelessWidget {
  const _AnimatedDecoratedPanel({
    required this.collapsedDecoration,
    required this.expandedDecoration,
    required this.style,
    required this.expandedBottomMargin,
    required this.collapsedPanel,
    required this.openValue,
    required this.expandedPanel,
  });

  final PanelFrameStyleData style;
  final _CollapsedPanel collapsedPanel;
  final _ExpandedPanel expandedPanel;
  final BoxDecoration collapsedDecoration;
  final BoxDecoration expandedDecoration;
  final double expandedBottomMargin;
  final double openValue;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration.lerp(
      collapsedDecoration,
      expandedDecoration,
      openValue,
    )!;
    final borderRadius = decoration.borderRadius;
    final color = decoration.color;
    final border = decoration.border;
    final boxShadow = decoration.boxShadow;
    return FixedKeyboardHeight(
      child: Container(
        margin: EdgeInsets.only(
          bottom: openValue.rangeMap(
            to: (style._collapsedPanelBottomMargin, expandedBottomMargin),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: color,
          boxShadow: boxShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          type: MaterialType.transparency,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              border: border,
              borderRadius: borderRadius,
            ),
            child: _CollapsedExpandedStack(
              t: openValue,
              collapsedPanel: collapsedPanel,
              collapsedSize: style._collapsedPanelSize,
              expandedPanel: expandedPanel,
              collapsedParallax: style.collapsedPanelParallax,
              expandedParallax: style.expandedPanelParallax,
            ),
          ),
        ),
      ),
      builder: (context, keyboardHeight, child) {
        return Pad(bottom: keyboardHeight, child: child);
      },
    );
  }
}

class _CollapsedExpandedStack extends StatelessWidget {
  const _CollapsedExpandedStack({
    required this.t,
    required this.collapsedPanel,
    required this.expandedPanel,
    required this.collapsedSize,
    required this.collapsedParallax,
    required this.expandedParallax,
  }) : assert(t >= 0 && t <= 1);

  final double t;

  final _CollapsedPanel collapsedPanel;
  final Size collapsedSize;

  /// size decided inside _ExpandedPanel (negotiated with alerts and their own animation)
  final _ExpandedPanel expandedPanel;

  final double collapsedParallax;
  final double expandedParallax;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: _AnimatedCES(
        firstParallax: collapsedParallax,
        secondParallax: expandedParallax,
        collapsed: Opacity(
          opacity: t.rangeMap(from: (0, .5), to: (1, 0)),
          child: IgnorePointer(ignoring: t > 0.1, child: collapsedPanel),
        ),
        collapsedSize: collapsedSize,
        expanded: Opacity(
          opacity: t.rangeMap(from: (.5, 1), to: (0, 1)),
          child: IgnorePointer(ignoring: t < 0.9, child: expandedPanel),
        ),
        t: t,
      ),
    );
  }
}

class _AnimatedCES extends MultiChildRenderObjectWidget {
  _AnimatedCES({
    required this.t, // interpolation parameter 0..1
    required Widget collapsed,
    required Widget expanded,
    required this.firstParallax,
    required this.secondParallax,
    required this.collapsedSize,
  }) : assert(t >= 0 && t <= 1),
       super(children: [collapsed, expanded]);

  final double t;
  final Size collapsedSize;
  final double firstParallax;
  final double secondParallax;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCES(
      t: t,
      firstParallax: firstParallax,
      secondParallax: secondParallax,
      collapsedSize: collapsedSize,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderCES renderObject,
  ) {
    renderObject.t = t;
    renderObject.panelParallax = firstParallax;
    renderObject.alertsParallax = secondParallax;
    renderObject.collapsedSize = collapsedSize;
  }
}

class _CESPD extends ContainerBoxParentData<RenderBox> {}

class _RenderCES extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _CESPD>,
        RenderBoxContainerDefaultsMixin<RenderBox, _CESPD> {
  _RenderCES({
    required double t,
    required double firstParallax,
    required double secondParallax,
    required Size collapsedSize,
  }) : _t = t,
       _panelParallax = firstParallax,
       _alertsParallax = secondParallax,
       _collapsedSize = collapsedSize;

  double get t => _t;
  double _t;
  set t(double value) {
    if (_t == value) return;
    assert(value >= 0 && value <= 1);
    _t = value;
    markNeedsLayout();
  }

  Size get collapsedSize => _collapsedSize;
  Size _collapsedSize;
  set collapsedSize(Size value) {
    if (_collapsedSize == value) return;
    _collapsedSize = value;
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
    RenderBox? b = (a != null) ? (a.parentData as _CESPD).nextSibling : null;

    if (a != null) {
      a.layout(BoxConstraints.tight(_collapsedSize), parentUsesSize: true);
    }
    Size sizeB = Size.zero;
    if (b != null) {
      // alerts will still try to get the right size because their render widget already passes the right constraints to each of them
      b.layout(constraints.loosen(), parentUsesSize: true);
      sizeB = b.size;
    }

    // Interpolate dimensions between the two children using t
    double chosenWidth = _t.rangeMap(to: (collapsedSize.width, sizeB.width));
    double chosenHeight = _t.rangeMap(to: (collapsedSize.height, sizeB.height));

    size = constraints.constrain(Size(chosenWidth, chosenHeight));

    if (a != null) {
      final deltaY =
          switch (sizeB.height - collapsedSize.height) {
            > 0 => -1,
            < 0 => 1,
            _ => -1,
          } *
          panelParallax *
          collapsedSize.height;
      final _CESPD apd = a.parentData as _CESPD;
      apd.offset =
          Alignment.topCenter.alongOffset(size - collapsedSize as Offset) +
          Offset(0, _t.rangeMap(from: (0, .6), to: (0, deltaY)));
    }
    if (b != null) {
      final _CESPD bpd = b.parentData as _CESPD;

      final deltaY =
          switch (sizeB.height - collapsedSize.height) {
            > 0 => 1,
            < 0 => -1,
            _ => 1,
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
    RenderBox? child = lastChild;
    while (child != null) {
      final _CESPD pd = child.parentData as _CESPD;
      context.paintChild(child, offset + pd.offset);
      child = pd.previousSibling;
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
      final _CESPD pd = child.parentData as _CESPD;
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
    if (child.parentData is! _CESPD) {
      child.parentData = _CESPD();
    }
  }
}

class FixedKeyboardHeight extends StatelessWidget {
  const FixedKeyboardHeight({super.key, this.child, required this.builder});

  final Widget? child;
  final Widget Function(
    BuildContext context,
    double keyboardHeight,
    Widget? child,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    final staticSafe = MediaQuery.viewPaddingOf(context).bottom;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return _FixedKeyboardHeight(
      staticSafe: staticSafe,
      keyboard: keyboard,
      builder: builder,
      child: child,
    );
  }
}

class _FixedKeyboardHeight extends StatefulWidget {
  const _FixedKeyboardHeight({
    required this.child,
    required this.staticSafe,
    required this.keyboard,
    required this.builder,
  });

  final Widget? child;
  final Widget Function(
    BuildContext context,
    double keyboardHeight,
    Widget? child,
  )
  builder;

  final double staticSafe;
  final double keyboard;

  @override
  State<_FixedKeyboardHeight> createState() => _FixedKeyboardHeightState();
}

class _FixedKeyboardHeightState extends State<_FixedKeyboardHeight> {
  late PersistentReactive<List<double>> lastFiveDebouncedKeyboardHeights;

  @override
  void initState() {
    super.initState();
    lastFiveDebouncedKeyboardHeights = PersistentReactive<List<double>>(
      [],
      key: 'last ten debounced keyboard heights',
      toJsonEncodable: (List<double> value) => {'values': value},
      fromJsonDecoded: (jsonDecoded) => <double>[
        for (final v in (jsonDecoded['values'] as List)) v as double,
      ],
    );
  }

  @override
  void dispose() {
    lastFiveDebouncedKeyboardHeights.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _FixedKeyboardHeight oldWidget) {
    super.didUpdateWidget(oldWidget);
    debounceKeyboardHeight(widget.keyboard);
  }

  int _id = 0;
  void debounceKeyboardHeight(double newHeight) async {
    _id++;
    // prevent overflow, we only care about relative values
    if (_id > 1000000000) _id = 0;

    final thisId = _id;
    await Future.delayed(const Duration(milliseconds: 1200));
    if (thisId != _id) return;
    if (!mounted) return;
    if (newHeight <= 10) return; // we only care about non-zero heights
    lastFiveDebouncedKeyboardHeights.value.add(newHeight);
    if (lastFiveDebouncedKeyboardHeights.value.length > 5) {
      lastFiveDebouncedKeyboardHeights.value.removeAt(0);
    }
    lastFiveDebouncedKeyboardHeights.refresh(); // saves to storage
  }

  @override
  Widget build(BuildContext context) {
    double? favoriteKeyboardHeight;
    if (lastFiveDebouncedKeyboardHeights.value.isNotEmpty) {
      for (final h in lastFiveDebouncedKeyboardHeights.value) {
        favoriteKeyboardHeight ??= h;
        if (h != favoriteKeyboardHeight) {
          favoriteKeyboardHeight = null;
          break;
        }
      }
    }
    late double finalValue;
    if (favoriteKeyboardHeight case double fav) {
      if (widget.keyboard == 0) {
        finalValue = 0;
      } else if (widget.keyboard >= fav) {
        finalValue = fav;
      } else {
        finalValue = (widget.keyboard + widget.staticSafe).clamp(0, fav);
      }
    } else {
      finalValue = widget.keyboard;
    }

    return widget.builder(context, finalValue, widget.child);
  }
}

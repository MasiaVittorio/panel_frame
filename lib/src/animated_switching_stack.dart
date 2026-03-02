part of '../panel_frame.dart';

// A small custom stack-like layout that takes exactly two children and a parameter t (0..1).
// The render object decides its own size by interpolating the two children's sizes via t,
// then constrains that to the incoming constraints. If the chosen size is smaller than a child,
// that child will be clipped.

class AnimatedSwitchingStack extends StatelessWidget {
  const AnimatedSwitchingStack({
    super.key,
    required this.t, // interpolation parameter 0..1
    required this.first,
    required this.second,
    required this.firstParallax,
    required this.secondParallax,
    this.upParallaxForEqualChildren,
    this.rightParallaxForEqualChildren,
    this.onSizesChanged,
  }) : assert(t >= 0 && t <= 1);

  final double t;
  final Widget first;
  final Widget second;
  final double firstParallax;
  final double secondParallax;
  final bool? upParallaxForEqualChildren;
  final bool? rightParallaxForEqualChildren;

  final void Function(Size first, Size second)? onSizesChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSizedStack(
        firstParallax: firstParallax,
        secondParallax: secondParallax,
        upParallaxForEqualChildren: upParallaxForEqualChildren,
        rightParallaxForEqualChildren: rightParallaxForEqualChildren,
        onSizesChanged: onSizesChanged,
        first: Opacity(
          opacity: t.rangeMap(from: (0, .5), to: (1, 0)),
          child: first,
        ),
        second: Opacity(
          opacity: t.rangeMap(from: (.5, 1), to: (0, 1)),
          child: second,
        ),
        t: t,
      ),
    );
  }
}

class AnimatedSizedStack extends MultiChildRenderObjectWidget {
  AnimatedSizedStack({
    super.key,
    required this.t, // interpolation parameter 0..1
    required Widget first,
    required Widget second,
    required this.onSizesChanged,
    required this.firstParallax,
    required this.secondParallax,
    required this.upParallaxForEqualChildren,
    required this.rightParallaxForEqualChildren,
  }) : assert(t >= 0 && t <= 1),
       super(children: [first, second]);

  final double t;
  final void Function(Size first, Size second)? onSizesChanged;
  final double firstParallax;
  final double secondParallax;
  final bool? upParallaxForEqualChildren;
  final bool? rightParallaxForEqualChildren;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderAnimatedSizedStack(
      t: t,
      onSizesChanged: onSizesChanged,
      firstParallax: firstParallax,
      secondParallax: secondParallax,
      upParallaxForEqualChildren: upParallaxForEqualChildren,
      rightParallaxForEqualChildren: rightParallaxForEqualChildren,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderAnimatedSizedStack renderObject,
  ) {
    renderObject.t = t;
    renderObject.onSizesChanged = onSizesChanged;
    renderObject.firstParallax = firstParallax;
    renderObject.secondParallax = secondParallax;
    renderObject.upParallaxForEqualChildren = upParallaxForEqualChildren;
    renderObject.rightParallaxForEqualChildren = rightParallaxForEqualChildren;
  }
}

class CustomStackParentData extends ContainerBoxParentData<RenderBox> {}

class RenderAnimatedSizedStack extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomStackParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomStackParentData> {
  RenderAnimatedSizedStack({
    required double t,
    required this.onSizesChanged,
    required double firstParallax,
    required double secondParallax,
    required bool? upParallaxForEqualChildren,
    required bool? rightParallaxForEqualChildren,
  }) : _t = t,
       _firstParallax = firstParallax,
       _upParallaxForEqualChildren = upParallaxForEqualChildren,
       _rightParallaxForEqualChildren = rightParallaxForEqualChildren,
       _secondParallax = secondParallax;

  void Function(Size first, Size second)? onSizesChanged;

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

  double get firstParallax => _firstParallax;
  double _firstParallax;
  set firstParallax(double value) {
    if (_firstParallax == value) return;
    _firstParallax = value;
    markNeedsLayout();
  }

  double get secondParallax => _secondParallax;
  double _secondParallax;
  set secondParallax(double value) {
    if (_secondParallax == value) return;
    _secondParallax = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    // Layout both children with loosened constraints so we can measure their natural sizes
    // but they won't be allowed to exceed the incoming max constraints.
    final BoxConstraints loose = constraints.loosen();

    RenderBox? a = firstChild;
    RenderBox? b = (a != null)
        ? (a.parentData as CustomStackParentData).nextSibling
        : null;

    Size sizeA = Size.zero;
    Size sizeB = Size.zero;

    if (a != null) {
      a.layout(loose, parentUsesSize: true);
      sizeA = a.size;
    }
    if (b != null) {
      b.layout(loose, parentUsesSize: true);
      sizeB = b.size;
    }

    // Interpolate dimensions between the two children using t
    double chosenWidth = sizeA.width + (sizeB.width - sizeA.width) * _t;
    double chosenHeight = sizeA.height + (sizeB.height - sizeA.height) * _t;

    // Constrain to incoming constraints
    Size computed = constraints.constrain(Size(chosenWidth, chosenHeight));
    size = computed;

    onSizesChanged?.call(sizeA, sizeB);

    if (a != null) {
      final CustomStackParentData apd = a.parentData as CustomStackParentData;
      final deltaX =
          switch (sizeB.width - sizeA.width) {
            > 0 => -1,
            < 0 => 1,
            _ => switch (_rightParallaxForEqualChildren) {
              null => 0,
              true => 1,
              false => -1,
            },
          } *
          firstParallax *
          sizeA.width;
      final deltaY =
          switch (sizeB.height - sizeA.height) {
            > 0 => -1,
            < 0 => 1,
            _ => switch (_upParallaxForEqualChildren) {
              null => 0,
              true => -1,
              false => 1,
            },
          } *
          firstParallax *
          sizeA.height;
      apd.offset = Offset(
        _t.rangeMap(from: (0, .6), to: (0, deltaX)),
        _t.rangeMap(from: (0, .6), to: (0, deltaY)),
      );
    }
    if (b != null) {
      final CustomStackParentData bpd = b.parentData as CustomStackParentData;
      final deltaX =
          switch (sizeB.width - sizeA.width) {
            > 0 => 1,
            < 0 => -1,
            _ => switch (_rightParallaxForEqualChildren) {
              null => 0,
              true => 1,
              false => -1,
            },
          } *
          secondParallax *
          sizeB.width;
      final deltaY =
          switch (sizeB.height - sizeA.height) {
            > 0 => 1,
            < 0 => -1,
            _ => switch (_upParallaxForEqualChildren) {
              null => 0,
              true => 1,
              false => -1,
            },
          } *
          secondParallax *
          sizeB.height;

      bpd.offset = Offset(
        _t.rangeMap(from: (.4, 1), to: (deltaX, 0)),
        _t.rangeMap(from: (.4, 1), to: (deltaY, 0)),
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint children directly without clipping.
    RenderBox? child = firstChild;
    while (child != null) {
      final CustomStackParentData pd =
          child.parentData as CustomStackParentData;
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
      final CustomStackParentData pd =
          child.parentData as CustomStackParentData;
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
    if (child.parentData is! CustomStackParentData) {
      child.parentData = CustomStackParentData();
    }
  }
}

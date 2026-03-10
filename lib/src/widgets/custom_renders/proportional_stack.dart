part of '../../../panel_frame.dart';

/// A widget that takes a list of children and sizes itself based on the size of one of them, determined by the [mainIndex] parameter. The main child is the one that will determine the size of the ProportionalStack, but all children will be laid out and painted on top of each other, aligned in the stack depending on the [alignment] parameter. The mainIndex can be a non-integer value, in which case the size will be a linear interpolation between the sizes of the two closest children. If it's less than 0 or greater than the number of children - 1, it will be clamped to those values. If [expandHorizontally] is true, the width will always be the maximum width constraint, and if [expandVertically] is true, the height will always be the maximum height constraint, regardless of the mainIndex.
class ProportionalStack extends MultiChildRenderObjectWidget {
  const ProportionalStack({
    super.key,
    required this.mainIndex,
    required super.children,
    this.expandHorizontally = true,
    this.expandVertically = false,
    this.onTargetSizeChanged,
    this.alignment = Alignment.center,
    this.ignoreFirstChildSize = false,
  });

  final bool ignoreFirstChildSize;

  /// The index of the child that should be considered the "main" one, meaning the one that will determine the size of the ProportionalStack. It can be a non-integer value, in which case the size will be a linear interpolation between the sizes of the two closest children. If it's less than 0 or greater than the number of children - 1, it will be clamped to those values.
  final double mainIndex;

  /// If true, the ProportionalStack will expand to fill the maximum width constraint, and the mainIndex will be ignored for the width calculation. If false, the width will be determined by the mainIndex as described above.
  final bool expandHorizontally;

  /// If true, the ProportionalStack will expand to fill the maximum height constraint, and the mainIndex will be ignored for the height calculation. If false, the height will be determined by the mainIndex as described above.
  final bool expandVertically;

  /// You should NEVER trigger a rebuild with this callback, but if you need to cache the size of this widget for some reason, you can use this callback to be notified of size changes. It will be called at least once after the first layout, and then every time the size changes. The size is the one that was decided by the layout algorithm, so it will already take into account the constraints and the mainIndex.
  final void Function(Size size)? onTargetSizeChanged;

  final Alignment alignment;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderProportionalStack(
      mainIndex: mainIndex,
      expandHorizontally: expandHorizontally,
      expandVertically: expandVertically,
      onTargetSizeChanged: onTargetSizeChanged,
      alignment: alignment,
      ignoreFirstChildSize: ignoreFirstChildSize,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderProportionalStack renderObject,
  ) {
    renderObject.mainIndex = mainIndex;
    renderObject.expandHorizontally = expandHorizontally;
    renderObject.expandVertically = expandVertically;
    renderObject.onTargetSizeChanged = onTargetSizeChanged;
    renderObject.alignment = alignment;
    renderObject.ignoreFirstChildSize = ignoreFirstChildSize;
  }
}

class RenderProportionalStack extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  bool _ignoreFirstChildSize;
  bool get ignoreFirstChildSize => _ignoreFirstChildSize;
  set ignoreFirstChildSize(bool value) {
    if (_ignoreFirstChildSize == value) return;
    _ignoreFirstChildSize = value;
    markNeedsLayout();
  }

  double _mainIndex;
  double get mainIndex => _mainIndex;
  set mainIndex(double value) {
    if (_mainIndex == value) return;
    _mainIndex = value;
    markNeedsLayout();
  }

  bool _expandHorizontally;
  bool get expandHorizontally => _expandHorizontally;
  set expandHorizontally(bool value) {
    if (_expandHorizontally == value) return;
    _expandHorizontally = value;
    markNeedsLayout();
  }

  bool _expandVertically;
  bool get expandVertically => _expandVertically;
  set expandVertically(bool value) {
    if (_expandVertically == value) return;
    _expandVertically = value;
    markNeedsLayout();
  }

  Alignment _alignment;
  Alignment get alignment => _alignment;
  set alignment(Alignment value) {
    if (_alignment == value) return;
    _alignment = value;
    markNeedsLayout();
  }

  void Function(Size size)? onTargetSizeChanged;

  RenderProportionalStack({
    required double mainIndex,
    required this.onTargetSizeChanged,
    required Alignment alignment,
    required bool expandHorizontally,
    required bool expandVertically,
    required bool ignoreFirstChildSize,
  }) : _mainIndex = mainIndex,
       _expandHorizontally = expandHorizontally,
       _expandVertically = expandVertically,
       _alignment = alignment,
       _ignoreFirstChildSize = ignoreFirstChildSize;

  // Sets up the data structure that holds the offset/position of each child
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  static double _decideOptimalValue({
    required double mainIndex,
    required List<double> values,
    required double maxValue,
    required bool expand,
    required bool ignoreFirst,
  }) {
    final int n = values.length;
    final int beforeIndex = mainIndex.floor().clamp(0, n - 1);
    final int afterIndex = mainIndex.ceil().clamp(0, n - 1);

    final double beforeValue = values[beforeIndex];
    final double afterValue = values[afterIndex];
    if (ignoreFirst && beforeIndex == 0) {
      return afterValue;
    }

    return switch ((expand, mainIndex >= (n - 1), mainIndex <= 0)) {
      (true, _, _) => maxValue,
      (false, true, _) => values.last,
      (false, _, true) => values.first,
      (false, false, false) => switch (beforeIndex == afterIndex) {
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

  static double _decideTargetValue({
    required double mainIndex,
    required List<double> values,
    required double maxValue,
    required bool expand,
    required bool ignoreFirst,
  }) {
    final int n = values.length;
    final int beforeIndex = mainIndex.floor().clamp(0, n - 1);
    final int afterIndex = mainIndex.ceil().clamp(0, n - 1);

    final double beforeValue = values[beforeIndex];
    final double afterValue = values[afterIndex];
    if (ignoreFirst && beforeIndex == 0) {
      return afterValue;
    }

    return switch ((expand, mainIndex >= (n - 1), mainIndex <= 0)) {
      (true, _, _) => maxValue,
      (false, true, _) => values.last,
      (false, _, true) => values.first,
      (false, false, false) => switch (beforeIndex == afterIndex) {
        true => values[beforeIndex],
        false => switch ((beforeValue.isFinite, afterValue.isFinite)) {
          (true, true) =>
            mainIndex.round() == afterIndex ? afterValue : beforeValue,
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

    if (expandHorizontally && expandVertically) {
      size = constraints.biggest;
    } else {
      final List<double> childWidths = [];
      final List<double> childHeights = [];
      RenderBox? child = firstChild;
      while (child != null) {
        child.layout(constraints, parentUsesSize: true);
        childWidths.add(child.size.width);
        childHeights.add(child.size.height);
        child = (child.parentData as MultiChildLayoutParentData).nextSibling;
      }

      double width = _decideOptimalValue(
        mainIndex: mainIndex,
        values: childWidths,
        maxValue: constraints.maxWidth,
        expand: expandHorizontally,
        ignoreFirst: ignoreFirstChildSize,
      );

      double height = _decideOptimalValue(
        mainIndex: mainIndex,
        values: childHeights,
        maxValue: constraints.maxHeight,
        expand: expandVertically,
        ignoreFirst: ignoreFirstChildSize,
      );

      if (!width.isFinite) {
        width = constraints.maxWidth;
      }
      if (!width.isFinite) {
        width = constraints.minWidth;
      }
      if (!height.isFinite) {
        height = constraints.maxHeight;
      }
      if (!height.isFinite) {
        height = constraints.minHeight;
      }

      size = constraints.constrain(Size(width, height));

      onTargetSizeChanged?.call(
        Size(
          _decideTargetValue(
            mainIndex: mainIndex,
            values: childWidths,
            maxValue: constraints.maxWidth,
            expand: expandHorizontally,
            ignoreFirst: ignoreFirstChildSize,
          ),
          _decideTargetValue(
            mainIndex: mainIndex,
            values: childHeights,
            maxValue: constraints.maxHeight,
            expand: expandVertically,
            ignoreFirst: ignoreFirstChildSize,
          ),
        ),
      );
    }

    RenderBox? child = firstChild;
    while (child != null) {
      final MultiChildLayoutParentData childParentData =
          child.parentData as MultiChildLayoutParentData;

      childParentData.offset = alignment.alongOffset(
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
      final MultiChildLayoutParentData childParentData =
          child.parentData as MultiChildLayoutParentData;

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

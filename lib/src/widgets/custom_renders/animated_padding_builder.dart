// ignore_for_file: unused_element_parameter

part of '../../../panel_frame.dart';

class _AnimatedPaddingBuilder extends ImplicitlyAnimatedWidget {
  /// Creates a widget that insets its child by a value that animates
  /// implicitly.
  _AnimatedPaddingBuilder({
    super.key,
    required this.padding,
    required this.builder,
    required this.child,
    super.curve,
    required super.duration,
    super.onEnd,
  }) : assert(padding.isNonNegative);

  /// The amount of space by which to inset the child.
  final EdgeInsets padding;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget Function(BuildContext context, Widget? child, EdgeInsets padding)
  builder;

  final Widget? child;

  @override
  AnimatedWidgetBaseState<_AnimatedPaddingBuilder> createState() =>
      _AnimatedPaddingState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
  }
}

class _AnimatedPaddingState
    extends AnimatedWidgetBaseState<_AnimatedPaddingBuilder> {
  EdgeInsetsTween? _padding;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _padding =
        visitor(
              _padding,
              widget.padding,
              (dynamic value) => EdgeInsetsTween(begin: value as EdgeInsets),
            )
            as EdgeInsetsTween?;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      widget.child,
      _padding!
              .evaluate(animation)
              .clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity)
          as EdgeInsets,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(
      DiagnosticsProperty<EdgeInsetsTween>(
        'padding',
        _padding,
        defaultValue: null,
      ),
    );
  }
}

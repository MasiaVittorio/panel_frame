// ignore_for_file: unused_element_parameter

part of '../../../panel_frame.dart';

class _ExpandedPanelAlertContents extends StatelessWidget {
  const _ExpandedPanelAlertContents({
    required this.children,
    required this.isAnimatingBack,
    required this.duration,
    required this.curve,
    required this.onTargetSizeChanged,
    required this.neededAlertTopSafeArea,
    this.positionOverlap = 0.3,
    this.opacityOverlap = 0.1,
  });

  final Curve curve;

  final Reactive<double> neededAlertTopSafeArea;

  final ValueChanged<Size> onTargetSizeChanged;

  final List<Widget> children;

  /// normally display last child, but if we're animating back, display the second to last child, so that the last one can be animated out of the screen and only later be removed from the list of children
  final bool isAnimatingBack;

  final Duration duration;

  /// 1 = the children only change opacity, never position. 0 = the children are translated by their full width so they fully avoid each other while moving
  final double positionOverlap;

  /// 0 = the children are never seen together on screen (the one that's disappearing is fully transparent by the time the one that's appearing starts to become opaque). 1 = the children begin animating their opacity immediately
  final double opacityOverlap;

  @override
  Widget build(BuildContext context) {
    final int displayedIndex = switch (children.length) {
      0 => 0,
      1 => 0,
      final int n => isAnimatingBack ? n - 2 : n - 1,
    };
    return neededAlertTopSafeArea.build((context, alertTopSafeArea) {
      return GenericAnimatedBuilder(
        value: displayedIndex.toDouble(),
        duration: duration,
        curve: curve,
        builder: (context, mainIndex, child) {
          final list = <Widget>[];
          for (int i = 0; i < children.length; i++) {
            final double delta = (i - mainIndex).toDouble().clamp(-1, 1);
            // delta is 0 when i is the displayed index, < 0 when i is too small so must go to the left, > 0 when i is too big so must go to the right
            list.add(
              CleanProvider(
                data: _AlertMetadata(canGoBack: i != 0),
                child: _OverrideMediaQueryPadding(
                  top: alertTopSafeArea,
                  child: FractionalTranslation(
                    transformHitTests: true,
                    translation: Offset(
                      positionOverlap.rangeMap(to: (delta, 0)),
                      0,
                    ),
                    child: Opacity(
                      opacity: delta.abs().rangeMap(
                        from: (0, opacityOverlap.rangeMap(to: (0.5, 1))),
                        to: (1, 0),
                      ),
                      child: children[i],
                    ),
                  ),
                ),
              ),
            );
          }
          // only hit tests the mainIndex child
          return ProportionalStack(
            onTargetSizeChanged: onTargetSizeChanged,
            alignment: Alignment.topCenter,
            expandHorizontally: true,
            expandVertically: false,
            mainIndex: mainIndex,
            children: list,
          );
        },
      );
    });
  }
}

class _AlertMetadata {
  final bool canGoBack;

  _AlertMetadata({required this.canGoBack});
}

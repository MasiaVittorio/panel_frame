import 'package:flutter/material.dart';

class OverrideMediaQueryPadding extends StatelessWidget {
  const OverrideMediaQueryPadding({
    super.key,
    this.bottom,
    this.top,
    required this.child,
    this.alsoViewPadding = false,
  });
  final double? bottom;
  final double? top;
  final Widget child;
  final bool alsoViewPadding;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return MediaQuery(
      data: mq.copyWith(
        padding: mq.padding.copyWith(bottom: bottom, top: top),
        viewPadding: alsoViewPadding
            ? mq.viewPadding.copyWith(bottom: bottom, top: top)
            : null,
      ),
      child: child,
    );
  }
}

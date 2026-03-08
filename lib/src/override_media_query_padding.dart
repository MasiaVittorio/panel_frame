import 'package:flutter/material.dart';

class OverrideMediaQueryPadding extends StatelessWidget {
  const OverrideMediaQueryPadding({
    super.key,
    this.bottom,
    this.top,
    required this.child,
  });
  final double? bottom;
  final double? top;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return MediaQuery(
      data: mq.copyWith(
        padding: mq.padding.copyWith(bottom: bottom, top: top),
      ),
      child: child,
    );
  }
}

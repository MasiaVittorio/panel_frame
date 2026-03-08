part of '../../panel_frame.dart';

class HeaderedList extends StatelessWidget {
  const HeaderedList.shrink({
    super.key,
    required this.children,
    this.title,
    this.showDragHandle,
    this.bottom,
    this.wrapBottomChildWithSafeArea = true,
    this.addVerticalMarginAroundBottomChild = true,
  }) : height = null,
       shrinkWrap = true,
       floatingBottom = false;

  const HeaderedList.expand({
    super.key,
    required this.children,
    this.height,
    this.title,
    this.showDragHandle,
    this.bottom,
    this.wrapBottomChildWithSafeArea = true,
    this.addVerticalMarginAroundBottomChild = true,
    this.floatingBottom = true,
  }) : shrinkWrap = false;

  final bool? showDragHandle;
  final Widget? title;
  final List<Widget> children;
  final Widget? bottom;
  final bool wrapBottomChildWithSafeArea;
  final bool addVerticalMarginAroundBottomChild;

  final double? height;
  final bool shrinkWrap;
  final bool floatingBottom;

  @override
  Widget build(BuildContext context) {
    final header = PanelHeader(title: title, showDragHandle: showDragHandle);
    final Widget? wrappedBottom = switch (bottom) {
      null => null,
      final Widget bottom => _WrappedBottom(
        wrapWithSafeArea: wrapBottomChildWithSafeArea,
        addVerticalMargin: addVerticalMarginAroundBottomChild,
        child: bottom,
      ),
    };

    if (shrinkWrap) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          ...children,
          wrappedBottom ?? Space.vertical(context.safe.bottom),
        ],
      );
    }

    LinearGradient getGradient() {
      final style = PanelFrameStyle.of(context);
      final headerColor = style.headerColor(context);

      return LinearGradient(
        colors: [
          headerColor,
          headerColor.withValues(
            alpha: 0.70.rangeMap(to: (headerColor.a, 1), from: (0, 0.80)),
          ),
          headerColor.withValues(alpha: 1),
          headerColor.withValues(alpha: 1),
        ],
        stops: [0, 0.5, 0.80, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                GroupedCardTheme(
                  data: GroupedCardThemeData(
                    lastPadding: context.theme.layout.margin.medium / 2,
                  ),
                  child: ListView(
                    padding: context.safe.copyWith(
                      top: 0,
                      bottom: bottom == null ? null : 0,
                    ),
                    children: [
                      Opacity(
                        opacity: 0,
                        child: IgnorePointer(ignoring: true, child: header),
                      ),
                      ...children,
                      if (floatingBottom)
                        if (wrappedBottom case Widget wrappedBottom)
                          Opacity(
                            opacity: 0,
                            child: IgnorePointer(
                              ignoring: true,
                              child: wrappedBottom,
                            ),
                          ),
                    ],
                  ),
                ),
                Positioned(top: 0, left: 0, right: 0, child: header),
                if (floatingBottom)
                  if (wrappedBottom case Widget wrappedBottom)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(gradient: getGradient()),
                        child: wrappedBottom,
                      ),
                    ),
              ],
            ),
          ),
          if (!floatingBottom) ?wrappedBottom,
        ],
      ),
    );
  }
}

class _WrappedBottom extends StatelessWidget {
  const _WrappedBottom({
    required this.child,
    required this.wrapWithSafeArea,
    required this.addVerticalMargin,
  });

  final Widget child;
  final bool wrapWithSafeArea;
  final bool addVerticalMargin;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final double safe = wrapWithSafeArea ? context.safe.bottom : 0;
    return Pad(
      top: addVerticalMargin ? layout.margin.medium / 2 : 0,
      bottom: switch ((safe, addVerticalMargin)) {
        (0, true) => layout.margin.medium,
        (0, false) => 0,
        (final double s, _) => s,
      },
      child: child,
    );
  }
}

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
       shrinkWrap = true;
  const HeaderedList.expand({
    super.key,
    required this.children,
    this.height,
    this.title,
    this.showDragHandle,
    this.bottom,
    this.wrapBottomChildWithSafeArea = true,
    this.addVerticalMarginAroundBottomChild = true,
  }) : shrinkWrap = false;

  final bool? showDragHandle;
  final Widget? title;
  final List<Widget> children;
  final Widget? bottom;
  final bool wrapBottomChildWithSafeArea;
  final bool addVerticalMarginAroundBottomChild;

  final double? height;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final header = PanelHeader(title: title, showDragHandle: showDragHandle);

    if (shrinkWrap) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          ...children,
          if (bottom case Widget bottom)
            _WrappedBottom(
              wrapWithSafeArea: wrapBottomChildWithSafeArea,
              addVerticalMargin: addVerticalMarginAroundBottomChild,
              child: bottom,
            )
          else
            Space.vertical(context.safe.bottom),
        ],
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
                    ],
                  ),
                ),
                Positioned(top: 0, left: 0, right: 0, child: header),
              ],
            ),
          ),
          if (bottom case Widget bottom)
            _WrappedBottom(
              wrapWithSafeArea: wrapBottomChildWithSafeArea,
              addVerticalMargin: addVerticalMarginAroundBottomChild,
              child: bottom,
            ),
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

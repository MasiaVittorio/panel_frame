// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../../../panel_frame.dart';

class PanelList extends StatelessWidget {
  const PanelList.shrink({
    super.key,
    required this.children,
    this.title,
    this.showDragHandle,
    this.bottom,
    this.wrapBottomChildWithSafeArea = true,
    this.addVerticalMarginAroundBottomChild = true,
    this.trailing,
    this.padTrailing = true,
  }) : height = null,
       shrinkWrap = true,
       floatingBottom = false,
       customBuilder = null,
       builder = null;

  const PanelList.expand({
    super.key,
    required this.children,
    this.height,
    this.title,
    this.showDragHandle,
    this.bottom,
    this.wrapBottomChildWithSafeArea = true,
    this.addVerticalMarginAroundBottomChild = true,
    this.floatingBottom = true,
    this.trailing,
    this.padTrailing = true,
  }) : shrinkWrap = false,
       customBuilder = null,
       builder = null;

  const PanelList.custom({
    super.key,
    required Widget Function(
      BuildContext context,
      Widget invisibleHeader,
      Widget? invisibleBottom,
    )
    this.customBuilder,
    this.height,
    this.title,
    this.showDragHandle,
    this.bottom,
    this.wrapBottomChildWithSafeArea = true,
    this.addVerticalMarginAroundBottomChild = true,
    this.floatingBottom = true,
    this.trailing,
    this.padTrailing = true,
  }) : shrinkWrap = false,
       children = const [],
       builder = null;

  const PanelList.builder({
    super.key,
    required Widget Function(BuildContext context, int index) itemBuilder,
    required int? itemCount,
    this.height,
    this.title,
    this.showDragHandle,
    this.bottom,
    this.wrapBottomChildWithSafeArea = true,
    this.addVerticalMarginAroundBottomChild = true,
    this.floatingBottom = true,
    this.trailing,
    this.padTrailing = true,
  }) : shrinkWrap = false,
       children = const [],
       customBuilder = null,
       builder = (itemBuilder, itemCount);

  final bool? showDragHandle;
  final Widget? trailing;
  final bool padTrailing;
  final Widget? title;
  final List<Widget> children;
  final (
    Widget Function(BuildContext context, int index) itemBuilder,
    int? itemCount,
  )?
  builder;
  final Widget? bottom;
  final bool wrapBottomChildWithSafeArea;
  final bool addVerticalMarginAroundBottomChild;

  final double? height;
  final bool shrinkWrap;
  final bool floatingBottom;

  final Widget Function(
    BuildContext context,
    Widget invisibleHeader,
    Widget? invisibleBottom,
  )?
  customBuilder;

  @override
  Widget build(BuildContext context) {
    final header = PanelHeader(
      title: title,
      showDragHandle: showDragHandle,
      trailing: trailing,
      padTrailing: padTrailing,
    );
    final Widget? wrappedBottom = switch (bottom) {
      null => null,
      final Widget bottom => PanelListBottomElement(
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
                  child: switch (customBuilder) {
                    null => switch (builder) {
                      null => ListView(
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
                      final b => ListView.builder(
                        padding: context.safe.copyWith(
                          top: 0,
                          bottom: bottom == null ? null : 0,
                        ),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Opacity(
                              opacity: 0,
                              child: IgnorePointer(
                                ignoring: true,
                                child: header,
                              ),
                            );
                          }
                          if (b.$2 case int itemCount) {
                            if (floatingBottom &&
                                wrappedBottom != null &&
                                index == itemCount + 1) {
                              return Opacity(
                                opacity: 0,
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: wrappedBottom,
                                ),
                              );
                            }
                          }
                          return b.$1(context, index - 1);
                        },
                        itemCount: switch ((
                          b.$2,
                          floatingBottom && wrappedBottom != null,
                        )) {
                          (int itemCount, true) => itemCount + 2,
                          (int itemCount, false) => itemCount + 1,
                          (null, _) => null,
                        },
                      ),
                    },
                    final b => b(
                      context,
                      Opacity(
                        opacity: 0,
                        child: IgnorePointer(ignoring: true, child: header),
                      ),
                      switch (wrappedBottom) {
                        null => null,
                        final Widget wrappedBottom => Opacity(
                          opacity: 0,
                          child: IgnorePointer(
                            ignoring: true,
                            child: wrappedBottom,
                          ),
                        ),
                      },
                    ),
                  },
                ),
                Positioned(top: 0, left: 0, right: 0, child: header),
                if (floatingBottom)
                  if (wrappedBottom case Widget wrappedBottom)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: wrappedBottom,
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

class PanelListBottomElement extends StatelessWidget {
  const PanelListBottomElement({
    super.key,
    required this.child,
    this.wrapWithSafeArea = true,
    this.addVerticalMargin = true,
    this.overrideTopMargin,
  });

  final Widget child;
  final bool wrapWithSafeArea;
  final bool addVerticalMargin;
  final double? overrideTopMargin;

  @override
  Widget build(BuildContext context) {
    final style = PanelFrameStyle.of(context);
    final headerColor = style.headerColor;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
        ),
      ),
      child: _WrappedBottom(
        wrapWithSafeArea: wrapWithSafeArea,
        addVerticalMargin: addVerticalMargin,
        overrideTopMargin: overrideTopMargin,
        child: child,
      ),
    );
  }
}

class _WrappedBottom extends StatelessWidget {
  const _WrappedBottom({
    required this.child,
    required this.wrapWithSafeArea,
    required this.addVerticalMargin,
    this.overrideTopMargin,
  });

  final Widget child;
  final bool wrapWithSafeArea;
  final bool addVerticalMargin;
  final double? overrideTopMargin;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final double safe = wrapWithSafeArea ? context.safe.bottom : 0;

    return Pad(
      top:
          overrideTopMargin ??
          (addVerticalMargin ? layout.margin.medium / 2 : 0),
      bottom: switch ((safe, addVerticalMargin)) {
        (0, true) => layout.margin.medium,
        (0, false) => 0,
        (final double s, _) => s,
      },
      child: child,
    );
  }
}

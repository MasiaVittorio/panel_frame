part of '../../../panel_frame.dart';

class FrameAppBar extends StatelessWidget {
  const FrameAppBar({
    super.key,
    required this.title,
    required this.animation,
    this.panelSubtitle,
    this.showMenuButton = true,
    this.menuButtonOnTheRight = false,
    this.overrideCollapsedColor,
    this.overrideExpandedColor,
  });

  final Animation<double> animation;
  final Widget title;
  final Widget? panelSubtitle;
  final bool showMenuButton;
  final bool menuButtonOnTheRight;
  final Color? overrideExpandedColor;
  final Color? overrideCollapsedColor;

  static ButtonStyle buttonStyle(ThemeData theme) {
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(buttonBackground(theme)),
      foregroundColor: WidgetStatePropertyAll(
        theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  static Color buttonBackground(ThemeData theme) =>
      theme.colorScheme.surfaceContainer;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final frame = context.panelFrame;
    final frameStyle = context.panelFrameStyle;

    return ValueListenableBuilder(
      valueListenable: animation,
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              if (showMenuButton)
                Positioned.fill(
                  left: layout.margin.small,
                  right: layout.margin.small,
                  child: Align(
                    alignment: Alignment(menuButtonOnTheRight ? 1 : -1, 0),
                    child: IconButton(
                      style: buttonStyle(theme),
                      onPressed: frame.togglePanel,
                      icon: frame.buildWithIsTopBarExpanded(
                        builder: (context, value) {
                          return ImplicitlySwitchingIcon(
                            firstIcon: AnimatedIcons.menu_close,
                            secondIcon: AnimatedIcons.close_menu,
                            duration: const Duration(milliseconds: 300),
                            progress: value ? 1.0 : 0.0,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              Positioned.fill(
                left: layout.margin.small + (showMenuButton ? 56 : 0),
                right: layout.margin.small + (showMenuButton ? 56 : 0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DefaultTextStyle(
                        style: DefaultTextStyle.of(
                          context,
                        ).style.merge(theme.textTheme.titleLarge),
                        textAlign: TextAlign.center,
                        child: title,
                      ),
                      if (panelSubtitle case final Widget subtitle)
                        DefaultTextStyle(
                          style: DefaultTextStyle.of(
                            context,
                          ).style.merge(theme.textTheme.bodyMedium),
                          textAlign: TextAlign.center,
                          child: frame._buildCanTopBarExpand(
                            builder: (context, count, toPanel, canExpand) {
                              final stayCollapsed = count == 1 && !toPanel;
                              return GenericAnimatedBuilder(
                                value: canExpand ? 1 : 0,
                                duration: frameStyle.duration,
                                curve: frameStyle.curve,
                                child: subtitle,
                                builder: (context, value, subtitle) {
                                  return ValueListenableBuilder(
                                    valueListenable: animation,
                                    child: subtitle,
                                    builder: (context, double value, child) {
                                      return FractionallyListed(
                                        value: stayCollapsed
                                            ? 0
                                            : value.rangeMap(to: (0, value)),
                                        child: child,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      builder: (context, value, child) {
        return Container(
          color: Color.lerp(
            overrideCollapsedColor ?? frameStyle.topBarCollapsedColor,
            overrideExpandedColor ?? frameStyle.topBarExpandedColor,
            value,
          ),
          child: child,
        );
      },
    );
  }
}

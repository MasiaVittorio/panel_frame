part of '../../panel_frame.dart';

class FrameAppBar extends StatelessWidget {
  const FrameAppBar({
    super.key,
    required this.title,
    required this.openValue,
    this.panelSubtitle,
    this.showMenuButton = true,
    this.menuButtonOnTheRight = false,
  });

  final double openValue;
  final Widget title;
  final Widget? panelSubtitle;
  final bool showMenuButton;
  final bool menuButtonOnTheRight;

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
    final isExpanded = frame.isAppBarExpanded;

    return Material(
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
                    icon: isExpanded.build((context, value) {
                      return ImplicitlySwitchingIcon(
                        firstIcon: AnimatedIcons.menu_close,
                        secondIcon: AnimatedIcons.close_menu,
                        duration: const Duration(milliseconds: 300),
                        progress: value ? 1.0 : 0.0,
                      );
                    }),
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
                    if (panelSubtitle case final Widget child)
                      DefaultTextStyle(
                        style: DefaultTextStyle.of(
                          context,
                        ).style.merge(theme.textTheme.bodyMedium),
                        textAlign: TextAlign.center,
                        child: isExpanded.build((context, value) {
                          return GenericAnimatedBuilder(
                            value: value ? 1.0 : 0.0,
                            child: child,
                            builder: (context, animatedValue, child) {
                              return FractionallyListed(
                                value: animatedValue,
                                child: child,
                              );
                            },
                          );
                        }),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

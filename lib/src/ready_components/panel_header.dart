part of '../../panel_frame.dart';

class PanelHeader extends StatelessWidget {
  const PanelHeader({super.key, this.title, this.showDragHandle});

  final Widget? title;
  final bool? showDragHandle;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final style = PanelFrameStyle.of(context);
    final showDragHandle = this.showDragHandle ?? style.showDragHandleInHeaders;
    final panelFrame = context.panelFrame;
    final canGoBack =
        context.provideMaybe<_AlertMetadata>()?.canGoBack ?? false;

    return Material(
      color: style.headerColor(context),
      child: SafeArea(
        bottom: false,
        child: InkWell(
          onTap: panelFrame.previousAlert,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showDragHandle)
                Stack(
                  children: [
                    Center(
                      child: Pad(
                        vertical: canGoBack ? layout.padding.smaller : 0,
                        child: PanelDragHandle(
                          smallerVerticalMargin: title != null,
                        ),
                      ),
                    ),
                    if (canGoBack)
                      Positioned.fill(
                        left: layout.margin.small,
                        child: Al.centerLeft(
                          child: IconButton(
                            onPressed: panelFrame.previousAlert,
                            visualDensity: VisualDensity.compact,
                            icon: Icon(
                              Icons.keyboard_arrow_left_rounded,
                              color: theme.colorScheme.outline,
                            ),
                            style: FrameAppBar.buttonStyle(context.theme),
                          ),
                        ),
                      ),
                  ],
                ),
              if (title case Widget title)
                Pad(
                  bottom: layout.padding.medium,
                  child: DefaultTextStyle(
                    style: DefaultTextStyle.of(
                      context,
                    ).style.merge(theme.textTheme.titleMedium),
                    textAlign: TextAlign.center,
                    child: title,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PanelDragHandle extends StatelessWidget {
  const PanelDragHandle({super.key, this.smallerVerticalMargin = false});

  final bool smallerVerticalMargin;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: layout.margin.large,
        vertical: smallerVerticalMargin
            ? layout.margin.small
            : layout.margin.medium,
      ),
      width: layout.margin.large * 2,
      height: layout.spacing.medium,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(layout.margin.large),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
    );
  }
}

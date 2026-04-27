part of '../../../panel_frame.dart';

extension ContextCanGoBackAlert on BuildContext {
  bool get canGoBackInPanelAlert {
    return provideMaybe<_AlertMetadata>()?.canGoBack ?? false;
  }
}

class PanelHeader extends StatelessWidget {
  const PanelHeader({
    super.key,
    this.title,
    this.showDragHandle,
    this.trailing,
    this.onTap,
    this.padTrailing = true,
  });

  final Widget? title;
  final bool? showDragHandle;
  final Widget? trailing;
  final bool padTrailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final style = PanelFrameStyle.of(context);
    final showDragHandle = this.showDragHandle ?? style.showDragHandleInHeaders;
    final panelFrame = context.panelFrame;
    final canGoBack = context.canGoBackInPanelAlert;

    return Material(
      color: style.headerColor,
      child: SafeArea(
        bottom: false,
        child: InkWell(
          onTap: onTap ?? panelFrame.previousAlert,
          child: Stack(
            children: [
              Column(
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
                      horizontal: layout.margin.large,
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

              if (trailing case Widget trailing)
                padTrailing
                    ? Positioned.fill(
                        right: layout.margin.small,
                        child: Al.centerRight(child: trailing),
                      )
                    : Positioned(top: 0, bottom: 0, right: 0, child: trailing),
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

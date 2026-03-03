part of '../../panel_frame.dart';

class HeaderedList extends StatelessWidget {
  const HeaderedList({
    super.key,
    required this.children,
    this.height,
    this.title,
    this.subtitle,
    this.showDragHandle,
    this.bottom,
    this.wrapBottomChildWithSafeArea = true,
  });

  final double? height;
  final Widget? title;
  final Widget? subtitle;
  final Widget? bottom;
  final bool wrapBottomChildWithSafeArea;
  final List<Widget> children;
  final bool? showDragHandle;

  @override
  Widget build(BuildContext context) {
    final header = PanelHeader(
      title: title,
      subtitle: subtitle,
      showDragHandle: showDragHandle,
    );

    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView(
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
                Positioned(top: 0, left: 0, right: 0, child: header),
              ],
            ),
          ),
          if (bottom case Widget bottom)
            if (wrapBottomChildWithSafeArea)
              SafeArea(bottom: true, top: false, child: bottom)
            else
              bottom,
        ],
      ),
    );
  }
}

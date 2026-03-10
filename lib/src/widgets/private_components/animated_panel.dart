// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../../../panel_frame.dart';

class _AnimatedPanel extends StatelessWidget {
  const _AnimatedPanel({
    required this.expandedContents,
    required this.collapsedContents,
    required this.value,
    required this.collapsedMargins,
    required this.expandedMargins,
    required this.cc,
    required this.ec,
    required this.cr,
    required this.er,
    required this.cb,
    required this.eb,
    required this.collapsedParallax,
    required this.expandedParallax,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.neededAlertTopSafeArea,
    required this.isCurrentAlertFullScreen,
  });

  final bool Function() isCurrentAlertFullScreen;

  final Reactive<double> neededAlertTopSafeArea;

  final BorderSide cb;
  final BorderSide eb;

  final double collapsedParallax;
  final double expandedParallax;

  final Widget expandedContents;
  final Widget collapsedContents;

  final double value;

  final EdgeInsetsGeometry collapsedMargins;

  final EdgeInsetsGeometry expandedMargins;

  final void Function(DragUpdateDetails details) onDragUpdate;

  final void Function(DragEndDetails details) onDragEnd;

  final Color cc;
  final Color ec;

  final double cr;
  final double er;

  @override
  Widget build(BuildContext context) {
    final resolved = expandedMargins.resolve(Directionality.of(context));
    final borderRadius = BorderRadius.vertical(
      bottom: Radius.circular(
        value.rangeMap(
          to: (
            cr,
            switch ((resolved.bottom, resolved.left, resolved.right)) {
              (0, 0, 0) => 0,
              _ => er,
            },
          ),
        ),
      ),
      top: Radius.circular(
        value.rangeMap(
          to: (
            cr,
            switch (neededAlertTopSafeArea.value > 0 ||
                isCurrentAlertFullScreen()) {
              true => 0,
              false => er,
            },
          ),
        ),
      ),
    );

    return FixedKeyboardHeight(
      child: MediaQuery.removePadding(
        removeTop: false,
        context: context,
        removeBottom: resolved.bottom > 0,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: Color.lerp(cc, ec, value),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: BorderSide.lerp(cb, eb, value),
            ),
          ),
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
                side: BorderSide.lerp(cb, eb, value),
              ),
            ),
            position: DecorationPosition.foreground,

            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: borderRadius,
              child: Material(
                type: MaterialType.transparency,
                child: GestureDetector(
                  onVerticalDragEnd: onDragEnd,
                  onVerticalDragUpdate: onDragUpdate,
                  child: Container(
                    color: Colors.transparent,
                    child: AnimatedSwitchingStack(
                      forceExpandHorizontally: true,
                      t: value,
                      first: collapsedContents,
                      second: expandedContents,
                      firstParallax: collapsedParallax,
                      secondParallax: expandedParallax,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      builder: (context, keyboardHeight, child) {
        return Al.bottomCenter(
          child: Padding(
            padding: EdgeInsetsGeometry.lerp(
              collapsedMargins,
              resolved + EdgeInsets.only(bottom: keyboardHeight),
              value,
            )!,
            child: child,
          ),
        );
      },
    );
  }
}

class FixedKeyboardHeight extends StatelessWidget {
  const FixedKeyboardHeight({
    super.key,
    required this.child,
    required this.builder,
  });

  final Widget? child;
  final Widget Function(
    BuildContext context,
    double keyboardHeight,
    Widget? child,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    final staticSafe = MediaQuery.viewPaddingOf(context).bottom;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return _FixedKeyboardHeight(
      staticSafe: staticSafe,
      keyboard: keyboard,
      builder: builder,
      child: child,
    );
  }
}

class _FixedKeyboardHeight extends StatefulWidget {
  const _FixedKeyboardHeight({
    required this.child,
    required this.staticSafe,
    required this.keyboard,
    required this.builder,
  });

  final Widget? child;
  final Widget Function(
    BuildContext context,
    double keyboardHeight,
    Widget? child,
  )
  builder;

  final double staticSafe;
  final double keyboard;

  @override
  State<_FixedKeyboardHeight> createState() => _FixedKeyboardHeightState();
}

class _FixedKeyboardHeightState extends State<_FixedKeyboardHeight> {
  late PersistentReactive<List<double>> lastFiveDebouncedKeyboardHeights;

  @override
  void initState() {
    super.initState();
    lastFiveDebouncedKeyboardHeights = PersistentReactive<List<double>>(
      [],
      key: 'last ten debounced keyboard heights',
      toJsonEncodable: (List<double> value) => {'values': value},
      fromJsonDecoded: (jsonDecoded) => <double>[
        for (final v in (jsonDecoded['values'] as List)) v as double,
      ],
    );
  }

  @override
  void dispose() {
    lastFiveDebouncedKeyboardHeights.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _FixedKeyboardHeight oldWidget) {
    super.didUpdateWidget(oldWidget);
    debounceKeyboardHeight(widget.keyboard);
  }

  int _id = 0;
  void debounceKeyboardHeight(double newHeight) async {
    _id++;
    // prevent overflow, we only care about relative values
    if (_id > 1000000000) _id = 0;

    final thisId = _id;
    await Future.delayed(const Duration(milliseconds: 1200));
    if (thisId != _id) return;
    if (!mounted) return;
    if (newHeight <= 10) return; // we only care about non-zero heights
    lastFiveDebouncedKeyboardHeights.value.add(newHeight);
    if (lastFiveDebouncedKeyboardHeights.value.length > 5) {
      lastFiveDebouncedKeyboardHeights.value.removeAt(0);
    }
    lastFiveDebouncedKeyboardHeights.refresh(); // saves to storage
  }

  @override
  Widget build(BuildContext context) {
    double? favoriteKeyboardHeight;
    if (lastFiveDebouncedKeyboardHeights.value.isNotEmpty) {
      for (final h in lastFiveDebouncedKeyboardHeights.value) {
        favoriteKeyboardHeight ??= h;
        if (h != favoriteKeyboardHeight) {
          favoriteKeyboardHeight = null;
          break;
        }
      }
    }
    late double finalValue;
    if (favoriteKeyboardHeight case double fav) {
      if (widget.keyboard == 0) {
        finalValue = 0;
      } else if (widget.keyboard >= fav) {
        finalValue = fav;
      } else {
        finalValue = (widget.keyboard + widget.staticSafe).clamp(0, fav);
      }
    } else {
      finalValue = widget.keyboard;
    }

    return widget.builder(context, finalValue, widget.child);
  }
}

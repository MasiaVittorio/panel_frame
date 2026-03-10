part of '../../../panel_frame.dart';

class ColorPickerPanel extends StatefulWidget {
  const ColorPickerPanel({
    super.key,
    this.initialColor,
    required this.onChanged,
    this.reactImmediately = false,
  });

  final Color? initialColor;
  final ValueChanged<Color> onChanged;
  final bool reactImmediately;

  @override
  State createState() => _ColorPickerPanelState();
}

class _ColorPickerPanelState extends State<ColorPickerPanel> {
  Color? _color;
  ColorPickerMode _mode = ColorPickerMode.custom;

  @override
  void initState() {
    super.initState();

    _color = widget.initialColor ?? Colors.red.shade500;

    if (PaletteTab.allColors.contains(_color)) {
      _mode = ColorPickerMode.palette;
    } else {
      _mode = ColorPickerMode.manual;
    }
  }

  void _onColor(Color? c) => setState(() {
    _color = c;
    if (widget.reactImmediately && c != null) {
      widget.onChanged(c);
    }
  });
  void _onMode(ColorPickerMode m) => setState(() {
    _mode = m;
  });

  @override
  Widget build(BuildContext context) {
    final pages = [
      ColorPickerMode.manual,
      ColorPickerMode.custom,
      ColorPickerMode.palette,
    ];

    void submit() {
      if (_color case Color v) {
        widget.onChanged(v);
        context.panelFrame.previousAlert(v);
      }
    }

    final layout = context.theme.layout;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PanelHeader(),
        SizedBox(
          height: 350,
          child: RadioPageTransition<ColorPickerMode>(
            page: _mode,
            backgroundColor: Colors.transparent,
            orderedPages: pages,
            builder: (context, value) {
              return ClipRect(
                child: switch (value) {
                  ColorPickerMode.manual => ManualColorPicker(
                    color: _color!,
                    onChanged: _onColor,
                  ),
                  ColorPickerMode.custom => CustomColorPicker(
                    displayerUndescrollCallback: null,
                    useShadow: false,
                    color: _color,
                    onChanged: _onColor,
                  ),
                  ColorPickerMode.palette => PaletteColorPicker(
                    paletteUndescrollCallback: null,
                    backgroundColor: Colors.transparent,
                    onChanged: _onColor,
                    color: _color,
                  ),
                },
              );
            },
          ),
        ),
        Space.vertical(layout.spacing.medium),
        ColorPickerModeSlider(value: _mode, onChanged: _onMode),
        Space.vertical(layout.spacing.medium),
        CallToAction.filledOutlined.withTheme(
          theme: switch (_color) {
            null => const HighCallToActionTheme(),
            Color c => _CustomCallToActionTheme(c),
          },
          action: submit,
          label: const Text('Confirm'),
          icon: const Icon(Icons.check),
        ),
        SafeArea(top: false, child: Space.vertical(layout.spacing.medium)),
      ],
    );
  }
}

class _CustomCallToActionTheme extends PrimaryCallToActionTheme {
  final Color color;

  _CustomCallToActionTheme(this.color);

  @override
  CTAColors getActiveColors(context, theme, mode) {
    final colors = theme.colorScheme;
    return switch (mode) {
      CallToActionMode.filled => (
        background: color,
        foreground: color.contrast,
        outline: color.withValues(alpha: 0),
      ),
      CallToActionMode.empty => (
        background: colors.surface.withValues(alpha: 0),
        foreground: color,
        outline: colors.surface.withValues(alpha: 0),
      ),
      CallToActionMode.outlined => (
        background: colors.surface.withValues(alpha: 0),
        foreground: color,
        outline: color,
      ),
      CallToActionMode.filledOutlined => (
        background: color,
        foreground: color.contrast,
        outline: color.contrast,
      ),
    };
  }
}

class ColorPickerModeSlider extends StatelessWidget {
  const ColorPickerModeSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ColorPickerMode value;
  final ValueChanged<ColorPickerMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final layout = context.theme.layout;

    return SegmentedSlider<ColorPickerMode>(
      value: value,
      horizontalMargin: layout.spacing.medium,
      allowDeselectOnTap: false,
      onSelect: (value) => onChanged(value!),
      segments: [
        const SliderSegment(
          value: ColorPickerMode.manual,
          selectedIcon: Icon(Icons.format_color_fill),
          label: Text('Manual'),
        ),
        const SliderSegment(
          value: ColorPickerMode.custom,
          selectedIcon: Icon(Icons.short_text),
          label: Text('Custom'),
        ),
        SliderSegment(
          value: ColorPickerMode.palette,
          selectedIcon: Icon(MdiIcons.palette),
          unselectedIcon: Icon(MdiIcons.paletteOutline),
          label: const Text('Palette'),
        ),
      ],
    );
  }
}

part of '../../panel_frame.dart';

class ThemeVariantPanelPicker extends StatefulWidget {
  const ThemeVariantPanelPicker({
    super.key,
    required this.initialVariant,
    required this.onPicked,
    this.shouldConfirmBeforeApplying = false,
    this.height,
  });

  final double? height;
  final DynamicSchemeVariant initialVariant;
  final ValueChanged<DynamicSchemeVariant> onPicked;
  final bool shouldConfirmBeforeApplying;

  @override
  State<ThemeVariantPanelPicker> createState() =>
      _ThemeVariantPanelPickerState();
}

class _ThemeVariantPanelPickerState extends State<ThemeVariantPanelPicker> {
  late DynamicSchemeVariant _selectedVariant;

  @override
  void initState() {
    super.initState();
    _selectedVariant = widget.initialVariant;
  }

  void onChanged(DynamicSchemeVariant? value) {
    if (value != null) {
      setState(() {
        _selectedVariant = value;
      });
      if (!widget.shouldConfirmBeforeApplying) {
        widget.onPicked(value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return RadioGroup(
      groupValue: _selectedVariant,
      onChanged: onChanged,
      child: HeaderedList(
        height: widget.height,
        bottom: widget.shouldConfirmBeforeApplying
            ? CallToAction(
                action: () {
                  widget.onPicked(_selectedVariant);
                  context.panelFrame.closePanel();
                },
                label: Text(
                  MaterialLocalizations.of(context).continueButtonLabel,
                ),
              )
            : null,
        children: [
          for (final variant in DynamicSchemeVariant.values)
            RadioListTile(
              value: variant,
              title: Text(variant.name),
              subtitle: Text(
                variant.description,
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.8,
                  ),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

extension on DynamicSchemeVariant {
  String get description {
    return switch (this) {
      DynamicSchemeVariant.tonalSpot =>
        'Default for Material theme colors. Builds pastel palettes with a low chroma.',

      DynamicSchemeVariant.fidelity =>
        'The resulting color palettes match seed color, even if the seed color is very bright (high chroma).',

      DynamicSchemeVariant.monochrome => 'All colors are grayscale, no chroma.',

      DynamicSchemeVariant.neutral => 'Close to grayscale, a hint of chroma.',

      DynamicSchemeVariant.vibrant =>
        "Pastel colors, high chroma palettes. The primary palette's chroma is at maximum. Use `fidelity` instead if tokens should alter their tone to match the palette vibrancy.",

      DynamicSchemeVariant.expressive =>
        "Pastel colors, medium chroma palettes. The primary palette's hue is different from the seed color, for variety.",

      DynamicSchemeVariant.content =>
        "Almost identical to `fidelity`. Tokens and palettes match the seed color. [ColorScheme.primaryContainer] is the seed color, adjusted to ensure contrast with surfaces. The tertiary palette is analogue of the seed color.",

      DynamicSchemeVariant.rainbow =>
        "A playful theme - the seed color's hue does not appear in the theme.",

      DynamicSchemeVariant.fruitSalad =>
        "A playful theme - the seed color's hue does not appear in the theme.",
    };
  }
}

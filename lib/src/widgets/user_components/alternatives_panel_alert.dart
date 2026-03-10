part of '../../../panel_frame.dart';

class AlternativesPanelAlert<T> extends StatefulWidget {
  const AlternativesPanelAlert({
    super.key,
    required this.alternatives,
    this.onSelected,
    this.confirmationMode = const ReturnImmediately(),
    this.initialValue,
    this.title,
    this.height,
    this.shrinkWrap = true,
  }) : groupedAlternatives = const [];

  const AlternativesPanelAlert.grouped({
    super.key,
    required List<List<PanelAlternative<T>>> alternatives,
    this.onSelected,
    this.confirmationMode = const ReturnImmediately(),
    this.initialValue,
    this.title,
    this.height,
    this.shrinkWrap = true,
  }) : groupedAlternatives = alternatives,
       alternatives = const [];

  final T? initialValue;
  final List<List<PanelAlternative<T>>> groupedAlternatives;
  final List<PanelAlternative<T>> alternatives;
  // if not provided, the result will complete the future of the previously used .showAlert() method anyway
  final ValueChanged<T>? onSelected;
  // if true, radio list tiles are displayed and the user will need to tap on a confirm call to action button to submit their choice.
  final AlternativeConfirmationMode<T> confirmationMode;
  final Widget? title;

  /// only used if shrinkwrap is false
  final double? height;

  /// set to false if chilren might outgrow the available space, true if they won't
  final bool shrinkWrap;

  @override
  State<AlternativesPanelAlert<T>> createState() =>
      _AlternativesPanelAlertState<T>();
}

class _AlternativesPanelAlertState<T> extends State<AlternativesPanelAlert<T>> {
  late T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  List<List<PanelAlternative<T>>> get list => [
    if (widget.alternatives.isNotEmpty) widget.alternatives,
    ...widget.groupedAlternatives,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final frame = context.panelFrame;

    void submit(T value) {
      widget.onSelected?.call(value);
      frame.previousAlert(value);
    }

    final dangerColor = theme.colorScheme.error;

    final hasIcons = list.any(
      (group) => group.any((alternative) => alternative.icon != null),
    );

    final bool needsConfirmation = switch (widget.confirmationMode) {
      ReturnImmediately() => false,
      SelectAndConfirm() => true,
    };

    final Widget? bottom = switch (widget.confirmationMode) {
      final SelectAndConfirm<T> mode when mode.showConfirmButton =>
        CallToAction(
          label: mode.confirmLabel ?? Text("Confirm".todo),
          icon: mode.confirmIcon,
          action: switch (_selectedValue) {
            final T value => () => submit(value),
            null => null,
          },
        ),
      _ => null,
    };

    final List<Widget> children = [
      for (final group in list)
        ...[
          for (final a in group)
            tile(
              a,
              hasIcons: hasIcons,
              dangerColor: dangerColor,
              submit: submit,
            ),
        ].groupedCards(),
    ];

    final child = switch (widget.shrinkWrap) {
      true => PanelList.shrink(
        title: widget.title,
        bottom: bottom,
        children: children,
      ),
      false => PanelList.expand(
        height: widget.height,
        title: widget.title,
        bottom: bottom,
        children: children,
      ),
    };

    if (needsConfirmation) {
      return RadioGroup<T>(
        groupValue: _selectedValue,
        onChanged: (value) {
          setState(() {
            _selectedValue = value;
          });
          if (widget.confirmationMode case SelectAndConfirm<T> m) {
            m.onUnconfirmedSelection?.call(value);
          }
        },
        child: child,
      );
    } else {
      return child;
    }
  }

  Widget tile(
    PanelAlternative<T> alternative, {
    required bool hasIcons,
    required Color dangerColor,
    required ValueChanged<T> submit,
  }) {
    final Widget? leading = switch (alternative.icon) {
      null => null,
      Widget icon => _Apply(
        color: alternative.danger ? dangerColor : null,
        child: icon,
      ),
    };

    final title = _Apply(
      color: alternative.danger ? dangerColor : null,
      child: alternative.label,
    );
    if (widget.confirmationMode case SelectAndConfirm<T> mode) {
      return RadioListTile<T>(
        value: alternative.value,
        controlAffinity: hasIcons
            ? ListTileControlAffinity.trailing
            : ListTileControlAffinity.platform,
        toggleable: mode.toggleableRadios,
        title: title,
        secondary: leading,
        subtitle: alternative.subtitle,
      );
    } else {
      return ListTile(
        leading: leading,
        title: title,
        subtitle: alternative.subtitle,
        onTap: () => submit(alternative.value),
      );
    }
  }
}

class _Apply extends StatelessWidget {
  const _Apply({required this.color, required this.child});

  final Color? color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconTheme.of(context).copyWith(color: color),
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(
          context,
        ).style.merge(TextStyle(color: color)),
        child: child,
      ),
    );
  }
}

class PanelAlternative<T> {
  final T value;
  final Widget label;
  final Widget? icon;
  final Widget? subtitle;
  final bool danger;

  const PanelAlternative({
    required this.value,
    required this.label,
    this.icon,
    this.subtitle,
    this.danger = false,
  });
}

sealed class AlternativeConfirmationMode<T> {
  const AlternativeConfirmationMode();

  static const ReturnImmediately returnImmediately = ReturnImmediately();
  static const SelectAndConfirm selectAndConfirm = SelectAndConfirm();
}

final class ReturnImmediately<T> extends AlternativeConfirmationMode<T> {
  const ReturnImmediately();
}

final class SelectAndConfirm<T> extends AlternativeConfirmationMode<T> {
  final Widget? confirmLabel;
  final Widget? confirmIcon;

  final bool toggleableRadios;

  /// you can have the radio buttons be kept on the alert without closing automatically, but still react to changes as they're selected before confirmation if needed
  final ValueChanged<T?>? onUnconfirmedSelection;

  final bool showConfirmButtonWithOnUnconfirmedSelection;

  bool get showConfirmButton => switch ((
    onUnconfirmedSelection,
    showConfirmButtonWithOnUnconfirmedSelection,
  )) {
    (null, _) => true,
    (_, true) => true,
    _ => false,
  };

  const SelectAndConfirm({
    this.confirmLabel,
    this.confirmIcon,
    this.onUnconfirmedSelection,
    this.toggleableRadios = false,
    this.showConfirmButtonWithOnUnconfirmedSelection = true,
  });
}

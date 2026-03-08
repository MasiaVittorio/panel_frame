part of '../../panel_frame.dart';

class ConfirmPanelAlert extends StatelessWidget {
  const ConfirmPanelAlert({
    super.key,
    this.onConfirmed,
    required this.title,
    this.confirmLabel,
    this.cancelLabel,
    this.overrideConfirmIcon,
    this.overrideCancelIcon,
    this.danger = false,
  });

  const ConfirmPanelAlert.delete({
    super.key,
    this.onConfirmed,
    required this.title,
    this.confirmLabel = const _DeleteLabel(),
    this.cancelLabel,
    this.overrideConfirmIcon = const Icon(Icons.delete_forever_outlined),
    this.overrideCancelIcon,
    this.danger = true,
  });

  final VoidCallback? onConfirmed;
  final Widget? title;
  final Widget? confirmLabel;
  final Widget? cancelLabel;
  final Widget? overrideConfirmIcon;
  final Widget? overrideCancelIcon;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return AlternativesPanelAlert(
      title: title,
      alternatives: [
        PanelAlternative(
          value: true,
          label: confirmLabel ?? Text('Confirm'.todo),
          danger: danger,
          icon: overrideConfirmIcon ?? const Icon(Icons.check),
        ),
        PanelAlternative(
          value: false,
          label:
              cancelLabel ??
              Text(MaterialLocalizations.of(context).cancelButtonLabel),
          icon: overrideCancelIcon ?? const Icon(Icons.close),
        ),
      ],
    );
  }
}

class _DeleteLabel extends StatelessWidget {
  const _DeleteLabel();

  @override
  Widget build(BuildContext context) {
    return Text(MaterialLocalizations.of(context).deleteButtonTooltip);
  }
}

part of '../../../panel_frame.dart';

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
    this.content,
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
    this.content,
  });

  // if not provided, the alert will pop true or false and the caller can decide what to do with that. if provided, the alert will still pop true or false, but this callback can be called immediately (before the panel animation is finished)
  final VoidCallback? onConfirmed;
  final Widget? title;
  final Widget? confirmLabel;
  final Widget? cancelLabel;
  final Widget? overrideConfirmIcon;
  final Widget? overrideCancelIcon;
  final Widget? content;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return AlternativesPanelAlert(
      title: title,
      onSubmit: (value) {
        if (value) onConfirmed?.call();
      },
      content: content,
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

part of '../../../panel_frame.dart';

class InsertPanelAlert extends StatefulWidget {
  const InsertPanelAlert({
    super.key,
    this.initialValue = '',
    this.keyboardType = TextInputType.text,
    required this.label,
    this.onSubmit,
    this.confirmLabel,
    this.textCapitalization = TextCapitalization.sentences,
    this.controller,
    this.maxLines = 1,
    this.maxLength,
    this.allowEmptyString = true,
    this.trimResult = true,
  });

  final TextEditingController? controller;
  final String initialValue;
  final TextInputType keyboardType;
  final String label;
  final String? confirmLabel;
  final TextCapitalization textCapitalization;
  // if not provided, the result will complete the future of the previously used .showAlert() method anyway
  final ValueChanged<String>? onSubmit;
  final int? maxLines;
  final int? maxLength;
  final bool allowEmptyString;
  final bool trimResult;

  static Future<String> show({
    required BuildContext context,
    String initialValue = '',
    TextInputType keyboardType = TextInputType.text,
    required String label,
    String? confirmLabel,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
  }) {
    final Completer<String> completer = Completer<String>();
    context.panelFrame.showAlert(
      InsertPanelAlert(
        label: label,
        initialValue: initialValue,
        keyboardType: keyboardType,
        confirmLabel: confirmLabel,
        textCapitalization: textCapitalization,
        onSubmit: (value) {
          completer.complete(value);
        },
      ),
    );
    return completer.future;
  }

  @override
  State<InsertPanelAlert> createState() => _InsertPanelAlertState();
}

class _InsertPanelAlertState extends State<InsertPanelAlert> {
  late TextEditingController controller;
  late bool controllerProvidedByWidget;

  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    controllerProvidedByWidget = widget.controller != null;
  }

  @override
  void didUpdateWidget(covariant InsertPanelAlert oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (!controllerProvidedByWidget) {
        controller.dispose();
      }
      controller =
          widget.controller ?? TextEditingController(text: widget.initialValue);
      controllerProvidedByWidget = widget.controller != null;
    }
  }

  @override
  void dispose() {
    if (!controllerProvidedByWidget) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PanelHeader(),
          Pad(
            horizontal: layout.margin.medium,
            child: TextField(
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              autofocus: true,
              controller: controller,
              keyboardType: widget.keyboardType,
              onSubmitted: (value) {
                final text = widget.trimResult ? value.trim() : value;
                if (widget.allowEmptyString == false && text.isEmpty) return;
                widget.onSubmit?.call(text);
                context.panelFrame.previousAlert(text);
              },
              textCapitalization: widget.textCapitalization,
              decoration: InputDecoration(
                labelText: switch (widget.label) {
                  '' => null,
                  final String s => s,
                },
              ),
            ),
          ),
          Space.vertical(layout.spacing.medium),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              final text = widget.trimResult ? value.text.trim() : value.text;
              return CallToAction(
                action: text.isEmpty && !widget.allowEmptyString
                    ? null
                    : () {
                        widget.onSubmit?.call(text);
                        context.panelFrame.previousAlert(text);
                      },
                label: Text(widget.confirmLabel ?? 'Confirm'.todo),
              );
            },
          ),
          Space.vertical(layout.margin.medium),
        ],
      ),
    );
  }
}

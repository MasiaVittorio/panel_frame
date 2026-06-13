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
    this.autocompletions = const [],
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
  final Iterable<String> autocompletions;

  static Future<String> show({
    required BuildContext context,
    String initialValue = '',
    TextInputType keyboardType = TextInputType.text,
    required String label,
    String? confirmLabel,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    final Iterable<String> autocompletions = const [],
  }) {
    final Completer<String> completer = Completer<String>();
    context.panelFrame.showAlert(
      InsertPanelAlert(
        label: label,
        initialValue: initialValue,
        keyboardType: keyboardType,
        confirmLabel: confirmLabel,
        textCapitalization: textCapitalization,
        autocompletions: autocompletions,
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
  late FocusNode focusNode;

  String ignoreAutoCompletionsFor = '';

  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    focusNode = FocusNode();
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
    focusNode.dispose();
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
              focusNode: focusNode,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              autofocus: true,
              controller: controller,
              keyboardType: widget.keyboardType,
              onSubmitted: (value) {
                final text = widget.trimResult ? value.trim() : value;
                if (widget.allowEmptyString == false && text.isEmpty) {
                  return;
                }
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
              if (text != ignoreAutoCompletionsFor) {
                ignoreAutoCompletionsFor = '';
              }
              Iterable<String> autoCompletions =
                  text.trim().isEmpty || text == ignoreAutoCompletionsFor
                  ? <String>[]
                  : widget.autocompletions
                        .where(
                          (option) =>
                              option.toLowerCase().contains(
                                text.trim().toLowerCase(),
                              ) &&
                              text.trim().toLowerCase() != option.toLowerCase(),
                        )
                        .toList()
                        .take(5);

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedListed(
                    axisAlignment: 0.5,
                    listed: autoCompletions.isNotEmpty,
                    child: Pad(
                      horizontal: layout.margin.medium,
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: .horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    <Widget>[
                                      for (final option in autoCompletions)
                                        MyChip(
                                          label: option,
                                          onPressed: () {
                                            ignoreAutoCompletionsFor = option;
                                            controller.text = option;
                                            focusNode.requestFocus();
                                          },
                                        ),
                                    ].separateWith(
                                      Space.horizontal(layout.spacing.medium),
                                      alsoLast: true,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 56,
                            child: CallToAction.secondary.filled(
                              horizontalMargin: 0,
                              spaced: false,
                              action: () {
                                setState(() {
                                  ignoreAutoCompletionsFor = text;
                                });
                                focusNode.requestFocus();
                              },
                              label: const Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedListed(
                    listed: autoCompletions.isEmpty,
                    axisAlignment: -0.5,
                    child: CallToAction(
                      action: text.isEmpty && !widget.allowEmptyString
                          ? null
                          : () {
                              widget.onSubmit?.call(text);
                              context.panelFrame.previousAlert(text);
                            },
                      label: Text(widget.confirmLabel ?? 'Confirm'.todo),
                    ),
                  ),
                ],
              );
            },
          ),
          Space.vertical(layout.margin.medium),
        ],
      ),
    );
  }
}

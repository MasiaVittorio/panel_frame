import 'package:example/alerts/my_alert.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late PersistentReactive<List<String>> notes;

  @override
  void initState() {
    super.initState();
    notes = PersistentReactive<List<String>>(
      [],
      key: 'notes',
      toJsonEncodable: (value) => {'notes': value},
      fromJsonDecoded: (jsonDecoded) =>
          List<String>.from(jsonDecoded['notes'] ?? []),
    );
  }

  @override
  void dispose() {
    notes.dispose();
    super.dispose();
  }

  void addNote(String note) {
    notes.value.add(note);
    notes.refresh();
  }

  void removeNoteAt(int index) {
    notes.value.removeAt(index);
    notes.refresh();
  }

  void changeNoteAt(int index, String newNote) {
    notes.value[index] = newNote;
    notes.refresh();
  }

  void restoreNoteAt(int index, String note) {
    notes.value.insert(index, note);
    notes.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    const fabSize = 96;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: notes.build((context, value) {
        return ListView(
          padding: EdgeInsets.only(
            bottom:
                context.safe.bottom +
                fabSize +
                context.theme.layout.margin.medium,
          ),
          children: [
            for (var i = 0; i < value.length; i++)
              if (value[i] case String note)
                NoteTile(
                  onChange: (value) => changeNoteAt(i, value),
                  onDelete: () => removeNoteAt(i),
                  note: note,
                  onRestore: () => restoreNoteAt(i, note),
                ),
          ].groupedCards(),
        );
      }),
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await InsertPanelAlert.show(
            autocompletions: [
              'Apple',
              'Banana',
              'Cherry',
              'Date',
              'Elderberry',
            ],
            context: context,
            label: 'New note',
          );
          if (!context.mounted) return;
          if (result case String note) {
            addNote(note);
            frame.showSnackBar(
              PanelSnackBar(
                child: Text('You entered: $note'),
                scrollable: true,
              ),
            );
          }
        },
      ),
    );
  }
}

class NoteTile extends StatelessWidget {
  const NoteTile({
    super.key,
    required this.onChange,
    required this.onDelete,
    required this.note,
    required this.onRestore,
  });

  final ValueChanged<String> onChange;
  final VoidCallback onDelete;
  final String note;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;

    void edit() async {
      final result = await InsertPanelAlert.show(
        autocompletions: ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'],
        context: context,
        label: 'Edit note',
        initialValue: note,
      );
      if (!context.mounted) return;
      if (result case String newNote) {
        onChange(newNote);
      }
    }

    void doDelete() {
      onDelete();
      frame.showSnackBar(
        PanelSnackBar(
          child: Text('Deleted note: $note'),
          action: PanelSnackBarAction(
            icon: const Icon(Icons.undo),
            onPressed: onRestore,
          ),
        ),
      );
    }

    void promptDelete() {
      frame.showAlert(
        ConfirmPanelAlert.delete(
          title: Text('Delete $note?', overflow: TextOverflow.fade),
          onConfirmed: doDelete,
        ),
      );
    }

    final theme = context.theme;

    void showOptions() async {
      final result = await frame.showAlert(
        AlternativesPanelAlert.grouped(
          alternatives: [
            [
              const PanelAlternative(
                value: 0,
                label: Text('Delete'),
                danger: true,
                icon: Icon(Icons.delete_forever_outlined),
              ),
              const PanelAlternative(
                value: 1,
                label: Text('Edit'),
                icon: Icon(Icons.edit_outlined),
              ),
              const PanelAlternative(
                value: 2,
                label: Text('Show'),
                icon: Icon(Icons.remove_red_eye_outlined),
              ),
            ],
            [
              const PanelAlternative(
                value: 3,
                label: Text("I'm not sure"),
                icon: Icon(Icons.help_outline),
                secondaryIcon: Icon(Icons.keyboard_arrow_right),
                overrideAutoCloseOnSubmit: false,
              ),
            ],
          ],
          onSubmit: (value) {
            switch (value) {
              case 0:
                frame.showAlert(
                  ConfirmPanelAlert.delete(
                    title: Text('Delete $note?'),
                    onConfirmed: doDelete,
                  ),
                );
                return;
              case 1:
                edit();
                return;
              case 2:
                // handled outside
                return;
              case 3:
                frame.showAlert(const MyAlert(height: 400));
                return;
              default:
                frame.showSnackBar(
                  PanelSnackBar(child: Text('Unknown option: $value')),
                );
            }
          },
        ),
      );
      if (!context.mounted) return;
      switch (result) {
        case 0:
          // handled immediately
          return;
        case 1:
          // handled immediately
          return;
        case 2:
          frame.showSnackBar(
            PanelSnackBar(child: Text('This note says: "$note"')),
          );
          return;
        case 3:
          // handled immediately
          return;
        default:
          frame.showSnackBar(
            PanelSnackBar(child: Text('Unknown option: $result')),
          );
          return;
      }
    }

    return ListTile(
      title: Text(note),
      trailing: IconButton(
        icon: Icon(
          Icons.delete_forever_outlined,
          color: theme.colorScheme.error,
        ),
        onPressed: promptDelete,
      ),
      onTap: showOptions,
    );
  }
}

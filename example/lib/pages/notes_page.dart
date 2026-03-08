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

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: notes.build(
        (context, value) => ListView(
          children: [
            for (var i = 0; i < value.length; i++)
              NoteTile(
                onChange: (value) => changeNoteAt(i, value),
                onDelete: () => removeNoteAt(i),
                note: value[i],
              ),
          ].groupedCards(),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await InsertPanelAlert.show(
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
  });

  final ValueChanged<String> onChange;
  final VoidCallback onDelete;
  final String note;

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;

    void edit() async {
      final result = await InsertPanelAlert.show(
        context: context,
        label: 'Edit note',
        initialValue: note,
      );
      if (!context.mounted) return;
      if (result case String newNote) {
        onChange(newNote);
      }
    }

    void promptDelete() {
      frame.showAlert(
        ConfirmPanelAlert.delete(
          title: Text(
            'Delete $note?',
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
          onConfirmed: onDelete,
        ),
      );
    }

    final theme = context.theme;

    return ListTile(
      title: Text(note),
      trailing: IconButton(
        icon: Icon(
          Icons.delete_forever_outlined,
          color: theme.colorScheme.error,
        ),
        onPressed: promptDelete,
      ),
      onTap: edit,
    );
  }
}

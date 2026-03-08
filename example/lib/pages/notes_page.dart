// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<String> notes = [];

  void addNote(String note) {
    setState(() {
      notes.add(note);
    });
  }

  void removeNoteAt(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  void changeNoteAt(int index, String newNote) {
    setState(() {
      notes[index] = newNote;
    });
  }

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: [
          for (var i = 0; i < notes.length; i++)
            NoteTile(
              onChange: (value) => changeNoteAt(i, value),
              onDelete: () => removeNoteAt(i),
              note: notes[i],
            ),
        ].groupedCards(),
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

    void promptDelete() async {
      final result = await frame.showAlert(
        ConfirmPanelAlert.delete(
          title: Text(
            'Delete $note?',
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
        ),
      );
      if (!context.mounted) return;
      if (result == true) onDelete();
    }

    final theme = context.theme;

    void showOptions() async {
      final result = await frame.showAlert(const NoteOptionsAlert());
      if (!context.mounted) return;
      switch (result) {
        case _Option.delete:
          promptDelete();
        case _Option.edit:
          edit();
        case _Option.read:
          frame.showSnackBar(
            PanelSnackBar(child: Text('You chose to read $note')),
          );
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

class NoteOptionsAlert extends StatelessWidget {
  const NoteOptionsAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlternativesPanelAlert.grouped(
      alternatives: [
        [
          PanelAlternative(
            danger: true,
            label: Text('Delete'),
            icon: Icon(Icons.delete_forever_outlined),
            value: _Option.delete,
          ),
          PanelAlternative(
            label: Text('Edit'),
            icon: Icon(Icons.edit),
            value: _Option.edit,
          ),
        ],
        [
          PanelAlternative(
            label: Text('Read'),
            icon: Icon(Icons.read_more),
            value: _Option.read,
          ),
        ],
      ],
    );
  }
}

enum _Option { delete, edit, read }

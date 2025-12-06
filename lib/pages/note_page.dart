import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notebook/components/drawer.dart';
import 'package:notebook/components/note_tile.dart';
import 'package:notebook/models/node_database.dart';
import 'package:notebook/models/note.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // text controller for note input
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // on app startup, fetch existing notes from database
    readNotes();
  }

  // create  a note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('New Note'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Enter your note here'),
          onSubmitted: (value) {
            // save note to database
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // create button
          MaterialButton(
            onPressed: () {
              // add note to database
              context.read<NoteDatabase>().addNote(textController.text);
              // clear controller
              textController.clear();

              // pop dialog box
              Navigator.pop(context);
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  // read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // update a note
  void updateNote(Note note) {
    // pre-fill current note text
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,

        title: const Text('Edit Note'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Update your note here'),
          onSubmitted: (value) {
            // save updated note to database
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // update button
          MaterialButton(
            onPressed: () {
              // update note in database
              context.read<NoteDatabase>().updateNote(
                note.id,
                textController.text,
              );
              // clear controller
              textController.clear();
              // pop dialog box
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
  // delete a note
void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }



  @override
  Widget build(BuildContext context) {
    // note database instance
    final noteDatabase = context.watch<NoteDatabase>();

    //current notes list

    List<Note> currentNotes = noteDatabase.currentnotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add,
        color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // heading
Padding(
  padding: const EdgeInsets.only(left: 25),
  child: Text('Notes',
      style: GoogleFonts.dmSerifText(fontSize:  48, color: Theme.of(context).colorScheme.inversePrimary) ),
),
          // list of notes
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                // get individual note
                final note = currentNotes[index];
                // list title UI
                return NoteTile(text: note.text, onEditPressed: () => updateNote(note), 
                onDeletePressed: () => deleteNote(note.id),
                );





                // ListTile(
                //   title: Text(note.text),
                //   trailing: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       // edit button
                //       IconButton( 
                //         onPressed: () =>
                //             updateNote(note),
                //            icon: const Icon(Icons.edit),
                //           // show dialog to edit note,
                //       ),
                //       // delete button
                //       IconButton(
                //         icon: const Icon(Icons.delete),
                //          onPressed: () =>
                //             deleteNote(note.id),
                //       ),
                //     ],
                //   ),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}

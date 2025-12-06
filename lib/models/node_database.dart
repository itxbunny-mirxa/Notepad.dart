import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:notebook/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  // intialize database
  static Future<void> initializeDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }

  // list of notes from database
  final List<Note> currentnotes = [];



  //create - a note and save db
  Future<void> addNote(String textFromUser) async {

    // create a new note 
    final newNote = Note()..text = textFromUser;
    //save to db 
    await isar.writeTxn(() => isar.notes.put(newNote));

    //re-read notes from db
    fetchNotes();
    
  }



  //read - notes from database
Future<void> fetchNotes() async {
    final notesFromDb = await isar.notes.where().findAll();
    currentnotes.clear();
    currentnotes.addAll(notesFromDb);
    notifyListeners();
  }
  
  


  //update - a note in database

Future<void> updateNote(int id, String newText) async {
   final existingNote = await isar.notes.get(id);
   if (existingNote != null) {
     existingNote.text = newText;
     await isar.writeTxn(() => isar.notes.put(existingNote));
     await fetchNotes();
   }
  }


  //delete - a note from database

Future<void> deleteNote(int id) async {
   await isar.writeTxn(() => isar.notes.delete(id));
   await fetchNotes();
  }


}

import 'package:get/get.dart';
import '../databasehelper/db.dart';
import '../models/note.dart';

class NoteController extends GetxController {
  var notes = <Note>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final notesList = await DatabaseHelper().getNotes();
    notes.assignAll(notesList);
  }

  Future<void> addNote() async {
    final newNote = Note(
      title: 'New Note',
      content: 'Note content',
      createdDate: DateTime.now(),
    );
    await DatabaseHelper().insertNote(newNote);
    loadNotes();
  }

  Future<void> addNoteWithDetails(Note note) async {
    await DatabaseHelper().insertNote(note);
    loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await DatabaseHelper().deleteNote(id);
    loadNotes();
  }
}
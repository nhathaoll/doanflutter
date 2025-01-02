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

  Future<void> addNoteWithDetails(Note note) async {
    if (note.id == null) {
      await DatabaseHelper().insertNote(note);
    } else {
      await DatabaseHelper().updateNote(note);
    }
    loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await DatabaseHelper().deleteNote(id);
    loadNotes();
  }
}

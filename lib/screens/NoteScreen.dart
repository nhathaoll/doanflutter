import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/NoteController.dart';
import '../models/note.dart';
import 'AddNoteScreen.dart';

class NoteScreen extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        if (noteController.notes.isEmpty) {
          return Center(
            child: Text(
              'No notes available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        final groupedNotes = <String, List<Note>>{};
        for (var note in noteController.notes) {
          final dateKey = DateFormat('yyyy-MM-dd').format(note.createdDate);
          if (groupedNotes.containsKey(dateKey)) {
            groupedNotes[dateKey]!.add(note);
          } else {
            groupedNotes[dateKey] = [note];
          }
        }

        return ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          children: groupedNotes.entries.map((entry) {
            final date = entry.key;
            final notes = entry.value;

            return Card(
              elevation: 3,
              margin: EdgeInsets.only(bottom: 16),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepPurple,
                  ),
                ),
                children: notes.map((note) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          note.content,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Created Date: ${DateFormat('yyyy-MM-dd').format(note.createdDate)}',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                noteController.deleteNote(note.id!);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
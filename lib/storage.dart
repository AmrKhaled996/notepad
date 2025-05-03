// import 'package:notepad/note_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class StorageService {
//   static const _notesKey = 'notes';

//   Future<List<Note>> getNotes() async {
//     final prefs = await SharedPreferences.getInstance();
//     final notesJson = prefs.getStringList(_notesKey) ?? [];
//     return notesJson.map((json) => _noteFromJson(json)).toList();
//   }

//   Future<void> saveNote(Note note) async {
//     final prefs = await SharedPreferences.getInstance();
//     final notes = await getNotes();
//     notes.add(note);
//     await prefs.setStringList(_notesKey, notes.map(_noteToJson).toList());
//   }

//   // Add similar methods for update/delete
// }
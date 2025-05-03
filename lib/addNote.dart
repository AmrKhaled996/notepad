import 'package:flutter/material.dart';
import 'package:notepad/hiveDatabase.dart';
import 'package:notepad/note_model.dart';
// class AddNoteScreen extends StatefulWidget {
//   final Note? noteToEdit;
  
//   const AddNoteScreen({super.key, this.noteToEdit});

//   @override
//   State<AddNoteScreen> createState() => _AddNoteScreenState();
// }

// class _AddNoteScreenState extends State<AddNoteScreen> {
//   late final TextEditingController _titleController;
//   late final TextEditingController _contentController;
//   late final TextEditingController _tagsController;
//   late List<String> _tags;
//   late bool _isTodo;

//   @override
//   void initState() {
//     super.initState();
//     final note = widget.noteToEdit;
//     _titleController = TextEditingController(text: note?.title ?? '');
//     _contentController = TextEditingController(text: note?.content ?? '');
//     _tagsController = TextEditingController();
//     _tags = note?.tags.toList() ?? [];
//     _isTodo = note?.isTodo ?? false;
//   }

//   void _saveNote() async {
//     final hiveService = HiveService();
    
//     if (widget.noteToEdit != null) {
//       // Update existing note
//       final updatedNote = widget.noteToEdit!.copyWith(
//         title: _titleController.text,
//         content: _contentController.text,
//         tags: _tags,
//         isTodo: _isTodo,
//         date: DateTime.now(),
//       );
//       await hiveService.updateNote(updatedNote);
//     } else {
//       // Create new note
//       final newNote = Note(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         title: _titleController.text,
//         content: _contentController.text,
//         date: DateTime.now(),
//         isTodo: _isTodo,
//         tags: _tags,
//       );
//       await hiveService.addNote(newNote);
//     }
    
//     Navigator.pop(context);
//   }

//   // Update the save button to use _saveNote
//   ElevatedButton(
//     onPressed: _saveNote,
//     {dynamic child = Text(widget.noteToEdit != null ? 'Update Note' : 'Save Note')},
//   )
// }
class AddNoteScreen extends StatefulWidget {
  final Note? noteToEdit;
  
  const AddNoteScreen({super.key, this.noteToEdit});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagsController;
  late List<String> _tags;
  late bool _isTodo;

  @override
  void initState() {
    super.initState();
    final note = widget.noteToEdit;
    _titleController = TextEditingController(text: note?.title ?? '');
    _contentController = TextEditingController(text: note?.content ?? '');
    _tagsController = TextEditingController();
    _tags = note?.tags.toList() ?? [];
    _isTodo = note?.isTodo ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    final hiveService = HiveService();
    
    if (_titleController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Missing Title'),
          content: const Text('Please enter a title for your note'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
      return;
    }

    if (widget.noteToEdit != null) {
      final updatedNote = widget.noteToEdit!.copyWith(
        title: _titleController.text,
        content: _contentController.text,
        tags: _tags,
        isTodo: _isTodo,
        date: DateTime.now(),
      );
      await hiveService.updateNote(updatedNote);
    } else {
      final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        content: _contentController.text,
        date: DateTime.now(),
        isTodo: _isTodo,
        tags: _tags,
      );
      await hiveService.addNote(newNote);
    }
    
    Navigator.pop(context);
  }

  Widget _buildTagChips() {
    return Wrap(
      spacing: 4,
      children: _tags
          .map((tag) => Chip(
                label: Text(tag),
                onDeleted: () => setState(() => _tags.remove(tag)),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteToEdit != null ? 'Edit Note' : 'New Note'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: 'Add tags (comma separated)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _tags.addAll(_tagsController.text
                          .split(',')
                          .map((t) => t.trim())
                          .where((t) => t.isNotEmpty));
                      _tagsController.clear();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildTagChips(),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Mark as To-Do'),
              value: _isTodo,
              onChanged: (value) => setState(() => _isTodo = value),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveNote,
                child: Text(
                  widget.noteToEdit != null ? 'Update Note' : 'Save Note',
                  style: const TextStyle(fontSize: 18),
                ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
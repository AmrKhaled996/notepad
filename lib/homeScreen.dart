import 'package:flutter/material.dart';
import 'package:notepad/addNote.dart';
import 'package:notepad/hiveDatabase.dart';
import 'package:notepad/note_model.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HiveService _hive = HiveService();
  List<Note> _notes = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    setState(() {
      _notes = _hive.getNotes();
    });
  }

  // Update the _buildNoteCard widget
Widget _buildNoteCard(Note note) {
  return Card(
    
    margin: const EdgeInsets.all(8),
    child: ListTile(
      title: Text(note.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(note.content),
          Wrap(
            spacing: 4,
            children: note.tags
                .map((tag) => Chip(label: Text(tag)))
                .toList(),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editNote(note),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteNote(note.id),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => Share.share(note.content),
          ),
        ],
      ),
    ),
  );
}

void _deleteNote(String id) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Note'),
      content: const Text('Are you sure you want to delete this note?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await _hive.deleteNote(id);
            _loadNotes();
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}

void _editNote(Note note) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddNoteScreen(noteToEdit: note),
    ),
  );
  _loadNotes();
}
  @override
  Widget build(BuildContext context) {
    final filteredNotes = _searchQuery.isEmpty  ? _notes : _hive.searchNotes(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search notes...',
            border: InputBorder.none,
            icon: Icon(Icons.search),
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) => _buildNoteCard(filteredNotes[index]),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNoteScreen(),
      ),
    );
    _loadNotes();
  },
  child: const Icon(Icons.add),
),
    );
  }
}
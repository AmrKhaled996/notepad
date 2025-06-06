import 'package:flutter/material.dart';
import 'package:notepad/hiveDatabase.dart';
import 'package:notepad/note_model.dart';

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
  late final TextEditingController _taskController;
  late List<String> _tags;
  late bool _isTodo;
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    final note = widget.noteToEdit;
    _titleController = TextEditingController(text: note?.title ?? '');
    _contentController = TextEditingController(text: note?.content ?? '');
    _tagsController = TextEditingController();
    _taskController = TextEditingController();
    _tags = note?.tags.toList() ?? [];
    _isTodo = note?.isTodo ?? false;
    _tasks = note?.tasks.map((t) => Task(description: t.description, completed: t.completed)).toList() ?? [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _taskController.dispose();
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

    final updatedNote = widget.noteToEdit?.copyWith(
      title: _titleController.text,
      content: _contentController.text,
      tags: _tags,
      isTodo: _isTodo,
      tasks: _tasks,
      date: DateTime.now(),
    ) ?? Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      content: _contentController.text,
      date: DateTime.now(),
      isTodo: _isTodo,
      tags: _tags,
      tasks: _tasks,
    );

    if (widget.noteToEdit != null) {
      await hiveService.updateNote(updatedNote);
    } else {
      await hiveService.addNote(updatedNote);
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

  Widget _buildTaskList() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            return ListTile(
              leading: Checkbox(
                value: task.completed,
                onChanged: (value) => setState(() {
                  _tasks[index] = task.copyWith(completed: value ?? false);
                }),
              ),
              title: TextField(
                controller: TextEditingController(text: task.description),
                onChanged: (value) => setState(() {
                  _tasks[index] = task.copyWith(description: value);
                }),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter task description',
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => setState(() => _tasks.removeAt(index)),
              ),
            );
          },
        ),
        TextField(
          controller: _taskController,
          decoration: InputDecoration(
            labelText: 'Add new task',
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  setState(() {
                    _tasks.add(Task(
                      description: _taskController.text,
                      completed: false,
                    ));
                    _taskController.clear();
                  });
                }
              },
            ),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _tasks.add(Task(
                  description: value,
                  completed: false,
                ));
                _taskController.clear();
              });
            }
          },
        ),
      ],
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
            SwitchListTile(
              title: Text('Is To-Do List'),
              value: _isTodo,
              onChanged: (value) => setState(() => _isTodo = value ?? false),
            ),
            if (_isTodo) ...[
              _buildTaskList(),
              const SizedBox(height: 20),
            ] else ...[
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
            ],
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
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                widget.noteToEdit != null ? 'Update Note' : 'Save Note',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
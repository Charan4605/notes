import 'package:flutter/material.dart';
import '../models/note_model.dart';

class AddNoteScreen extends StatefulWidget {
  final Function(Note) onSave;

  const AddNoteScreen({super.key, required this.onSave});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/77.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),

      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF9379f2),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: SingleChildScrollView(  // Added this to make content scrollable
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(  // Added ConstrainedBox to ensure minimum height
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 150 - 16, // Subtract appbar height and padding
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _contentController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Content',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  maxLines: 5,
                  minLines: 5,  // Fixed number of lines
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (_titleController.text.isEmpty) return;

                    final newNote = Note(
                      id: DateTime.now().toString(),
                      title: _titleController.text,
                      content: _contentController.text,
                      createdAt: DateTime.now(),
                    );

                    widget.onSave(newNote);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Note saved'),
                        backgroundColor: Colors.deepPurple,
                      ),
                    );
                  },
                  child: const Text(
                    'Save Note',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),  // Add space for keyboard
              ],
            ),
          ),
        ),
      ),
    );
  }
}
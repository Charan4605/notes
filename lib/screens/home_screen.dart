import 'package:flutter/material.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';
import '../models/note_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [
    Note(
      id: '1',
      title: 'First Note',
      content: 'This is my first note content',
      createdAt: DateTime.now(),
    ),
    Note(
      id: '2',
      title: 'Shopping List',
      content: 'Milk, Eggs, Bread',
      createdAt: DateTime.now(),
    ),
    Note(
      id: '3',
      title: 'Meeting Notes',
      content: 'Discuss project timeline',
      createdAt: DateTime.now(),
    ),
  ];

  List<Note> filteredNotes = [];
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    filteredNotes = notes;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _deleteNoteWithAnimation(String id) async {
    final index = notes.indexWhere((note) => note.id == id);
    if (index == -1) return;

    final removedNote = notes[index];
    setState(() {
      notes.removeAt(index);
      filteredNotes = notes;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              notes.insert(index, removedNote);
              filteredNotes = notes;
            });
          },
        ),
      ),
    );
  }

  void _searchNotes(String query) {
    setState(() {
      filteredNotes = notes.where((note) {
        final titleLower = note.title.toLowerCase();
        final contentLower = note.content.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower) || contentLower.contains(searchLower);
      }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (_showSearchBar) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        _searchNotes('');
        _searchFocusNode.unfocus();
      }
    });
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
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.white, size: 30),
                      onPressed: _toggleSearch,
                    ),
                    SizedBox(width: 20, height: 15),
                  ],
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: _showSearchBar ? 80 : 0,
                  child: _showSearchBar
                      ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      onChanged: _searchNotes,
                      decoration: InputDecoration(
                        hintText: 'Search notes...',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: _toggleSearch,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  )
                      : SizedBox.shrink(),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 16),
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = filteredNotes[index];
                  return Dismissible(
                    key: Key(note.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) => _deleteNoteWithAnimation(note.id),
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(note.title),
                        subtitle: Text(note.content),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: Duration(milliseconds: 300),
                                    pageBuilder: (_, __, ___) => EditNoteScreen(
                                      note: note,
                                      onSave: (updatedNote) {
                                        setState(() {
                                          final originalIndex = notes.indexWhere((n) => n.id == updatedNote.id);
                                          notes[originalIndex] = updatedNote;
                                          filteredNotes = notes;
                                        });
                                      },
                                    ),
                                    transitionsBuilder: (_, animation, __, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(0.0, 1.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteNoteWithAnimation(note.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => AddNoteScreen(
                onSave: (newNote) {
                  setState(() {
                    notes.add(newNote);
                    filteredNotes = notes;
                  });
                },
              ),
              transitionsBuilder: (_, animation, __, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
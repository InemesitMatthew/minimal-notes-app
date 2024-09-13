import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/drawer.dart';
import '../components/note_tile.dart';
import '/models/note.dart';
import '/models/note_db.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // Text controller to access what the user typed
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // On app startup, fetch existing notes
    readNotes();
  }

  // Dispose controller to avoid memory leaks
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // Create a note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Enter note text'),
        ),
        actions: [
          // Create button
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                // Prevent empty notes and show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note cannot be empty')),
                );
                return;
              }
              // Add to db
              context.read<NoteDb>().addNote(textController.text);
              // Clear controller
              textController.clear();
              // Pop dialog box
              Navigator.pop(context);

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note created successfully')),
              );
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  // Read notes
  void readNotes() {
    context.read<NoteDb>().fetchNotes();
  }

  // Update a note
  void updateNote(Note note) {
    // Pre-fill the current note text
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Update Note"),
        content: TextField(controller: textController),
        actions: [
          // Update button
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                // Prevent empty notes on update
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note cannot be empty')),
                );
                return;
              }
              // Update note in db
              context.read<NoteDb>().updateNote(note.id, textController.text);
              // Clear controller
              textController.clear();
              // Pop dialog box
              Navigator.pop(context);

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note updated successfully')),
              );
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // Show confirmation dialog before deleting a note
  void deleteNoteWithConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this note?"),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.inversePrimary, // Text color
            ), // Cancel action
            child: const Text("Cancel"),
          ),
          // Delete button
          TextButton(
            onPressed: () {
              deleteNote(id); // Proceed with deletion
              Navigator.pop(context);

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note deleted successfully')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error, // Text color for delete
            ),
            child: const Text("Delete"),
          ),
        ],
        backgroundColor: Theme.of(context)
            .colorScheme
            .surface, // Match background with theme
      ),
    );
  }

  // Delete a note
  void deleteNote(int id) {
    context.read<NoteDb>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    // Note db
    final noteDb = context.watch<NoteDb>();

    // Current notes
    List<Note> currentNotes = noteDb.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                fontSize: 50,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          // List of notes
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                // Get individual note
                final note = currentNotes[index];

                // List tile UI
                return NoteTile(
                  text: note.text,
                  onEditPressed: () => updateNote(note),
                  onDeletePressed: () => deleteNoteWithConfirmation(note.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

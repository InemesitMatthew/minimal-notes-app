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
  // Text controller to handle input from the user when creating/updating notes.
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch existing notes from the database when the app starts.
    readNotes();
  }

  // Function to show a dialog and create a new note.
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: TextField(
          controller: textController, // User input for the note text.
        ),
        actions: [
          // Button to create the note.
          MaterialButton(
            onPressed: () {
              context.read<NoteDb>().addNote(textController.text); // Add to DB.
              textController.clear(); // Clear the input field.
              Navigator.pop(context); // Close the dialog.
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  // Fetch notes from the database.
  void readNotes() {
    context.read<NoteDb>().fetchNotes();
  }

  // Function to show a dialog and update an existing note.
  void updateNote(Note note) {
    textController.text = note.text; // Pre-fill the current text.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Update Note"),
        content: TextField(controller: textController), // User input.
        actions: [
          // Button to update the note.
          MaterialButton(
            onPressed: () {
              context.read<NoteDb>().updateNote(note.id, textController.text); // Update note in DB.
              textController.clear(); // Clear the input field.
              Navigator.pop(context); // Close the dialog.
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // Function to delete a note by ID.
  void deleteNote(int id) {
    context.read<NoteDb>().deleteNote(id); // Delete note from DB.
  }

  @override
  Widget build(BuildContext context) {
    final noteDb = context.watch<NoteDb>(); // Watch for updates from NoteDb.
    List<Note> currentNotes = noteDb.currentNotes; // List of current notes.

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote, // Open the dialog to create a new note.
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      drawer: const MyDrawer(), // The app's navigation drawer.
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page heading.
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

          // Display a list of notes.
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length, // Number of notes.
              itemBuilder: (context, index) {
                final note = currentNotes[index]; // Get individual note.
                return NoteTile(
                  text: note.text,
                  onEditPressed: () => updateNote(note), // Edit note.
                  onDeletePressed: () => deleteNote(note.id), // Delete note.
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

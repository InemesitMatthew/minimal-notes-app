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
  final textController = TextEditingController(); // Controller for handling user input

  @override
  void initState() {
    super.initState();
    readNotes(); // Fetch notes when the app starts
  }

  @override
  void dispose() {
    textController.dispose(); // Clean up the controller to avoid memory leaks
    super.dispose();
  }

  // Create a new note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: TextField(
          controller: textController, // Input field for the new note text
          decoration: const InputDecoration(hintText: 'Enter note text'),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note cannot be empty')),
                );
                return;
              }
              context.read<NoteDb>().addNote(textController.text); // Add the new note
              textController.clear(); // Clear the input field
              Navigator.pop(context); // Close the dialog
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

  // Fetch notes from the database
  void readNotes() {
    context.read<NoteDb>().fetchNotes();
  }

  // Update an existing note
  void updateNote(Note note) {
    textController.text = note.text; // Pre-fill the current note text
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Update Note"),
        content: TextField(controller: textController),
        actions: [
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note cannot be empty')),
                );
                return;
              }
              context.read<NoteDb>().updateNote(note.id, textController.text); // Update the note
              textController.clear(); // Clear the input field
              Navigator.pop(context); // Close the dialog
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

  // Delete a note with a confirmation dialog
  void deleteNoteWithConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.inversePrimary, // Style cancel button to match the theme
            ),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deleteNote(id); // Delete the note
              Navigator.pop(context); // Close the dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note deleted successfully')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error, // Style delete button as an error action
            ),
            child: const Text("Delete"),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  // Delete the note from the database
  void deleteNote(int id) {
    context.read<NoteDb>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    final noteDb = context.watch<NoteDb>(); // Watch the NoteDb provider for changes
    List<Note> currentNotes = noteDb.currentNotes; // Get the current list of notes

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Dropdown to choose sorting order
          DropdownButton<SortOrder>(
            value: noteDb.currentSortOrder, // Current sort order
            icon: Icon(Icons.sort, color: Theme.of(context).colorScheme.inversePrimary),
            onChanged: (SortOrder? newSortOrder) {
              if (newSortOrder != null) {
                noteDb.currentSortOrder = newSortOrder; // Change the sorting order
              }
            },
            items: [
              // Sort by newest first
              DropdownMenuItem(
                value: SortOrder.newestFirst,
                child: Text("Newest First", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
              ),
              // Sort by oldest first
              DropdownMenuItem(
                value: SortOrder.oldestFirst,
                child: Text("Oldest First", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
              ),
              // Sort by A-Z
              DropdownMenuItem(
                value: SortOrder.alphabeticalAZ,
                child: Text("A-Z", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
              ),
              // Sort by Z-A
              DropdownMenuItem(
                value: SortOrder.alphabeticalZA,
                child: Text("Z-A", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
              ),
            ],
          ),
        ],
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
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length, // Number of notes
              itemBuilder: (context, index) {
                final note = currentNotes[index]; // Get individual note
                return NoteTile(
                  text: note.text,
                  onEditPressed: () => updateNote(note), // Edit note
                  onDeletePressed: () => deleteNoteWithConfirmation(note.id), // Delete note with confirmation
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
  final textController = TextEditingController(); // Controller for the text input

  @override
  void initState() {
    super.initState();
    readNotes(); // Fetch notes when the app starts
  }

  @override
  void dispose() {
    textController.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  // Create a new note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: TextField(
          controller: textController, // Input for note text
          decoration: const InputDecoration(hintText: 'Enter note text'),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                // Prevent creating empty notes
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note cannot be empty')),
                );
                return;
              }
              context.read<NoteDb>().addNote(textController.text); // Add note
              textController.clear(); // Clear input
              Navigator.pop(context); // Close dialog
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
    textController.text = note.text; // Pre-fill the note text
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Update Note"),
        content: TextField(controller: textController), // Input for updated text
        actions: [
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                // Prevent empty notes when updating
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note cannot be empty')),
                );
                return;
              }
              context.read<NoteDb>().updateNote(note.id, textController.text); // Update note
              textController.clear(); // Clear input
              Navigator.pop(context); // Close dialog
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

  // Show a confirmation dialog before deleting a note
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
              foregroundColor: Theme.of(context).colorScheme.inversePrimary, // Cancel button color
            ), // Cancel action
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deleteNote(id); // Delete note
              Navigator.pop(context); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note deleted successfully')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error, // Delete button color
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

  // Show sorting options in a popup menu when the user taps the sort icon
  void showSortOptions(BuildContext context) {
    final noteDb = context.read<NoteDb>(); // Access the NoteDb provider

    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 56, 0, 0), // Better position near the sort icon
      items: [
        // Newest First
        PopupMenuItem(
          value: SortOrder.newestFirst,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Newest First", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
              if (noteDb.currentSortOrder == SortOrder.newestFirst)
                Icon(Icons.check, color: Theme.of(context).colorScheme.inversePrimary), // Show checkmark if selected
            ],
          ),
        ),
        // Oldest First
        PopupMenuItem(
          value: SortOrder.oldestFirst,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Oldest First", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
              if (noteDb.currentSortOrder == SortOrder.oldestFirst)
                Icon(Icons.check, color: Theme.of(context).colorScheme.inversePrimary),
            ],
          ),
        ),
        // Alphabetical A-Z
        PopupMenuItem(
          value: SortOrder.alphabeticalAZ,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("A-Z", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
              if (noteDb.currentSortOrder == SortOrder.alphabeticalAZ)
                Icon(Icons.check, color: Theme.of(context).colorScheme.inversePrimary),
            ],
          ),
        ),
        // Alphabetical Z-A
        PopupMenuItem(
          value: SortOrder.alphabeticalZA,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Z-A", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
              if (noteDb.currentSortOrder == SortOrder.alphabeticalZA)
                Icon(Icons.check, color: Theme.of(context).colorScheme.inversePrimary),
            ],
          ),
        ),
      ],
    ).then((selectedSortOrder) {
      if (selectedSortOrder != null) {
        noteDb.currentSortOrder = selectedSortOrder; // Update the sorting order
      }
    });
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
          // Icon button for sorting options
          IconButton(
            icon: Icon(Icons.sort_rounded, color: Theme.of(context).colorScheme.inversePrimary),
            onPressed: () {
              showSortOptions(context); // Show the popup menu for sorting options
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote, // Open the dialog to create a new note
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
          // Heading for the Notes page
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
              itemCount: currentNotes.length, // Number of notes
              itemBuilder: (context, index) {
                final note = currentNotes[index]; // Get the individual note
                return NoteTile(
                  text: note.text,
                  onEditPressed: () => updateNote(note), // Edit the note
                  onDeletePressed: () => deleteNoteWithConfirmation(note.id), // Delete the note with confirmation
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

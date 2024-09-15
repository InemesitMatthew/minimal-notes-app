import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../components/drawer.dart'; // Custom drawer
import '../components/note_tile.dart'; // NoteTile widget
import '../components/search_widget.dart'; // Custom search bar widget
import '../components/sort_menu.dart'; // Sort menu widget
import '../components/note_dialogs.dart'; // Dialogs for create, update, delete
import '/models/note_db.dart';
import '/models/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController(); // Controller for note input
  final searchController = TextEditingController(); // Controller for search input
  bool isSearching = false; // Flag to toggle search mode
  String searchQuery = ''; // Stores the current search query

  @override
  void initState() {
    super.initState();
    readNotes(); // Fetch notes when the page is initialized
  }

  @override
  void dispose() {
    textController.dispose(); // Dispose the text controller to avoid memory leaks
    searchController.dispose(); // Dispose the search controller
    super.dispose();
  }

  // Toggle the search bar and clear the search query
  void toggleSearch() {
    setState(() {
      isSearching = !isSearching; // Toggle search mode
      searchQuery = ''; // Reset search query
      searchController.clear(); // Clear the search input field
    });
  }

  // Update the search query based on user input
  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query; // Update the search query
    });
  }

  // Fetch notes from the database
  void readNotes() {
    context.read<NoteDb>().fetchNotes(); // Call fetchNotes from the NoteDb provider
  }

  @override
  Widget build(BuildContext context) {
    final noteDb = context.watch<NoteDb>(); // Watch the NoteDb provider for changes
    List<Note> currentNotes = noteDb.currentNotes; // Retrieve the current list of notes

    // Filter notes based on the search query
    List<Note> filteredNotes = currentNotes
        .where((note) => note.text.toLowerCase().contains(searchQuery.toLowerCase())) // Case-insensitive search
        .toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: CustomSearchBar(
          isSearching: isSearching, // Determine if search mode is active
          searchController: searchController, // Controller for search input
          onSearchChanged: updateSearchQuery, // Callback to handle search input changes
          onSearchClose: toggleSearch, // Callback to close search mode
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search), // Toggle search icon based on mode
            onPressed: toggleSearch, // Toggle search mode
          ),
          const SortMenu(), // Sort menu widget
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the create note dialog
          NoteDialogs.showCreateDialog(
            context: context,
            textController: textController,
            onCreate: () => context.read<NoteDb>().addNote(textController.text), // Add note callback
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      drawer: const MyDrawer(), // Custom drawer widget
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
              itemCount: filteredNotes.length, // Count of filtered notes
              itemBuilder: (context, index) {
                final note = filteredNotes[index]; // Get individual note
                return NoteTile(
                  text: note.text, // Display note text
                  onEditPressed: () {
                    textController.text = note.text; // Pre-fill text controller with note content
                    // Show update dialog
                    NoteDialogs.showUpdateDialog(
                      context: context,
                      textController: textController,
                      onUpdate: () => context.read<NoteDb>().updateNote(note.id, textController.text), // Update note callback
                    );
                  },
                  onDeletePressed: () {
                    // Show delete confirmation dialog
                    NoteDialogs.showDeleteConfirmation(
                      context: context,
                      onDelete: () => context.read<NoteDb>().deleteNote(note.id), // Delete note callback
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

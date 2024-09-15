import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../components/drawer.dart';
import '../components/note_tile.dart';
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
  final textController = TextEditingController();
  final searchController = TextEditingController();
  bool isSearching = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    readNotes(); // Fetch notes when the app starts
  }

  @override
  void dispose() {
    textController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      searchQuery = '';
      searchController.clear();
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void readNotes() {
    context.read<NoteDb>().fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    final noteDb = context.watch<NoteDb>();
    List<Note> currentNotes = noteDb.currentNotes;

    // Filter notes based on the search query
    List<Note> filteredNotes = currentNotes
        .where((note) => note.text.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: CustomSearchBar(
          isSearching: isSearching,
          searchController: searchController,
          onSearchChanged: updateSearchQuery,
          onSearchClose: toggleSearch,
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: toggleSearch,
          ),
          const SortMenu(), // Sort menu widget
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NoteDialogs.showCreateDialog(
            context: context,
            textController: textController,
            onCreate: () => context.read<NoteDb>().addNote(textController.text),
          );
        },
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
              style: GoogleFonts.dmSerifText(fontSize: 50, color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                return NoteTile(
                  text: note.text,
                  onEditPressed: () {
                    textController.text = note.text;
                    NoteDialogs.showUpdateDialog(
                      context: context,
                      textController: textController,
                      onUpdate: () => context.read<NoteDb>().updateNote(note.id, textController.text),
                    );
                  },
                  onDeletePressed: () {
                    NoteDialogs.showDeleteConfirmation(
                      context: context,
                      onDelete: () => context.read<NoteDb>().deleteNote(note.id),
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

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SortOrder { newestFirst, oldestFirst, alphabeticalAZ, alphabeticalZA }

class NoteDb extends ChangeNotifier {
  static late Isar isar;
  static const String _sortOrderKey = 'sort_order';

  SortOrder _currentSortOrder = SortOrder.newestFirst; // Default sorting order

  // Getter for the current sort order
  SortOrder get currentSortOrder => _currentSortOrder;

  // Setter for changing the sort order, saving it in preferences
  set currentSortOrder(SortOrder sortOrder) {
    _currentSortOrder = sortOrder;
    _saveSortOrder(); // Save the sort order
    fetchNotes(); // Fetch notes with the new sorting applied
  }

  // Initialize the Isar database and load the saved sort order
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema], // Define the schema for the Note class
      directory: dir.path,
    );

    // Load saved sorting order from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedSortOrderIndex = prefs.getInt(_sortOrderKey) ??
        0; // Load saved sort order (0 for default)

    // Apply saved sort order on initialization
    NoteDb()._currentSortOrder = SortOrder.values[savedSortOrderIndex];
    await NoteDb().fetchNotes(); // Fetch notes with the correct sorting
  }

  // Save the sort order to SharedPreferences
  Future<void> _saveSortOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_sortOrderKey,
        _currentSortOrder.index); // Save the index of the sort order
  }

  final List<Note> currentNotes = [];

  // Fetch notes from the database based on the current sorting order
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes;

    // Apply sorting based on the current sort order
    switch (_currentSortOrder) {
      case SortOrder.newestFirst:
        fetchedNotes = await isar.notes.where().sortByCreatedAtDesc().findAll();
        break;
      case SortOrder.oldestFirst:
        fetchedNotes = await isar.notes.where().sortByCreatedAt().findAll();
        break;
      case SortOrder.alphabeticalAZ:
        fetchedNotes = await isar.notes.where().sortByText().findAll();
        break;
      case SortOrder.alphabeticalZA:
        fetchedNotes = await isar.notes.where().sortByTextDesc().findAll();
        break;
    }

    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners(); // Notify listeners to rebuild the UI with updated data
  }

  // Add, update, and delete methods for CRUD operations
  Future<void> addNote(String textFromUser) async {
    final newNote = Note()..text = textFromUser;
    await isar.writeTxn(() => isar.notes.put(newNote));
    fetchNotes(); // Refresh the note list after adding
  }

  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}

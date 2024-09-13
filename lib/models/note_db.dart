import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '/models/note.dart';
import 'package:path_provider/path_provider.dart';

// Enum to define different sorting orders
enum SortOrder { newestFirst, oldestFirst, alphabeticalAZ, alphabeticalZA }

class NoteDb extends ChangeNotifier {
  static late Isar isar;

  // Initialize the Isar database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory(); // Get the app's document directory
    isar = await Isar.open(
      [NoteSchema], // Define the schema for the Note class.
      directory: dir.path, // Specify where to store the database.
    );
  }

  // List to hold the current notes fetched from the database.
  final List<Note> currentNotes = [];

  // Current sorting order, default is "Newest First"
  SortOrder _currentSortOrder = SortOrder.newestFirst;

  // Getter for the current sort order
  SortOrder get currentSortOrder => _currentSortOrder;

  // Setter for changing the sort order, which refetches the notes
  set currentSortOrder(SortOrder sortOrder) {
    _currentSortOrder = sortOrder;
    fetchNotes(); // Fetch notes with the new sorting applied.
  }

  // Add a new note to the database
  Future<void> addNote(String textFromUser) async {
    final newNote = Note()..text = textFromUser; // Create a new note object.
    await isar.writeTxn(() => isar.notes.put(newNote)); // Save the note to the database.
    fetchNotes(); // Refresh the note list.
  }

  // Fetch notes from the database based on the selected sorting order
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes;

    // Apply sorting based on the current sort order
    switch (_currentSortOrder) {
      case SortOrder.newestFirst:
        fetchedNotes = await isar.notes.where().sortByCreatedAtDesc().findAll(); // Newest first
        break;
      case SortOrder.oldestFirst:
        fetchedNotes = await isar.notes.where().sortByCreatedAt().findAll(); // Oldest first
        break;
      case SortOrder.alphabeticalAZ:
        fetchedNotes = await isar.notes.where().sortByText().findAll(); // A-Z
        break;
      case SortOrder.alphabeticalZA:
        fetchedNotes = await isar.notes.where().sortByTextDesc().findAll(); // Z-A
        break;
    }

    currentNotes.clear(); // Clear the current note list.
    currentNotes.addAll(fetchedNotes); // Add the newly sorted notes.
    notifyListeners(); // Notify listeners to rebuild the UI with the updated data.
  }

  // Update an existing note in the database
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id); // Fetch the note by ID.
    if (existingNote != null) {
      existingNote.text = newText; // Update the note text.
      await isar.writeTxn(() => isar.notes.put(existingNote)); // Save the updated note.
      await fetchNotes(); // Refresh the notes after updating.
    }
  }

  // Delete a note from the database
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id)); // Remove the note by ID.
    await fetchNotes(); // Refresh the notes after deletion.
  }
}

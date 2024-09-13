import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDb extends ChangeNotifier {
  static late Isar isar; // Reference to the Isar instance for database operations.

  // Initialize the Isar database and set up the schema for Note objects.
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory(); // Get app directory path.
    isar = await Isar.open(
      [
        NoteSchema, // Define the schema for the Note model.
      ],
      directory: dir.path, // Set directory for the database.
    );
  }

  // List to hold current notes fetched from the database.
  final List<Note> currentNotes = [];

  // Create and add a new note to the database.
  Future<void> addNote(String textFromUser) async {
    final newNote = Note()..text = textFromUser; // Create a new Note object.

    await isar.writeTxn(() => isar.notes.put(newNote)); // Save note to the database.

    fetchNotes(); // Refresh the list of notes after adding.
  }

  // Fetch all notes from the database.
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll(); // Fetch all notes.
    currentNotes.clear(); // Clear the current list of notes.
    currentNotes.addAll(fetchedNotes); // Update the list with fetched notes.
    notifyListeners(); // Notify listeners that the data has changed.
  }

  // Update an existing note by ID.
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id); // Fetch the note by ID.
    if (existingNote != null) {
      existingNote.text = newText; // Update the note text.
      await isar.writeTxn(() => isar.notes.put(existingNote)); // Save updated note.
      await fetchNotes(); // Refresh notes.
    }
  }

  // Delete a note from the database by ID.
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id)); // Remove the note by ID.
    await fetchNotes(); // Refresh notes.
  }
}

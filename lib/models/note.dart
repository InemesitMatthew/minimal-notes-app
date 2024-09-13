import 'package:isar/isar.dart';

// This line is needed to generate file
// Run: dart run build_runner build
part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement; // Automatically generates unique IDs
  late String text; // A text field for the note
  late DateTime createdAt = DateTime.now(); // Timestamp for note creation, initialized to the current date and time.
}

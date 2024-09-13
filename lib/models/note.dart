import 'package:isar/isar.dart';

// This line is required for generating the Isar database code.
// Run: dart run build_runner build
part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement; // Auto-generate unique IDs for each note.
  late String text; // The text content of the note.
}

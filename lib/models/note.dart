import 'package:isar/isar.dart';

// this line is needed to generate file
// then run: dart run build_runner build
part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement; // Automatically generates unique IDs
  late String text; // A text field for the note
}

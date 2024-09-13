import 'package:flutter/material.dart';
import 'theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'models/note_db.dart';
import 'pages/notes_page.dart';

Future<void> main() async {
  // initialize note isar db
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDb.initialize();

  runApp(
    MultiProvider(
      providers: [
        // Note Provider
        ChangeNotifierProvider(
          create: (context) => NoteDb(),
        ),

        // Theme Provider
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotesPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

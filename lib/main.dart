import 'package:flutter/material.dart';
import 'theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'models/note_db.dart';
import 'pages/notes_page.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized before using services (e.g., Isar database)
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the Isar database for storing notes
  await NoteDb.initialize();

  // Start the app with multiple providers (for notes and theme)
  runApp(
    MultiProvider(
      providers: [
        // Provider for managing notes database (CRUD operations)
        ChangeNotifierProvider(
          create: (context) => NoteDb(),
        ),

        // Provider for managing theme (light/dark mode)
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
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      // Set the home screen to NotesPage
      home: const NotesPage(),
      // Apply the theme from the ThemeProvider
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

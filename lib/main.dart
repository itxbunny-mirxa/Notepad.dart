import 'package:flutter/material.dart';
import 'package:notebook/models/node_database.dart';
import 'package:notebook/pages/note_page.dart';
import 'package:notebook/themes/theme_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // I N A T A L I Z E   note isar database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initializeDatabase();

  runApp(
  MultiProvider(providers:  [
    // note provider
    ChangeNotifierProvider(create: (context) => NoteDatabase()

    ),
    // theme provider
    ChangeNotifierProvider(create: (context) => ThemeProvider()
    ),

  ],
  child: const MyApp(),
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const NotesPage()
    ,
    theme: Provider.of<ThemeProvider>(context).themeData,
    
    );
  }
}

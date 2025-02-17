import 'package:flutter/material.dart';
import 'routes/parent_help.dart'; // Updated import path
//import 'routes/quizzes_dashbord.dart';
//import 'routes/report_dashboard.dart';
//import 'routes/snake_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulary App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VocabularyScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

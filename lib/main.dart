import 'package:flutter/material.dart';
import 'package:poker_game/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(useMaterial3: false),
      home: Scaffold(
        backgroundColor: Colors.red.shade400,
        appBar: AppBar(
          backgroundColor: Colors.red,
          elevation: 1,
          title: const Text('Game Lesson'),
        ),
        body: Home(),
      ),
    );
  }
}



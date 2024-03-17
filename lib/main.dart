import 'package:flutter/material.dart';
import 'package:poker_game/body.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(useMaterial3: false),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Padding(
          padding:  EdgeInsets.all(8.0),
          child:  Body(),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tak_toe/providers/game_provider.dart';
import 'package:tic_tak_toe/screens/game_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => GameProvider(), child: const TicTacToeApp()));
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const GameScreen());
  }
}

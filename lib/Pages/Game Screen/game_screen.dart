import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'main_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: MainScreen()), // pass context here
    );
  }
}

import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:together/Components/wall.dart';

class MainScreen extends FlameGame {
  static const double gameWidth = 800; // Set your desired game width
  static const double gameHeight = 600; // Set your desired game height

  MainScreen()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  double get width => size.x;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Load game assets or set up components here
    // Add a wall that starts far away and "moves" toward the player
    add(Wall(
      initialSize: 3000, // Try a larger size to ensure it's visible
      distanceFromPlayer: 10,
      speed: 0.1,
      startPosition: Vector2(200, 300), // Center the starting position more
      targetPosition: Vector2(400, 300), // Move towards the center
    ));
  }

  double get screenWidth => size.x;
  double get screenHeight => size.y;
}

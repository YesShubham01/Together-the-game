import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:together/Components/backgroud.dart';
import 'package:together/Components/temp_player.dart';
import 'package:together/Components/wall.dart';
import 'package:together/world.dart';

class MainScreen extends FlameGame
    with TapDetector, PanDetector, KeyboardEvents {
  static const double gameWidth = 2360; // Set your desired game width
  static const double gameHeight = 1640; // Set your desired game height
  late final TempPlayer player; // Define the player object here
  late final TempPlayer secondPlayer;
  late final Backgroud background;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    background = Backgroud();
    world.add(background);
    print(background.position.y);

    player = TempPlayer(
      position: Vector2(300, 400),
      size: Vector2(100, 100), // Define player size
      characterType: CharacterType.pink,
    );

    world.add(player); // Make sure to add the player to the game world

    secondPlayer = TempPlayer(
      position: Vector2(900, 400),
      size: Vector2(100, 100), // Define player size
      characterType: CharacterType.white,
    );

    world.add(secondPlayer);
    camera.follow(player); // Follow the player
    camera.setBounds(Rectangle.fromLTRB(0, 0, 5000, 6000));
  }

  @override
  void onTapDown(TapDownInfo info) {
    // Convert the global tap position to world position
    Vector2 localPosition = camera.globalToLocal(info.eventPosition.global);
    print(localPosition.y);
    // Check if the tap is on the second player
    if (secondPlayer.onCharacter(localPosition)) {
      print("Magic activated");
      secondPlayer.startFloating(); // Start moving when tapped
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // Move the player based on pan updates
    if (secondPlayer.isFloating) {
      secondPlayer.position
          .add(info.delta.global); // Update position based on drag
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    super.onPanEnd(info);
    secondPlayer.stopMoving();
    secondPlayer.stopFloating();
  }

  @override
  void onTapUp(TapUpInfo info) {
    // Stop moving when the touch ends
    secondPlayer.stopMoving();
    secondPlayer.stopFloating();
  }

  @override
  KeyEventResult onKeyEvent(
    // ignore: deprecated_member_use
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;
    bool ignore = true;
    if (isKeyDown) {
      // Check for left arrow key
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        player.moveLeft(); // Move player left
        ignore = false;
      }
      // Check for right arrow key
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        player.moveRight(); // Move player right
        ignore = false;
      }
      // Check for spacebar for jump
      if (keysPressed.contains(LogicalKeyboardKey.space)) {
        player.jump(); // Make the player jump
        ignore = false;
      }
    }

    return ignore ? KeyEventResult.ignored : KeyEventResult.handled;
  }
}

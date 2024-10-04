import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class Wall extends SpriteComponent {
  // Initial properties for wall
  double initialSize;
  double distanceFromPlayer;
  double speed;
  Vector2 targetPosition;

  Wall({
    required this.initialSize,
    required this.distanceFromPlayer,
    required this.speed,
    required Vector2 startPosition,
    required this.targetPosition,
  }) : super(size: Vector2.all(initialSize), position: startPosition);

  @override
  Future<void> onLoad() async {
    // Load your sprite asset here
    // print("wall loading started");
    sprite = await Sprite.load(
        'wall.png'); // Ensure the correct path to the image asset
    size = Vector2.all(initialSize); // Set the initial size for the sprite
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // print("wall updated");

    // Simulate depth by scaling the wall as it "moves" closer
    distanceFromPlayer -= speed * dt;

    // Scale the wall based on distance (smaller when far, larger when close)
    double scaleFactor =
        1 / distanceFromPlayer; // Inverse relation to simulate 3D
    size = Vector2.all(initialSize * scaleFactor);

    // Move the wall towards the target position
    position = moveTowards(position, targetPosition, speed * dt);

    // Remove the wall if it goes out of bounds (e.g., behind the player)
    if (distanceFromPlayer <= 0) {
      removeFromParent();
    }
  }

  Vector2 moveTowards(
      Vector2 current, Vector2 target, double maxDistanceDelta) {
    Vector2 delta = target - current;
    double distance = delta.length;

    // If the target is very close, set the position to the target
    if (distance <= maxDistanceDelta || distance == 0) {
      return target;
    }

    // Move towards the target
    return current + delta.normalized() * maxDistanceDelta;
  }
}

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:together/Pages/Game%20Screen/main_screen.dart';

enum CharacterType {
  pink,
  white,
}

enum MovementDirection {
  neutral,
  left,
  right,
}

class TempPlayer extends SpriteAnimationComponent with HasGameRef<MainScreen> {
  // Define the speed for movement and jump height
  final double speed = 30;
  final double jumpHeight = 50;
  final double gravity = 250;
  final double groundY = 400;
  double velocityY = 0;
  double horizontalVelocity = 0;

  bool isMoving = false;
  bool isJumping = false;
  bool isFalling = false;

  final CharacterType characterType;
  MovementDirection movementDirection = MovementDirection.neutral;

  TempPlayer({
    required Vector2 position,
    required Vector2 size,
    required this.characterType,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      _getSpritePath(),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2.all(32),
        loop: true,
      ),
    );

    position.y = groundY;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity continuously if the player is in the air
    if (position.y < groundY || isJumping) {
      velocityY += gravity * dt; // Gravity adds to vertical velocity
      position.y += velocityY * dt; // Apply vertical velocity to position
    }

    // Apply horizontal movement during jumping
    if (isJumping) {
      position.x +=
          horizontalVelocity * dt; // Move horizontally during the jump
    }

    // Prevent the player from falling below the ground
    if (position.y >= groundY) {
      position.y = groundY; // Snap to the ground
      velocityY = 0; // Reset vertical velocity when on the ground
      isJumping = false; // Stop the jumping state
      horizontalVelocity = 0; // Stop horizontal movement after landing
    }
  }

  void startMoving() {
    isMoving = true; // Set the moving state to true
  }

  void stopMoving() {
    isMoving = false; // Set the moving state to false
  }

  // Function to move the player left
  void moveLeft() {
    if (!isJumping && position.x > 0) {
      position.add(Vector2(-speed, 0)); // Move left
      movementDirection = MovementDirection.left; // Track movement direction
    }
  }

  // Function to move the player right
  void moveRight() {
    final double newPositionX =
        position.x + speed; // Calculate the new position

    // Ensure the new position does not exceed the right boundary
    if (!isJumping && newPositionX + size.x <= game.background.size.x) {
      position.add(Vector2(speed, 0)); // Move right
      movementDirection = MovementDirection.right; // Track movement direction
    }
  }

  // Function to make the player jump
  void jump() {
    if (!isJumping) {
      isJumping = true;
      final jumpUp = position.y - jumpHeight;
      position.y = jumpUp;

      // Set horizontal velocity based on the movement direction
      switch (movementDirection) {
        case MovementDirection.left:
          horizontalVelocity = -speed;
          break;
        case MovementDirection.right:
          horizontalVelocity = speed;
          break;
        default:
          horizontalVelocity = 0;
      }

      // Reset jumping state after reaching the peak
      Future.delayed(const Duration(milliseconds: 200), () {
        isJumping = false;
        movementDirection =
            MovementDirection.neutral; // Reset direction after jump
      });
    }
  }

  bool onCharacter(Vector2 point) {
    // Check if the given point is within the player's boundaries
    return point.x >= position.x &&
        point.x <= position.x + size.x &&
        point.y >= position.y &&
        point.y <= position.y + size.y;
  }

  String _getSpritePath() {
    switch (characterType) {
      case CharacterType.pink:
        return 'pink_character_idle.png';
      case CharacterType.white:
        return 'white_character_idle.png';
      default:
        return 'pink_character_idle.png'; // Fallback to pink
    }
  }
}

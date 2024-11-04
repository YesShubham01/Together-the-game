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
  final double jumpHeight = 100;
  final double gravity = 250;
  final double groundY = 400;
  double velocityY = 0;
  double horizontalVelocity = 0;

  bool isMoving = false;
  bool isJumping = false;
  bool isFalling = false;
  bool isFloating = false;

  final CharacterType characterType;
  MovementDirection movementDirection = MovementDirection.neutral;

  String newSpritePath = "";
  String oldSpritePath = "";

  TempPlayer({
    required Vector2 position,
    required Vector2 size,
    required this.characterType,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    newSpritePath = _getSpritePath();
    oldSpritePath = _getSpritePath();
    animation = await game.loadSpriteAnimation(
      newSpritePath,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2.all(32),
        loop: true,
      ),
    );

    position.y = groundY;
  }

  int i = 0;
  @override
  void update(double dt) {
    super.update(dt);
    if (isFloating) {
      print("$isFloating $i");
      i++;
    }

    if (horizontalVelocity != 0) {
      isMoving = true;
    } else {
      isMoving = false;
    }

    newSpritePath = _getSpritePath();
    if (newSpritePath != oldSpritePath) {
      setAnimationToIdle();
      oldSpritePath = newSpritePath;
    }

    // Apply horizontal movement based on horizontalVelocity
    position.add(Vector2(horizontalVelocity * dt, 0));
    // position.x += horizontalVelocity * dt;

    // Apply gravity continuously if the player is in the air
    if (position.y < groundY) {
      velocityY += gravity * dt;
      position.add(Vector2(0, velocityY * dt));
      // position.y += velocityY * dt;
    }

    // Prevent the player from falling below the ground

    if (position.y >= groundY) {
      position.y = groundY; // Snap to the ground
      velocityY = 0; // Reset vertical velocity when on the ground
      isJumping = false;
      // horizontalVelocity = 0; // Stop horizontal movement after landing
    }
  }

  void startFloating() {
    isFloating = true; // Set the moving state to true
  }

  void stopFloating() {
    isFloating = false; // Set the moving state to true
  }

  void startMoving() {
    isMoving = true; // Set the moving state to true
  }

  void stopMoving() {
    isMoving = false; // Set the moving state to false
  }

  // Function to move the player left
  void moveLeft() {
    if (position.x > 0) {
      isMoving = true;
      horizontalVelocity -= speed;
      movementDirection = MovementDirection.left; // Track movement direction

      Future.delayed(const Duration(seconds: 1), () {
        if (horizontalVelocity < 0) {
          horizontalVelocity += speed;
        }
      });
    }
  }

  // Function to move the player right
  void moveRight() {
    final double newPositionX =
        position.x + speed; // Calculate the new position

    // Ensure the new position does not exceed the right boundary
    if (newPositionX + size.x <= game.background.size.x) {
      horizontalVelocity += speed;
      movementDirection = MovementDirection.right; // Track movement direction

      Future.delayed(const Duration(seconds: 1), () {
        if (horizontalVelocity > 0) {
          horizontalVelocity -= speed;
        }
      });
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
          horizontalVelocity -= speed;
          break;
        case MovementDirection.right:
          horizontalVelocity += speed;
          break;
        default:
        // horizontalVelocity = 0;
      }
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
        if (movementDirection == MovementDirection.right) {
          if (isFloating) {
            return "pink_character_float.png";
          } else if (isMoving) {
            return "pink_character_walk_right.png";
          } else {
            return 'pink_character_idle.png';
          }
        } else {
          return isMoving
              ? "pink_character_run_left.png"
              : 'pink_character_idle _left.png';
        }
      case CharacterType.white:
        if (isFloating) {
          return "white_character_float.png";
        } else {
          return 'white_character_idle.png';
        }
      default:
        return 'pink_character_idle.png'; // Fallback to pink
    }
  }

  void setAnimationToIdle() async {
    print(_getSpritePath());
    animation = await game.loadSpriteAnimation(
      _getSpritePath(),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2.all(32),
        loop: true,
      ),
    );
  }
}

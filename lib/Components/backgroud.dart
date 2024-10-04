import 'package:flame/components.dart';

class Backgroud extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(
        'background.png'); // Ensure the correct path to the image asset
    size = Vector2(1180, 820);
    position = Vector2(0, 0);
    return super.onLoad();
  }
}

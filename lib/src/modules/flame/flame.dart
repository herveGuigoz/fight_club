import 'package:flame/game.dart';
import 'package:flame/components.dart';

class RayWorldGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    add(Player());
    super.onLoad();
  }
}

class Player extends SpriteComponent with HasGameRef {
  Player() : super(size: Vector2.all(50.0));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('player.png');
    position = gameRef.size / 2;
  }
}

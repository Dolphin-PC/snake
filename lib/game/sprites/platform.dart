import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:snake/game/snake.dart';
import 'package:snake/game/sprites/player.dart';

abstract class Platform<T> extends SpriteGroupComponent<T> with HasGameRef<Snake>, CollisionCallbacks {
  final hitbox = RectangleHitbox();

  Platform({
    super.position,
  }) : super(
          size: Vector2(100, 100),
          priority: 2,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(hitbox);
  }
}

enum NormalPlatformState { only }

class NormalPlatform extends Platform<NormalPlatformState> {
  NormalPlatform({super.position});

  int count = 1;
  TextComponent countText = TextComponent(
    anchor: Anchor.center,
    position: Vector2(50, -10),
    priority: 5,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprites = {
      NormalPlatformState.only: await gameRef.loadSprite('game/block/Planets/planet00.png'),
    };

    current = NormalPlatformState.only;

    size = Vector2(100, 100);

    count = Random().nextInt(gameRef.levelManager.level.value) + 1;
    countText.text = '$count';
    add(countText);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      count--;

      if (count == 0) {
        removeFromParent();
      } else {
        countText.text = '$count';
      }
    }
  }
}

enum ItemPlatformState { life, star }

class ItemPlatform extends Platform<ItemPlatformState> {
  ItemPlatform({super.position, required this.itemPlatformState});

  ItemPlatformState itemPlatformState;

  int count = 1;
  TextComponent countText = TextComponent(
    anchor: Anchor.center,
    position: Vector2(50, -10),
    priority: 5,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprites = {
      ItemPlatformState.life: await gameRef.loadSprite('game/player/spaceShips_002.png'),
      ItemPlatformState.star: await gameRef.loadSprite('game/item/star.png'),
    };

    current = itemPlatformState;
    size = Vector2(50, 50);

    addLifeItemText();
  }

  addLifeItemText() {
    if (itemPlatformState == ItemPlatformState.life) {
      count = Random().nextInt(gameRef.levelManager.level.value) + 1;
      countText.text = '$count';
      add(countText);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      removeFromParent();
    }
  }
}

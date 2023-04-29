import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:snake/game/snake.dart';

enum PlayerState { only }

enum Character { spaceShips_001 }

class Player extends SpriteGroupComponent<PlayerState> with HasGameRef<Snake>, KeyboardHandler, CollisionCallbacks {
  Player({
    super.position,
    required this.character,
  }) : super(
          size: Vector2(50, 50),
          anchor: Anchor.center,
          priority: 1,
        );

  Character character;

  int _hAxisInput = 0;
  int _vAxisInput = 0;
  static const speed = 300.0;
  final int movingLeftInput = -1;
  final int movingRightInput = 1;
  final int movingTopInput = -1;
  final int movingBottomInput = 1;
  Vector2 _velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(CircleHitbox());

    // Add a Player to the game: loadCharacterSprites
    await _loadCharacterSprites();

    // Add a Player to the game: Default Dash onLoad to center state
    current = PlayerState.only;
  }


  @override
  void update(double dt) {
    _velocity.x = (_hAxisInput * speed);
    _velocity.y = (_vAxisInput * speed);

    position += _velocity * dt;
    // print(position);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;
    _vAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveLeft();
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveRight();
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      moveUp();
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      moveDown();
    }

    return true;
  }

  Future<void> _loadCharacterSprites() async {
    final only = await gameRef.loadSprite('game/player/${character.name}.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.only : only
    };
  }

  void moveLeft() {
    _hAxisInput = 0;
    _hAxisInput += movingLeftInput;
  }

  void moveRight() {
    _hAxisInput = 0;
    _hAxisInput += movingRightInput;
  }

  void moveUp() {
    _vAxisInput = 0;
    _vAxisInput += movingTopInput;
  }

  void moveDown() {
    _vAxisInput = 0;
    _vAxisInput += movingBottomInput;
  }
}

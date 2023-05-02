import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:snake/game/snake.dart';
import 'package:snake/game/sprites/followPlayer.dart';
import 'package:snake/game/sprites/platform.dart';

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
  final int movingLeftInput = -1;
  final int movingRightInput = 1;
  final int movingTopInput = -1;
  final int movingBottomInput = 1;
  Vector2 _velocity = Vector2.zero();

  int remainLife = 5;
  TextComponent remainLifeText = TextComponent(
    anchor: Anchor.center,
    position: Vector2(25, -20),
    priority: 10,
  );

  void updateRemainLife(int num) {
    remainLife += num;
    remainLifeText.text = remainLife.toString();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(CircleHitbox());
    remainLifeText.text = '$remainLife';
    add(remainLifeText);

    // Add a Player to the game: loadCharacterSprites
    await _loadCharacterSprites();

    // Add a Player to the game: Default Dash onLoad to center state
    current = PlayerState.only;
  }

  @override
  void update(double dt) {
    _velocity.x = (_hAxisInput * gameRef.levelManager.speed);
    _velocity.y = (_vAxisInput * gameRef.levelManager.speed);

    _velocity.y -= gameRef.levelManager.speed;
    position += _velocity * dt;
    onHorizontal();
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

    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      gameRef.togglePauseState();
    }

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    position.y += 90;

    if (other is NormalPlatform) {
      gameRef.gameManager.increaseScore();
      updateRemainLife(-1);

      if (remainLife <= 0) {
        gameRef.onLose();
        return;
      }
      removeFollowPlayer();
    }

    if (other is ItemPlatform) {
      if (other.itemPlatformState == ItemPlatformState.life) {
        updateRemainLife(other.count);

        // follow 추가
        for (var i = 0; i < other.count; i++) {
          addFollowPlayer();
        }
      }

      if (other.itemPlatformState == ItemPlatformState.star) {
        gameRef.gameManager.star?.value++;
      }
    }

    return;
  }

  /// 가로 수평이동 시, 벽면 이동
  void onHorizontal() {
    final double horizontalCenter = size.x / 2;

    // Add a Player to the game: Add infinite side boundaries logic
    // 중앙-오른쪽
    if (position.x < horizontalCenter) {
      position.x = gameRef.size.x - (horizontalCenter);
    }
    // 중앙-왼쪽
    if (position.x > gameRef.size.x - (horizontalCenter)) {
      position.x = horizontalCenter;
    }
  }

  Future<void> _loadCharacterSprites() async {
    final only = await gameRef.loadSprite('game/player/${character.name}.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.only: only,
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

  void reset() {
    _velocity = Vector2.zero();
    current = PlayerState.only;
  }

  void resetPosition() {
    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      (gameRef.size.y - size.y) / 2,
    );
  }

  void setFollowPlayer() {
    if (remainLife <= 0) return;

    for (var i = 1; i < remainLife; i++) {
      addFollowPlayer();
    }
  }

  void addFollowPlayer() {
    SpriteGroupComponent followComp;
    int index = 0;
    if (gameRef.followPlayers.isEmpty) {
      followComp = this;
      index = 1;
    } else {
      followComp = gameRef.followPlayers.last;
      index = gameRef.followPlayers.last.index + 1;
    }

    var followPlayer = FollowPlayer(
      character: gameRef.gameManager.character,
      index: index,
      followComponent: followComp,
    );

    gameRef.followPlayers.add(followPlayer);
    gameRef.add(followPlayer);
  }

  void removeFollowPlayer() {
    var removeLast = gameRef.followPlayers.removeLast();
    removeLast.removeFromParent();
  }
}

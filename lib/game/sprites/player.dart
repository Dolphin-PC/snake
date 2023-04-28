import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:snake/game/snake.dart';

enum PlayerState { only }

enum Character { spaceShips_001 }

class Player extends SpriteGroupComponent<PlayerState> with HasGameRef<Snake>, KeyboardHandler, CollisionCallbacks {
  Player({
    super.position,
    required this.character,
  }) : super(
          size: Vector2(100, 100),
          anchor: Anchor.center,
          priority: 1,
        );

  Character character;

  int _hAxisInput = 0;
  final int movingLeftInput = -1;
  final int movingRightInput = 1;
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

  Future<void> _loadCharacterSprites() async {
    final only = await gameRef.loadSprite('game/player/${character.name}.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.only : only
    };
  }
}

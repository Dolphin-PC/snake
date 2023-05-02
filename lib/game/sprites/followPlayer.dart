import 'package:flame/components.dart';
import 'package:snake/game/snake.dart';
import 'package:snake/game/sprites/player.dart';

class FollowPlayer extends SpriteGroupComponent<PlayerState> with HasGameRef<Snake> {
  FollowPlayer({super.position, required this.character, required this.index, required this.followComponent})
      : super(
          size: Vector2(50, 50),
          anchor: Anchor.center,
          priority: 1,
        );

  Character character;
  final int index;
  SpriteGroupComponent followComponent;

  @override
  Future<void> onLoad() async {
    await _loadCharacterSprites();
    current = PlayerState.only;

    super.onLoad();
  }

  @override
  void update(double dt) {
    var gapX = followComponent.position.x - position.x;
    if (gapX.abs() > 1) {
      Future.delayed(Duration(milliseconds: 1), () {
        position.x = followComponent.position.x;
      });
    }

    position.y = followComponent.position.y + 50;
    super.update(dt);
  }

  Future<void> _loadCharacterSprites() async {
    final only = await gameRef.loadSprite('game/player/${character.name}.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.only: only,
    };
  }


}

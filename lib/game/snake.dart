
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:snake/game/background.dart';
import 'package:snake/game/managers/game_manager.dart';
import 'package:snake/game/managers/object_manager.dart';
import 'package:snake/game/sprites/player.dart';

class Snake extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  Snake({super.children});

  final int screenBufferSpace = 300;
  final Background _background = Background();

  GameManager gameManager = GameManager();
  ObjectManager objectManager = ObjectManager();

  late Player player;

  @override
  Future<void> onLoad() async {
    await add(_background);
    await add(gameManager);
    await add(gameManager);
  }
}
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:snake/game/background.dart';
import 'package:snake/game/managers/game_manager.dart';
import 'package:snake/game/managers/level_manager.dart';
import 'package:snake/game/managers/level_manager.dart';
import 'package:snake/game/managers/object_manager.dart';
import 'package:snake/game/sprites/followPlayer.dart';
import 'package:snake/game/sprites/player.dart';
import 'package:snake/main.dart';

class Snake extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  Snake({super.children});

  final int screenBufferSpace = 300;
  final Background _background = Background();

  GameManager gameManager = GameManager();
  ObjectManager objectManager = ObjectManager();
  LevelManager levelManager = LevelManager();

  late Player player;
  late List<FollowPlayer> followPlayers = [];

  @override
  Future<void> onLoad() async {
    await add(_background);

    await add(gameManager);
    await add(levelManager);
    overlays.add(Overlays.mainMenu.name);

    // startGame();
  }

  @override
  void update(double dt) {
    if (!gameManager.isPlaying) {
      return;
    }

    camera.worldBounds = Rect.fromLTRB(
      0,
      camera.position.y - screenBufferSpace,
      camera.gameSize.x,
      camera.position.y + _background.size.y,
    );

    super.update(dt);
  }

  void setPlayer() {
    player = Player(character: gameManager.character);
    add(player);
    player.setFollowPlayer();
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  void onLose() {
    gameManager.state = GameState.gameOver;
    player.removeFromParent();
    overlays.add(Overlays.gameOver.name);
  }

  void resetGame() {
    startGame();
    overlays.remove(Overlays.gameOver.name);
  }

  void startGame() {
    initializeGameStart();

    overlays.remove(Overlays.mainMenu.name);
    overlays.add(Overlays.game.name);
    gameManager.state = GameState.playing;
  }

  void initializeGameStart() {
    setPlayer();
    player.reset();
    if (children.contains(objectManager)) {
      objectManager.removeFromParent();
    }

    _background.size.y = 0;
    camera.worldBounds = Rect.fromLTRB(
      0,
      -_background.size.y,
      camera.gameSize.x,
      _background.size.y + screenBufferSpace,
    );
    camera.followComponent(player);

    player.resetPosition();

    gameManager.reset();

    objectManager = ObjectManager();
    add(objectManager);

    // levelManager.reset();

    // Core gameplay: Reset player & camera boundaries

    // Add a Player to the game: Reset Dash's position back to the start
  }
}

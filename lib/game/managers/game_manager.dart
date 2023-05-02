import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake/game/snake.dart';
import 'package:snake/game/sprites/player.dart';

enum GameState { intro, playing, gameOver }

class GameManager extends Component with HasGameRef<Snake> {
  GameManager();

  Character character = Character.spaceShips_001;
  ValueNotifier<int> score = ValueNotifier(0);
  ValueNotifier<int>? star;
  GameState state = GameState.intro;

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await initStar();
  }

  Future initStar() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    int starCount = instance.getInt('star') ?? 0;
    star = ValueNotifier(starCount);
  }

  void reset() {
    score.value = 0;
    gameRef.levelManager.reset();
    state = GameState.intro;
  }

  void increaseScore() {
    score.value++;

    if (gameRef.levelManager.shouldLevelUp(score: score.value)) {
      gameRef.levelManager.increaseLevel();
    }
  }
}

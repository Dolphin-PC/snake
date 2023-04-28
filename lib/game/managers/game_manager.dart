import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:snake/game/snake.dart';
import 'package:snake/game/sprites/player.dart';

enum GameState { intro, playing, gameOver }

class GameManager extends Component with HasGameRef<Snake> {
  GameManager();

  Character character = Character.spaceShips_001;
  ValueNotifier<int> score = ValueNotifier(0);
  GameState state = GameState.intro;

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;



  void reset() {
    score.value = 0;
    state = GameState.intro;
  }

  void increaseScore() {
    score.value++;
  }

}
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import '../snake.dart';

class LevelManager extends Component with HasGameRef<Snake> {
  LevelManager({this.selectedLevel = 1});

  int selectedLevel;
  ValueNotifier<int> level = ValueNotifier(1);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  final Map<int, Difficulty> levelsConfig = {
    1: const Difficulty(speed: 700, score: 0),
    2: const Difficulty(speed: 350, score: 5),
    3: const Difficulty(speed: 400, score: 10),
    4: const Difficulty(speed: 450, score: 15),
    5: const Difficulty(speed: 500, score: 20),
    6: const Difficulty(speed: 550, score: 30),
    7: const Difficulty(speed: 600, score: 50),
    8: const Difficulty(speed: 650, score: 70),
    9: const Difficulty(speed: 700, score: 100),
    10: const Difficulty(speed: 700, score: 150),
  };


  double get speed {
    return levelsConfig[level.value]!.speed;
  }

  Difficulty get difficulty {
    return levelsConfig[level.value]!;
  }

  bool shouldLevelUp({required int score}) {
    int nextLevel = level.value + 1;

    if (levelsConfig.containsKey(nextLevel)) {
      return levelsConfig[nextLevel]!.score == score;
    }

    return false;
  }

  List<int> get levels {
    return levelsConfig.keys.toList();
  }

  void increaseLevel() {
    if (level.value < levelsConfig.keys.length) {
      level.value++;
    }
  }

  void setLevel(int newLevel) {
    if (levelsConfig.containsKey(newLevel)) {
      level.value = newLevel;
    }
  }

  void selectLevel(int selectLevel) {
    if (levelsConfig.containsKey(selectLevel)) {
      selectedLevel = selectLevel;
    }
  }

  void reset() {
    level.value = selectedLevel;
  }
}

class Difficulty {
  final double speed;
  final int score;

  const Difficulty({
    required this.speed,
    required this.score,
  });
}

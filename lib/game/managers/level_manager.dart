import 'package:flame/components.dart';

import '../snake.dart';

class LevelManager extends Component with HasGameRef<Snake> {
  LevelManager({this.level = 2});

  int level;
}

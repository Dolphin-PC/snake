import 'package:flame/components.dart';
import 'package:snake/game/snake.dart';
import 'package:snake/game/util/num_utils.dart';

class ObjectManager extends Component with HasGameRef<Snake> {
  ObjectManager({
    this.minVerticalDistanceToNextPlatform = 200,
    this.maxVerticalDistanceToNextPlatform = 300,
  });

  double minVerticalDistanceToNextPlatform;
  double maxVerticalDistanceToNextPlatform;
  final probGen = ProbabilityGenerator();
}

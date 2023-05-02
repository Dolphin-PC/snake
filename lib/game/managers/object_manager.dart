import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:snake/game/snake.dart';
import 'package:snake/game/sprites/platform.dart';
import 'package:snake/game/util/num_utils.dart';

final Random _rand = Random();

class ObjectManager extends Component with HasGameRef<Snake> {
  ObjectManager({
    this.minVerticalDistanceToNextPlatform = 200,
    this.maxVerticalDistanceToNextPlatform = 300,
  });

  double minVerticalDistanceToNextPlatform;
  double maxVerticalDistanceToNextPlatform;
  final double _tallestPlatformHeight = 50;
  final probGen = ProbabilityGenerator();
  final List<NormalPlatform> normalPlatforms = [];
  final List<ItemPlatform> itemPlatforms = [];
  double lastPositionY = 0.0;

  final Map<String, bool> specialPlatforms = {
    'plus_point': true, // level 1
  };

  @override
  void onMount() {
    super.onMount();

    addLineNormalPlatform(gameRef.camera.position.y + 300);
    addItemPlatform(gameRef.camera.position.y - 300);

    addLineNormalPlatform(_generateNormalNextY());
    addItemPlatform(_getItemNextY());
  }

  @override
  void update(double dt) {
    final topOfLowestNormalPlatform = normalPlatforms.first.position.y;
    final topOfLowestItemPlatform = itemPlatforms.first.position.y;
    final screenBottom = gameRef.player.position.y + (gameRef.size.x / 2) + gameRef.screenBufferSpace;

    if (topOfLowestNormalPlatform > screenBottom) {
      addLineNormalPlatform(_generateNormalNextY());
      _cleanNormalPlatforms();
    }

    if (topOfLowestItemPlatform > screenBottom) {
      addItemPlatform(_getItemNextY());
      _cleanItemPlatform();
    }

    super.update(dt);
  }

  void addLineNormalPlatform(double posY) {
    List<Vector2> positionList = generateNextLinePosition(posY);
    for (var position in positionList) {
      var normalPlatform = NormalPlatform(position: position);
      normalPlatforms.add(normalPlatform);
      add(normalPlatform);
    }
  }

  void addItemPlatform(double posY) {
    double x = Random().nextInt(4) * 100;

    var itemPlatform = ItemPlatform(position: Vector2(x, posY));
    itemPlatforms.add(itemPlatform);
    add(itemPlatform);
  }

  List<Vector2> generateNextLinePosition(double currentY) {
    int lineCount = (gameRef.camera.gameSize.x / 100).ceil();
    List<Vector2> resultList = [];

    double currentX = 0;

    for (int line = 0; line < lineCount; line++) {
      currentX = (100 * line) as double;
      resultList.add(Vector2(currentX, currentY));
    }

    return resultList;
  }

  double _generateNormalNextY() {
    final currentHighestPlatformY = normalPlatforms.last.position.y;
    return currentHighestPlatformY - gameRef.camera.gameSize.y;
  }

  double _getItemNextY() {
    final currentHighestItemPlatformY = itemPlatforms.last.position.y;
    return currentHighestItemPlatformY - gameRef.camera.gameSize.y;
  }

  void _cleanNormalPlatforms() {
    var firstPlatform = normalPlatforms[0];
    normalPlatforms.removeWhere((element) {
      if (element.position.y == firstPlatform.position.y) {
        element.removeFromParent();
        return true;
      }
      return false;
    });
  }

  void _cleanItemPlatform() {
    if (itemPlatforms.isNotEmpty) {
      itemPlatforms.first.removeFromParent();
      itemPlatforms.removeAt(0);
    }
  }

}

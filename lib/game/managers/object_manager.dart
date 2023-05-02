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
  final List<ItemPlatform> lifeItemPlatforms = [];
  final List<ItemPlatform> starItemPlatforms = [];
  double lastPositionY = 0.0;
  late int line100count = 0;

  final Map<String, bool> specialPlatforms = {
    'plus_point': true, // level 1
  };
  double starItemPosY = 0;

  @override
  void onLoad() {
    super.onLoad();
    line100count = (gameRef.camera.gameSize.x / 100).ceil();

    addLineNormalPlatform(-gameRef.player.position.y);
    addItemPlatform(-gameRef.camera.position.y);
    addStarPlatform(-gameRef.camera.position.y);

    addLineNormalPlatform(_generateNormalNextY());
    addItemPlatform(_getItemNextY(lifeItemPlatforms));
  }

  @override
  void update(double dt) {
    final topOfLowestNormalPlatform = normalPlatforms.first.position.y;
    final topOfLowestItemPlatform = lifeItemPlatforms.first.position.y;
    final starItemFirstPosY = starItemPlatforms.first.position.y;

    final screenBottom = gameRef.player.position.y + (gameRef.size.x / 2) + gameRef.screenBufferSpace;

    if (topOfLowestNormalPlatform > screenBottom) {
      addLineNormalPlatform(_generateNormalNextY());
      _cleanNormalPlatforms();
    }

    if (topOfLowestItemPlatform > gameRef.player.position.y) {
      addItemPlatform(_getItemNextY(lifeItemPlatforms));
      _cleanItemPlatform(lifeItemPlatforms);
    }

    if (starItemPosY > gameRef.player.position.y) {
      print(starItemPosY);
      print(gameRef.player.position.y);
      if (probGen.generateWithProbability(50)) {
        addStarPlatform(_getItemNextY(starItemPlatforms));
        _cleanItemPlatform(starItemPlatforms);
      } else {
        starItemPosY -= gameRef.camera.position.y;
      }
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
    double x = Random().nextInt(line100count) * 100;

    ItemPlatform lifeItemPlatform = ItemPlatform(position: Vector2(x, posY), itemPlatformState: ItemPlatformState.life);
    lifeItemPlatforms.add(lifeItemPlatform);
    add(lifeItemPlatform);
  }

  void addStarPlatform(double posY) {
    starItemPosY = posY;

    double x = Random().nextInt(line100count) * 100;

    ItemPlatform starItemPlatform = ItemPlatform(position: Vector2(x, posY), itemPlatformState: ItemPlatformState.star);
    starItemPlatforms.add(starItemPlatform);
    add(starItemPlatform);
  }

  List<Vector2> generateNextLinePosition(double currentY) {
    List<Vector2> resultList = [];

    double currentX = 0;

    for (int line = 0; line < line100count; line++) {
      currentX = (100 * line) as double;
      resultList.add(Vector2(currentX, currentY));
    }

    return resultList;
  }

  double _generateNormalNextY() {
    final currentHighestPlatformY = normalPlatforms.last.position.y;
    return currentHighestPlatformY - gameRef.camera.gameSize.y;
  }

  double _getItemNextY(List<ItemPlatform> itemList) {
    final currentHighestItemPlatformY = itemList.last.position.y;
    int rand = Random().nextInt(gameRef.screenBufferSpace);
    int rand2 = Random().nextInt(gameRef.screenBufferSpace);
    return currentHighestItemPlatformY - gameRef.camera.gameSize.y + rand - rand2;
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

  void _cleanItemPlatform(List<ItemPlatform> itemList) {
    if (itemList.isNotEmpty) {
      itemList.first.removeFromParent();
      itemList.removeAt(0);
    }
  }
}

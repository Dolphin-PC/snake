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
  final List<Platform> normalPlatforms = [];
  final List<Platform> lifeItemPlatforms = [];
  final List<Platform> starItemPlatforms = [];
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

    normalPlatforms.clear();
    lifeItemPlatforms.clear();
    starItemPlatforms.clear();

    addLineNormalPlatform(0.0);
    addLifeItemPlatform(0 - gameRef.size.y / 2);
    addStarPlatform(0 - gameRef.size.y / 2);

    addLineNormalPlatform(_getPlatformNextY(normalPlatforms));
    addLifeItemPlatform(_getPlatformNextY(lifeItemPlatforms));
  }

  @override
  void update(double dt) {
    double screenBottom = gameRef.player.position.y + (gameRef.size.y / 2) + gameRef.screenBufferSpace;

    if (normalPlatforms.length < 3 * line100count) {
      addLineNormalPlatform(_getPlatformNextY(normalPlatforms));
    }
    _cleanPlatforms(normalPlatforms, posY: screenBottom);

    if (lifeItemPlatforms.length < 3) {
      addLifeItemPlatform(_getPlatformNextY(lifeItemPlatforms));
    }
    _cleanPlatforms(lifeItemPlatforms, posY: screenBottom);

    if (starItemPlatforms.length < 3 && gameRef.gameManager.score.value % 5 == 0) {
      addStarPlatform(_getPlatformNextY(starItemPlatforms));
    }
    _cleanPlatforms(starItemPlatforms, posY: screenBottom);



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

  void addLifeItemPlatform(double posY) {
    double x = Random().nextInt(line100count) * 100;

    ItemPlatform lifeItemPlatform = ItemPlatform(
      position: Vector2(x, posY),
      itemPlatformState: ItemPlatformState.life,
    );
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

  double _getPlatformNextY(List<Platform> itemList) {
    if(itemList.isEmpty) {
      return gameRef.camera.position.y - gameRef.screenBufferSpace;
    }

    final currentHighestItemPlatformY = itemList.last.position.y;
    return currentHighestItemPlatformY - gameRef.camera.gameSize.y;
  }

  void _cleanPlatforms(List<Platform> platforms, {required double posY}) {
    if (platforms.isNotEmpty) {
      platforms.removeWhere((element) {
        // print(element.position.y > posY);
        if (element.position.y > posY) {
          element.removeFromParent();
          return true;
        }
        return false;
      });
    }
  }

  void _cleanItemPlatform(List<ItemPlatform> itemList) {
    if (itemList.isNotEmpty) {
      itemList.first.removeFromParent();
      itemList.removeAt(0);
    }
  }
}

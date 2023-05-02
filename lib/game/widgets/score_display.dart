// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:snake/game/snake.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key, required this.game, this.isLight = false});

  final Game game;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: (game as Snake).gameManager.score,
          builder: (context, value, child) {
            return Text(
              'Score: $value',
              style: Theme.of(context).textTheme.displaySmall!,
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: (game as Snake).levelManager.level,
          builder: (context, value, child) {
            return Text(
              'Level: $value',
              style: Theme.of(context).textTheme.displaySmall!,
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: (game as Snake).gameManager.star!,
          builder: (context, value, child) {
            return Text(
              'Star: $value',
              style: Theme.of(context).textTheme.displaySmall!,
            );
          },
        ),
      ],
    );
  }
}

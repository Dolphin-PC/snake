// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:snake/game/widgets/buttons.dart';
import 'package:snake/main.dart';

import '../snake.dart';
import 'score_display.dart';

// Overlay that pops up when the game ends
class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Game Over',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(),
              ),
              const SizedBox(height: 50),
              ScoreDisplay(
                game: game,
                isLight: true,
              ),
              const SizedBox(
                height: 50,
              ),
              Buttons.titleButton(
                context: context,
                onPressed: () {
                  (game as Snake).resetGame();
                },
                text: "Play Again",
              ),
              const SizedBox(
                height: 20,
              ),
              Buttons.titleButton(
                context: context,
                onPressed: () {
                  game.overlays.add(Overlays.mainMenu.name);
                  game.overlays.remove(Overlays.gameOver.name);

                },
                text: "Main Menu",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

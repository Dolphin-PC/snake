import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:snake/game/snake.dart';
import 'package:snake/game/widgets/buttons.dart';

class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay(this.game, {Key? key}) : super(key: key);

  final Game game;

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Game Intro'),
            Buttons.titleButton(
                context: context,
                onPressed: () {
                  (widget.game as Snake).startGame();
                },
                text: 'Play Game'),
          ],
        ),
      ),
    );
  }
}

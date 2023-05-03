import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake/game/snake.dart';
import 'package:snake/game/widgets/buttons.dart';

import '../sprites/player.dart';

class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay(this.game, {Key? key}) : super(key: key);

  final Game game;

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  int highScore = 0;
  int star = 0;

  @override
  void initState() {
    super.initState();

    getStoredData();
  }

  Future getStoredData() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    setState(() {
      highScore = instance.getInt('high_score') ?? 0;
      star = instance.getInt('star') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SPACE BLOCK',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(),
            ),
            const SizedBox(height: 50),
            OutlinedButton(
              onPressed: () {},
              child: Column(
                children: [
                  ˚
                  Image.asset('game/player/${character.name}.png')
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('High Score'),
                    Text(
                      highScore.toString(),
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(),
                    ),
                  ],
                ),
                const SizedBox(width: 50),
                Column(
                  children: [
                    const Text('Star'),
                    Text(
                      star.toString(),
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Buttons.titleButton(
              context: context,
              onPressed: () {
                (widget.game as Snake).startGame();
              },
              text: 'Play Game',
            ),
          ],
        ),
      ),
    );
  }
}

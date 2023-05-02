import 'package:flutter/material.dart';

class Buttons {
  static titleButton({required BuildContext context, required Function onPressed, required String text}) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          const Size(200, 75),
        ),
        textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.titleLarge),
      ),
      child: Text(text),
    );
  }
}

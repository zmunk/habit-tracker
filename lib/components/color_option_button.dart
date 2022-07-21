import 'package:flutter/material.dart';

class ColorOptionButton extends StatelessWidget {
  final Function()? onPressed;
  final Color color;

  const ColorOptionButton(
      {super.key, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    const double size = 50;
    return Padding(
      padding: const EdgeInsets.all(3),
      child: MaterialButton(
        onPressed: onPressed,
        height: size,
        color: color,
        minWidth: size,
        shape: const CircleBorder(side: BorderSide.none),
      ),
    );
  }
}

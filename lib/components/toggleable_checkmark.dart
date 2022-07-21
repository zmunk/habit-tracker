import 'package:flutter/material.dart';
import 'package:habits/extra_icons.dart';

class ToggleableCheckmark extends StatelessWidget {
  final bool isChecked;
  final Function()? onToggle;
  final double padding;
  final double iconSize;
  final Color color;

  const ToggleableCheckmark({
    super.key,
    required this.isChecked,
    required this.onToggle,
    required this.padding,
    required this.iconSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onToggle,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Icon(
          isChecked ? ExtraIcons.check : ExtraIcons.cancel,
          size: iconSize,
          color: isChecked ? color : Colors.grey,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DayLabel extends StatelessWidget {
  final String dayOfWeek;
  final int dayNumber;
  final double colWidth;
  final bool isToday;
  static const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 10,
  );

  const DayLabel({
    super.key,
    required this.dayOfWeek,
    required this.dayNumber,
    required this.colWidth,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    const double radius = 20;
    double padding = (colWidth - 2 * radius) / 2;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: isToday ? Colors.grey.shade800 : Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayOfWeek,
              style: style,
            ),
            Text(
              dayNumber.toString(),
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}

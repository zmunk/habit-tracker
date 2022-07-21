import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ScoreIndicator extends StatelessWidget {
  final Color color;
  final double width;
  final double percent;

  const ScoreIndicator(this.color, {this.width = 32, required this.percent});

  @override
  Widget build(BuildContext context) {
    const double radius = 8;
    double padding = (width - 2 * radius) / 2;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: CircularPercentIndicator(
        radius: radius,
        lineWidth: 3,
        percent: percent,
        progressColor: color,
        backgroundColor: Colors.grey.shade700,
      ),
    );
  }
}

import 'dart:math';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:habits/components/score_indicator.dart';
import 'package:habits/components/toggleable_checkmark.dart';
import 'package:habits/storage.dart';
import 'package:habits/utils.dart';

class HabitRow extends StatefulWidget {
  final Function refresh;
  final String habitName;
  final Color color;
  final Set<DateTime> checkedDates;
  final List<DateTime> allDates;
  final int numOfDatesInRow;
  final double nameColWidth;
  final double dayColWidth;

  const HabitRow(
    ValueKey<int> key, {
    required this.refresh,
    required this.habitName,
    required this.color,
    required this.checkedDates,
    required this.allDates,
    required this.numOfDatesInRow,
    required this.nameColWidth,
    required this.dayColWidth,
  }) : super(key: key);

  @override
  State<HabitRow> createState() => _HabitRowState();
}

class _HabitRowState extends State<HabitRow> {
  int get rowKey {
    return (widget.key as ValueKey).value;
  }

  bool isExpanded = false;

  calculateScore(Set<DateTime> checkedDates) {
    double score;
    DateTime today = getToday();
    const double weight = 1.0;
    const double weightDiff = 0.05;
    const int numOfDays = 30;
    List<double> values = List.generate(numOfDays, (_) => 0);
    for (var date in checkedDates) {
      var diff = today.difference(date).inDays.round();
      if (diff < numOfDays) {
        values[diff] = weight - weightDiff * diff;
      }
    }
    score = values.average;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 16;
    double padding = (widget.dayColWidth - iconSize) / 2;
    List<Widget> checkmarks = widget.allDates
        .map<Widget>((date) => ToggleableCheckmark(
            onToggle: () {
              sharedPrefs.toggleDate(rowKey, date);
              widget.refresh();
            },
            isChecked: widget.checkedDates.contains(date),
            padding: padding,
            iconSize: iconSize,
            color: widget.color))
        .toList();
    const double scoreIndicatorWidth = 32;
    double percentScore = calculateScore(widget.checkedDates);
    return Card(
      child: Column(
        children: [
          InkWell(
            onLongPress: () => setState(() => isExpanded = !isExpanded),
            child: Row(
              children: [
                ScoreIndicator(
                  widget.color,
                  width: scoreIndicatorWidth,
                  percent: percentScore,
                ),
                SizedBox(
                  width: widget.nameColWidth - 3 - scoreIndicatorWidth,
                  child: Text(
                    widget.habitName,
                    style: TextStyle(color: widget.color),
                  ),
                ),
                ...checkmarks,
              ],
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /* calendar */
                  Expanded(
                    flex: 1,
                    child: Calendar(
                      checkedDates: widget.checkedDates,
                      color: widget.color,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: () {
                      sharedPrefs.deleteHabitRow(rowKey);
                      widget.refresh();
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

enum SquareType {
  checked,
  unchecked,
  empty,
}

class Calendar extends StatefulWidget {
  static double squareSize = 10;
  final Set<DateTime> checkedDates;
  final Color color;
  late List<List<SquareType>> flags;
  final DateTime today = getToday();
  late int vt;

  Calendar({
    super.key,
    required this.checkedDates,
    required this.color,
  }) {
    vt = today.weekday % 7;

    int numOfWeeks = 15;
    var flags = List.generate(
        numOfWeeks, (_) => List.generate(7, (_) => SquareType.unchecked));

    for (var date in checkedDates) {
      var coords = getCoords(date);
      flags[numOfWeeks - coords[0] - 1][coords[1]] = SquareType.checked;
    }

    for (var i = vt + 1; i < 7; i++) {
      flags.last[i] = SquareType.empty;
    }
    this.flags = flags;
  }

  List<int> getCoords(DateTime day) {
    int r = day.weekday % 7; // index in column
    int c = ((today.difference(day) + Duration(days: r - vt)).inDays / 7)
        .round(); // index of column
    return [c, r];
  }

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.flags
              .map((week) => Column(
                    children: week
                        .map(
                          (flag) => Padding(
                            padding: const EdgeInsets.all(0.5),
                            child: SizedBox(
                              width: Calendar.squareSize,
                              height: Calendar.squareSize,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: flag == SquareType.checked
                                      ? widget.color
                                      : flag == SquareType.unchecked
                                          ? Colors.grey
                                          : Colors.white.withOpacity(0),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ))
              .toList()),
    );
  }
}

import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:habits/components/day_label.dart';
import 'package:habits/components/habit_row.dart';
import 'package:habits/storage.dart';
import 'package:habits/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List habitRows = [];

  refresh() {
    setState(() {
      habitRows = sharedPrefs.getHabitRows();
    });
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    const double iconSplashRadius = 20;
    double screenWidth = MediaQuery.of(context).size.width;
    double nameColWidth = min(0.4 * screenWidth, 300);
    const double dayColWidth = 50;
    int numOfDatesInRow = (screenWidth - nameColWidth - 10) ~/ dayColWidth;
    List<DateTime> allDates = [];
    List<DayLabel> dayLabels = [];
    DateTime now = DateTime.now();
    DateTime day = DateTime(now.year, now.month, now.day);
    for (var i = 0; i < numOfDatesInRow; i++) {
      allDates.add(day);
      dayLabels.add(DayLabel(
        dayOfWeek: abbreviateWeekday(day.weekday),
        dayNumber: day.day,
        colWidth: dayColWidth,
        isToday: i == 0,
      ));
      day = day.subtract(const Duration(days: 1));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
        actions: [
          IconButton(
            splashRadius: iconSplashRadius,
            onPressed: () {
              Navigator.of(context).pushNamed('/add').then((newRow) {
                if (newRow == null) {
                  return;
                }
                sharedPrefs.addHabitRow(newRow as Map);
                setState(() {
                  habitRows = sharedPrefs.getHabitRows();
                });
              });
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<String>(
            onSelected: (s) {
              if (s == 'Delete all') {
                sharedPrefs.reset();
              }
              refresh();
            },
            itemBuilder: (BuildContext context) => {'Delete all'}
                .map((String choice) => PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    ))
                .toList(),
          ),
        ],
      ),
      body: Column(children: [
        const SizedBox(height: 10),
        Row(children: [
          SizedBox(width: nameColWidth),
          ...dayLabels,
        ]),
        Expanded(
          child: ListView(
            children: habitRows
                .map((row) => HabitRow(
                      ValueKey(row['key']),
                      refresh: refresh,
                      habitName: row['name'],
                      color: row['color'],
                      checkedDates: HashSet.from(row['dates']),
                      allDates: allDates,
                      numOfDatesInRow: numOfDatesInRow,
                      nameColWidth: nameColWidth,
                      dayColWidth: dayColWidth,
                    ))
                .toList(),
          ),
        ),
      ]),
    );
  }
}

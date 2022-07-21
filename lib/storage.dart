import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late SharedPreferences _prefs;
  static String habitRowsSaveKey = 'data';
  static String habitsKeySaveKey = 'lastKey';

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int get nextKey {
    int? lastKey = _prefs.getInt(habitsKeySaveKey);
    int nextKey = (lastKey ?? 0) + 1;
    _prefs.setInt(habitsKeySaveKey, nextKey);
    // return nextKey.toString();
    return nextKey;
  }

  List getHabitRows() {
    String? rawData = _prefs.getString(habitRowsSaveKey);
    if (rawData == null) {
      return [];
    }
    List decodedList = decode(rawData);
    return decodedList;
  }

  reset() {
    _prefs.remove(habitsKeySaveKey);
    _prefs.remove(habitRowsSaveKey);
  }

  // void deleteAllHabits() {
  //   _prefs.remove(habitsKeySaveKey);
  //   _prefs.setString(habitRowsSaveKey, json.encode([]));
  // }

  /// decode json string to list
  /// decode colors and dates from string
  List decode(String rawData) {
    var decoded = json
        .decode(rawData)
        .map((row) => {
              ...row,
              'color': Color(row['color']),
              'dates': row['dates']
                  .map<DateTime>((date) => DateTime.parse(date))
                  .toList(),
            })
        .toList();
    return decoded;
  }

  /// encode list to json string
  /// encode colors and dates to string
  String encode(List list) {
    var encoded = list
        .map((row) => {
              ...row,
              'color': row['color'].value,
              'dates': row['dates'].map((date) => date.toString()).toList(),
            })
        .toList();
    return json.encode(encoded);
  }

  toggleDate(int key, DateTime date) {
    List rows = getHabitRows();
    List<DateTime> dates = rows.firstWhere((e) => e['key'] == key)['dates'];
    if (dates.contains(date)) {
      dates.remove(date);
    } else {
      dates.add(date);
    }
    saveHabitRows(rows);
  }

  saveHabitRows(List list) {
    String encodedList = encode(list);
    _prefs.setString(habitRowsSaveKey, encodedList);
  }

  addHabitRow(Map row) {
    List rows = getHabitRows();
    rows.add({...row, 'key': nextKey});
    saveHabitRows(rows);
  }

  deleteHabitRow(int key) {
    List rows = getHabitRows();
    rows.removeWhere((e) => e['key'] == key);
    saveHabitRows(rows);
  }
}

SharedPrefs sharedPrefs = SharedPrefs();

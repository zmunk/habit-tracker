import 'package:flutter/material.dart';
import 'package:habits/components/color_option_button.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  late TextEditingController _controller;

  Color selectedColor = Colors.orange;
  List<List<Color>> colors = [
    [
      const Color(0xffee9a9a),
      const Color(0xffffab91),
      const Color(0xffffcc80),
      const Color(0xffffecb2),
    ],
    [
      const Color(0xff69f0ae),
      const Color(0xffc5e1a6),
      const Color(0xffe6ee9b),
      const Color(0xfffff59c),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void colorSelection(BuildContext context) async {
    var selection = await showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Change color'),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        alignment: Alignment.center,
        elevation: 10,
        children: colors
            .map((colorsRow) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: colorsRow
                    .map((color) => ColorOptionButton(
                          onPressed: () => Navigator.pop(context, color),
                          color: color,
                        ))
                    .toList()))
            .toList(),
      ),
    );
    setState(() {
      if (selection != null) {
        selectedColor = selection;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double rowHeight = 50;
    Color borderColor = Colors.grey.shade300;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create habit'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.black.withOpacity(0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    'name': _controller.text,
                    'color': selectedColor,
                    'dates': [],
                  });
                },
                child: const Text('Save'),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: rowHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                    ),
                    border: const OutlineInputBorder(),
                    hintText: 'e.g. Exercise',
                    label: const Text('Name'),
                  ),
                  controller: _controller,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: rowHeight,
                width: 100,
                child: Stack(
                  children: [
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderColor),
                        ),
                        border: const OutlineInputBorder(),
                        label: Text(
                          'Color',
                          style: TextStyle(color: borderColor),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: selectedColor),
                        onPressed: () => colorSelection(context),
                        child: null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

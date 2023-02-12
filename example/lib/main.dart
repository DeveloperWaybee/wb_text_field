import 'package:flutter/material.dart';
import 'package:wb_text_field/wb_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: LayoutBuilder(builder: (context, constraint) {
          print(constraint.biggest.width);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(32),
                child: WBTextField(
                  controller: WBTextFieldController(
                    label: "Date of Birth",
                    datePicker: true,
                    timePicker: true,
                    didSelectDateTime: (date, time) {
                      return "${date.toString()} ${time.toString()}";
                    },
                    // suffix: Icons.ac_unit_rounded,
                    // suffixColor: Colors.grey,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

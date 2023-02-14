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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: IntrinsicHeight(
                child: WBTextField(controller: controller),
              ),
            ),
            // SizedBox(height: 250),
          ],
        ),
      ),
    );
  }
}

final list = List.generate(100, (index) {
  return WBTextFieldOption(
    uniqueId: "$index",
    matchText: "$index",
    child: ListTile(
      tileColor: Colors.transparent,
      title: Text("$index"),
    ),
  );
});

final controller = WBTextFieldController(
  label: "Date of Birth",
  // isClearEnable: true,
  // clearVisibilityAlways: true,
  // maxLength: 10,
  // datePicker: true,
  // timePicker: true,
  // didSelectDateTime: (date, time) {
  //   return "${date.toString()} ${time.toString()}";
  // },
  // suffix: Icons.ac_unit_rounded,
  // suffixColor: Colors.grey,
  // itemBuilderMaxHeight: 200,
  // enableItemSearch: true,
  // itemBuilderHeader: const Padding(
  //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //   child: Text("Create New +"),
  // ),
  // itemBuilderHeaderTapped: (text) async {
  //   return "Create New +";
  // },
  // items: list,
  // itemDidSelect: (id) async {
  //   return list.firstWhere((e) => e.uniqueId == id).matchText;
  // },
);

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

    late final list = List.generate(100, (index) {
      return WBTextFieldOption(
        uniqueId: "$index",
        matchText: "$index",
        child: ListTile(
          title: Text("$index"),
        ),
      );
    });
  
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: LayoutBuilder(builder: (context, constraint) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(32),
                child: WBTextField(
                  controller: WBTextFieldController(
                    label: "Date of Birth",
                    isClearEnable: true,
                    clearVisibilityAlways: true,
                    // datePicker: true,
                    // timePicker: true,
                    // didSelectDateTime: (date, time) {
                    //   return "${date.toString()} ${time.toString()}";
                    // },
                    // suffix: Icons.ac_unit_rounded,
                    // suffixColor: Colors.grey,
                    itemBuilderMaxHeight: 200,
                    enableItemSearch: false,
                    itemBuilderHeader: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Text("Create New +"),
                    ),
                    itemBuilderHeaderTapped: () async {
                      print("Create New +");
                    },
                    items: list,
                    itemDidSelect: (id) async {
                      return list.firstWhere((e) => e.uniqueId == id).matchText;
                    },
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

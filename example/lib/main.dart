import 'package:flutter/material.dart';

import 'package:flutter_magnifier/flutter_magnifier.dart';

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

  CustomMagnifierController controller = CustomMagnifierController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          controller.reset();
        }),
        body: Center(
          child: CustomMagnifier(
              controller: controller,
              maxWidth: 400,
              maxHeight: 300,
              child: Image.asset(
                "assets/images/z.jpg",
                fit: BoxFit.cover,
                width: 400,
                height: 300,
              )),
        ),
      ),
    );
  }
}

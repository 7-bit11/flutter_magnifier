# flutter_magnifier
flutter放大镜，可以放大屏幕内任意位置的内容。


### 效果展示

![图片说明](./example/assets/images/example.gif)


### 使用方法

```dart
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
              magnification: 2,
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
```
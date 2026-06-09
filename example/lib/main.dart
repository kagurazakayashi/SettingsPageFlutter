import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'data.dart';
import 'select_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your applicati on.
  @override
  Widget build(BuildContext context) {
    isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFF35ADD6),
        primaryColorLight: const Color(0xFF79CEEB),
        primarySwatch: Colors.blue,
        hintColor: const Color(0xFF477D8F),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF088AB6),
          secondary: Colors.blue,
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 255, 0, 0),
            backgroundColor:
                const Color.fromARGB(255, 255, 173, 173), // 设置按钮文字的颜色
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor:
                const Color.fromARGB(255, 255, 251, 0), // 设置按钮文字的颜色
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 99, 48, 241),
            side: const BorderSide(
                color: Color.fromARGB(255, 206, 145, 241)), // 设置按钮边框的颜色
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            iconColor: WidgetStateProperty.all<Color>(Colors.red),
          ),
        ),
      ),
      // theme: ThemeData(
      //   primaryColor: const Color(0xFF35ADD6),
      //   primaryColorLight: Colors.red[300],
      //   primarySwatch: const Color(0xFF35ADD6),
      //   colorScheme: const ColorScheme.dark(
      //     primary: Colors.green,
      //     primaryContainer: Colors.greenAccent,
      //     primaryFixed: Colors.lightGreen,
      //     primaryFixedDim: Colors.lightGreenAccent,
      //     onPrimary: Colors.white,
      //     secondary: Colors.blue,
      //     error: const Color(0xFF35ADD6),
      //     surface: Color.fromARGB(255, 116, 99, 73),
      //     surfaceBright: Colors.orangeAccent,
      //     surfaceDim: Colors.orange,
      //     surfaceContainer: Colors.orangeAccent,
      //     surfaceContainerHigh: Colors.orange,
      //     surfaceContainerLow: Colors.orangeAccent,
      //     surfaceContainerLowest: Colors.orange,
      //     surfaceTint: Colors.orange,
      //     onSurface: Colors.orange,
      //     tertiary: Colors.purple,
      //     brightness: Brightness.dark
      //   ),
      //   appBarTheme: const AppBarTheme(
      //     titleTextStyle: TextStyle(
      //       color: Colors.white,
      //     ),
      //   ),
      //   buttonTheme: const ButtonThemeData(
      //     buttonColor: Colors.blue,
      //     textTheme: ButtonTextTheme.primary,
      //     colorScheme: ColorScheme(
      //       brightness: Brightness.light,
      //       primary: Colors.blue,
      //       onPrimary: Colors.lightBlue,
      //       secondary: Colors.green,
      //       onSecondary: Colors.lightGreen,
      //       error: const Color(0xFF35ADD6),
      //       onError: Colors.redAccent,
      //       surface: Colors.yellow,
      //       onSurface: Colors.yellowAccent,
      //     ),
      //   ),
      // ),
      builder: BotToastInit(), //1.调用BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()], //2.注册路由观察者
      debugShowCheckedModeBanner: false,
      home: const SelectPage(),
      // home: const TestTFPage(),
    );
  }
}

class TestTFPage extends StatefulWidget {
  const TestTFPage({
    super.key,
    this.option,
    this.type,
    // 可以提供以下三個選項之一（不可以提供多個）：
    // 1. plist 檔案路徑，絕對路徑。
    this.path = "",
    // 2. 直接提供 plist 內容。
    this.data = "",
    // 3. plist 檔名，路徑基於 [baseDir] 屬性，不帶副檔名。
    this.file = "Root",
    this.baseDir = "Settings.bundle/",
  });
  final List<Map<String, dynamic>>? option;
  final String path;
  final String data;
  final String file;
  final String baseDir;
  final String? type;

  @override
  State<TestTFPage> createState() => _TestTFPageState();
}

class _TestTFPageState extends State<TestTFPage> {
  final TextEditingController _controller = TextEditingController();
  // final regExp = RegExp(r'^(25[0-5]|2[0-4]\d|[01]?\d{1,2})$');
  final regExp = RegExp(r'^\d+$');
  // final regExp = RegExp(
  // r'^(25[0-5]|2[0-4]\d|[01]?\d{1,2}){3}(25[0-5]|2[0-4]\d|[01]?\d{1,2})$');
  bool? isIpv4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.datetime,
          ),
          Text("是否为ipv4: ${isIpv4 != null ? isIpv4! : ""}"),
          ElevatedButton(
            onPressed: () {
              isIpv4 = regExp.hasMatch(_controller.text);
              if (mounted) {
                setState(() {});
              }
            },
            child: const Text("Check ipv4"),
          ),
        ],
      ),
    );
  }
}

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        primarySwatch: Colors.blue,
      ),
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

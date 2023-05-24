import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cupertino_select_page.dart';
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
    if (Platform.isIOS || Platform.isMacOS) {
      isIOS = true;
    }
    isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return isIOS
        ? CupertinoApp(
            title: 'Flutter Demo',
            builder: BotToastInit(), //1.调用BotToastInit
            navigatorObservers: [BotToastNavigatorObserver()], //2.注册路由观察者
            debugShowCheckedModeBanner: false,
            home: const CupertinoSelectPage(),
          )
        : MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            builder: BotToastInit(), //1.调用BotToastInit
            navigatorObservers: [BotToastNavigatorObserver()], //2.注册路由观察者
            debugShowCheckedModeBanner: false,
            home: const SelectPage(),
          );
  }
}

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settingspageflutter/settingspageflutter.dart';

import 'cupertino_select_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your applicati on.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   builder: BotToastInit(), //1.调用BotToastInit
    //   navigatorObservers: [BotToastNavigatorObserver()], //2.注册路由观察者
    //   debugShowCheckedModeBanner: false,
    //   home: const SelectPage(),
    //   // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    // );
    return CupertinoApp(
      title: 'Flutter Demo',
      builder: BotToastInit(), //1.调用BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()], //2.注册路由观察者
      debugShowCheckedModeBanner: false,
      home: const CupertinoSelectPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    SettingsPageFlutter settingsPage = SettingsPageFlutter();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        shrinkWrap: false,
        //沿竖直方向上布局
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(30),
        //每个子组件的高度
        itemExtent: 30,
        children: const <Widget>[
          SizedBox(
            height: 50,
            child: ListTile(title: Text("1")),
          ),
          Divider(),
          SizedBox(
            height: 50,
            child: ListTile(title: Text("1")),
          ),
          Divider(),
          SizedBox(
            height: 50,
            child: ListTile(title: Text("1")),
          ),
          Divider(),
          SizedBox(
            height: 50,
            child: ListTile(title: Text("1")),
          ),
          Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

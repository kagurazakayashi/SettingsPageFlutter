library settingspageflutter;

import 'package:flutter/foundation.dart';
// import 'package:stack_trace/stack_trace.dart';

/// 輸出除錯資訊類
class SettingsPageFlutterDebug {
  /// 輸出除錯資訊的開關。在預設情況下，取 kDebugMode 的值（根據當前模式自動決定是否輸出）。
  static bool printInfo = kDebugMode;

  static String libraryName = "SettingsPageFlutter";
  String className = "";

  /// 建立時指定一個類名 [className] ，用於標識輸出的除錯資訊來自哪個類。
  SettingsPageFlutterDebug({className = ""}) {
    this.className = (className.isNotEmpty ? "/" : "") + className;
  }

  /// 輸出除錯資訊 [info]
  /// [notOnlyDebug] 為 true 時，即使非除錯模式也會輸出除錯資訊
  void d(String info, {notOnlyDebug = false}) {
    if (printInfo || notOnlyDebug) {
      print("[D/$libraryName$className ${timeString()}] $info");
    }
  }

  /// 輸出資訊 [info]
  /// [notOnlyDebug] 為 true 時，即使非除錯模式也會輸出資訊
  void i(String info, {notOnlyDebug = false}) {
    if (printInfo || notOnlyDebug) {
      print("[I/$libraryName$className ${timeString()}] $info");
    }
  }

  /// 輸出警告資訊 [info]
  /// [notOnlyDebug] 為 true 時，即使非除錯模式也會輸出警告資訊
  void w(String info, {notOnlyDebug = false}) {
    if (printInfo || notOnlyDebug) {
      print("[W/$libraryName$className ${timeString()}] $info");
    }
  }

  /// 輸出錯誤資訊 [info]
  /// [notOnlyDebug] 為 true 時，即使非除錯模式也會輸出錯誤資訊
  void e(String info, {notOnlyDebug = false}) {
    if (printInfo || notOnlyDebug) {
      print("[E/$libraryName$className ${timeString()}] $info");
    }
  }

  /// 輸出錯誤資訊 [info] 並丟擲 [Exception] 異常
  /// [notOnlyDebug] 為 true 時，即使非除錯模式也會輸出錯誤資訊
  /// [notOnlyDebugThrowException] 為 true 時，即使非除錯模式也會丟擲 [Exception] 異常
  void ee(String info, {notOnlyDebug = false, bool notOnlyDebugThrowException = false}) {
    e(info, notOnlyDebug: notOnlyDebug);
    if (kDebugMode || notOnlyDebugThrowException) {
      throw Exception(info);
    }
  }

  /// 輸出帶有左右分隔符的顯著標題資訊，如: ===== [info] =====
  /// [separatorCharMaxNum] 分隔符最大數量（隨著 [info] 的長度而減少）
  /// [separatorChar] 分隔符
  void s(String info, {int separatorCharMaxNum = 20, String separatorChar = "="}) {
    if (printInfo) {
      String outInfo = "";
      int separatorCharNum = separatorCharMaxNum - info.length ~/ 2;
      if (separatorCharNum > 0) {
        outInfo = "${separatorChar.padRight(separatorCharNum, separatorChar)} $info ${separatorChar.padRight(separatorCharNum, separatorChar)}";
      } else {
        outInfo = " $info ";
      }
      print(outInfo);
    }
  }

  // eWithStackTrace(String error) {
  //   if (kDebugMode) {
  //     print("[E/$libraryName] $error");
  //     print(Chain.current().terse);
  //   }
  // }

  /// 獲取當前時間 [time] 字串（格式：HH:mm:ss）
  String timeString({DateTime? time}) {
    time ??= DateTime.now();
    // ${time.year}-${time.month}-${time.day}
    return "${addZero(time.hour)}:${addZero(time.minute)}:${addZero(time.second)}";
    // .${time.millisecond}
  }

  /// 數字 [num] 不足 2 位前面補 0
  String addZero(int num) {
    return num < 10 ? "0$num" : "$num";
  }
}

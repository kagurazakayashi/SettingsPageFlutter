library settingspageflutter;

import 'package:settingspageflutter/settingspagedata.dart';
import 'package:settingspageflutter/settingspagedebug.dart';
import 'package:settingspageflutter/settingspageloader.dart';
import 'package:settingspageflutter/settingspageuibuilder.dart';

/// 入口類
class SettingsPageFlutter {
  final String path;
  final String data;
  final String file;
  final String baseDir; // 儲存 plist 檔案的基本目錄
  SettingsPageFlutterDebug log =
      SettingsPageFlutterDebug(className: "Main"); // 輸出除錯資訊

  /// 開始載入根配置檔案
  /// 可以提供以下三個選項之一（不可以提供多個）：
  /// 1. plist 檔案路徑 [path] ，絕對路徑。
  /// 2. 直接提供 plist 內容 [data] 。
  /// 3. plist 檔名 [file] ，路徑基於 [baseDir] 屬性，不帶副檔名。
  SettingsPageFlutter({
    this.path = "",
    this.data = "",
    this.file = "Root",
    this.baseDir = "Settings.bundle/",
  }) {
    log.i(
        "init: baseDir=$baseDir, path=$path or datalen=${data.length} or file=$file");
    SettingsPageLoader loader = SettingsPageLoader(baseDir: baseDir);
    loader
        .loadPlist(plistFilePath: path, importData: data, plistFileName: file)
        .then((SettingsPageData plistData) {
      log.i(
          "LOAD OK: stringsTable: ${plistData.stringsTable} , title: ${plistData.title} , preferenceSpecifiers: ${plistData.preferenceSpecifiers.length}");
      SettingsPageUIBuilder uiBuilder = SettingsPageUIBuilder();
      uiBuilder.buildPage(plistData);
    }).catchError((error) {
      log.e('Failed to load file: $error');
    });
  }
}

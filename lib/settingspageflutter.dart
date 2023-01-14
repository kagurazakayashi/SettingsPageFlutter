library settingspageflutter;

import 'package:settingspageflutter/settingspagedata.dart';
import 'package:settingspageflutter/settingspagedebug.dart';
import 'package:settingspageflutter/settingspageloader.dart';
import 'package:settingspageflutter/settingspageuibuilder.dart';

/// 入口類
class SettingsPageFlutter {
  String baseDir; // 儲存 plist 檔案的基本目錄
  String plistFileName; // 根配置檔案名稱，不含副檔名
  SettingsPageFlutterDebug log = SettingsPageFlutterDebug(className: "Main"); // 輸出除錯資訊

  /// 開始載入根配置檔案
  /// 需要指定一個儲存 [plistFileName].plist 檔案的基本 [baseDir] 目錄。
  SettingsPageFlutter({this.baseDir = "Settings.bundle/", this.plistFileName = "Root"}) {
    log.i("init: baseDir=$baseDir, plistFileName=$plistFileName");
    SettingsPageLoader loader = SettingsPageLoader(baseDir: baseDir);
    loader.loadPlistFile().then((SettingsPageData plistData) {
      log.i("LOAD OK: stringsTable: ${plistData.stringsTable} , title: ${plistData.title} , preferenceSpecifiers: ${plistData.preferenceSpecifiers.length}");
      SettingsPageUIBuilder uiBuilder = SettingsPageUIBuilder();
      uiBuilder.buildPage(plistData);
    }).catchError((error) {
      log.e('Failed to load file: $error');
    });
  }
}

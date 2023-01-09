library settingspageflutter;

import 'package:settingspageflutter/settingspagedebug.dart';
import 'package:settingspageflutter/settingspageloader.dart';

/// 入口類
class SettingsPageFlutter {
  String baseDir;
  String plistFileName = "Root";
  SettingsPageFlutterDebug log = SettingsPageFlutterDebug(className: "Main");

  SettingsPageFlutter({this.baseDir = "config.bundle/", this.plistFileName = "Root"}) {
    log.i("init: baseDir=$baseDir, plistFileName=$plistFileName");
    SettingsPageLoader loader = SettingsPageLoader(baseDir: baseDir);
    loader.loadPlistFile().then((value) {
      log.i("LOAD OK: stringsTable: ${value.stringsTable} , title: ${value.title} , preferenceSpecifiers: ${value.preferenceSpecifiers.length}");
    }).catchError((error) {
      log.e('Failed to load file: $error');
    });
  }
}

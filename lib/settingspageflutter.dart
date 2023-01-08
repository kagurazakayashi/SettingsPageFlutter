library settingspageflutter;

import 'package:flutter/foundation.dart';
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
      log.i(value.toString());
    }).catchError((error) {
      log.e('Failed to load file: $error');
    });
  }
}

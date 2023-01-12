library settingspageflutter;

import 'package:flutter/material.dart';
import 'package:settingspageflutter/settingspagedata.dart';
import 'package:settingspageflutter/settingspagedebug.dart';
import 'package:settingspageflutter/settingspagewidgetbuilder.dart';

class SettingsPageUIBuilder {
  SettingsPageWidgetBuilder widgetBuilder = SettingsPageWidgetBuilder();
  SettingsPageFlutterDebug log = SettingsPageFlutterDebug(className: "UIBuilder"); // 輸出除錯資訊

  ListView buildPage(SettingsPageData plistData) {
    log.i("plistData: title=${plistData.title} , stringsTable=${plistData.stringsTable} , preferenceSpecifiers=${plistData.preferenceSpecifiers}");
    for (Map<String, dynamic> widgetData in plistData.preferenceSpecifiers) {
      // log.s("widgetData");
      // print(widgetData);
    }
    return ListView();
  }
}

library settingspageflutter;

import 'package:flutter/services.dart';
import 'package:settingspageflutter/settingspagedata.dart';
import 'package:settingspageflutter/settingspagedebug.dart';
import 'package:xml/xml.dart';

/// 配置檔案載入器
class SettingsPageLoader {
  SettingsPageFlutterDebug log = SettingsPageFlutterDebug(className: "Loader");
  String baseDir;

  SettingsPageLoader({this.baseDir = "config.bundle/"}) {
    if (!baseDir.endsWith("/")) {
      baseDir += "/";
    }
  }

  /// 讀取一個 plist 檔名 [plistFileName] ，路徑基於 [baseDir] 屬性，不帶副檔名。
  Future<SettingsPageData> loadPlistFile({String plistFileName = "Root"}) async {
    SettingsPageData data = SettingsPageData();
    String plistFilePath = "$baseDir$plistFileName.plist";
    String dataString = await rootBundle.loadString(plistFilePath);
    XmlDocument xmlDocument = XmlDocument.parse(dataString);
    XmlElement? plist = xmlDocument.getElement("plist");
    if (plist == null) {
      String e = "Invalid plist file: $plistFilePath: no plist";
      log.e(e);
      throw Exception(e);
    }
    XmlElement? dict = plist.getElement("dict");
    if (dict == null) {
      String e = "Invalid plist file: $plistFilePath: no dict";
      log.e(e);
      throw Exception(e);
    }
    Map dictChild = keysValsXmlNodeToMap(dict);
    // print("Title: ${dictChild["Title"]}");
    // print("StringsTable: ${dictChild["StringsTable"]}");
    data.title = dictChild["Title"];
    data.stringsTable = dictChild["StringsTable"];
    XmlElement preferenceSpecifiersE = dictChild["PreferenceSpecifiers"];
    for (int i = 0; i < preferenceSpecifiersE.children.length; i++) {
      XmlNode congigDict = preferenceSpecifiersE.children[i];
      Map<String, dynamic> congigInfos = keysValsXmlNodeToMap(congigDict);
      data.preferenceSpecifiers.add(congigInfos);
    }
    return data;
  }

  /// 將類似於 `<key></key><string></string><key></key><integer></integer><key></key><true/>` 這樣的 [node] 轉換為 [Map] 。
  /// [node] 可以是 [XmlElement] 或 [XmlNode] 。
  /// 可以識別的資料型別有: [String] , [int] , [bool] , [XmlElement] , [XmlNode] 。
  Map<String, dynamic> keysValsXmlNodeToMap(dynamic node) {
    Map<String, dynamic> map = {};
    String key = "";
    var children = node.children;
    for (int i = 0; i < children.length; i++) {
      XmlNode child = children[i];
      if (child is XmlText) {
        map[key] = child.text;
      } else if (child is XmlElement) {
        String type = child.name.toString();
        if (type == "key") {
          key = child.text;
        } else if (key.isNotEmpty) {
          switch (type) {
            case "string":
              map[key] = child.text;
              break;
            case "integer":
              map[key] = int.parse(child.text);
              break;
            case "true":
              map[key] = true;
              break;
            case "false":
              map[key] = false;
              break;
            default:
              map[key] = child;
              break;
          }
          key = "";
        }
      }
    }
    return map;
  }
}

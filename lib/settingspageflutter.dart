library settingspageflutter;

import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

/// 配置檔案載入器
class SettingsPageLoader {
  String baseDir = "config.bundle/";
  static String className = "SettingsPageLoader";
  String title = "";
  String stringsTable = "";
  List<Map<String, dynamic>> preferenceSpecifiers = [];

  /// 讀取一個 plist 檔名 [plistFileName] ，路徑基於 [baseDir] 屬性，不帶副檔名。
  Future<String> loadPlistFile({String plistFileName = "Root"}) async {
    String plistFilePath = "$baseDir$plistFileName.plist";
    String dataString = await rootBundle.loadString(plistFilePath);
    XmlDocument xmlDocument = XmlDocument.parse(dataString);
    XmlElement? plist = xmlDocument.getElement("plist");
    if (plist == null) {
      throw Exception("Invalid plist file: $plistFilePath: no plist");
    }
    XmlElement? dict = plist.getElement("dict");
    if (dict == null) {
      throw Exception("Invalid plist file: $plistFilePath: no dict");
    }
    return "";
  }
}

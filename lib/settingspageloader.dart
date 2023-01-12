library settingspageflutter;

import 'package:flutter/services.dart';
import 'package:settingspageflutter/settingspagedata.dart';
import 'package:settingspageflutter/settingspagedebug.dart';
import 'package:xml/xml.dart';

/// 配置檔案載入器
class SettingsPageLoader {
  SettingsPageFlutterDebug log = SettingsPageFlutterDebug(className: "Loader");
  String baseDir;

  /// 需要指定一個儲存 plist 檔案的基本路徑 [baseDir] 目錄。
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
    log.i("- Load File: $plistFilePath , length: ${dataString.length} :");
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
    data.title = dictChild["Title"] ?? "Config";
    data.stringsTable = dictChild["StringsTable"] ?? "";
    XmlElement preferenceSpecifiersE = dictChild["PreferenceSpecifiers"];
    log.i("-");
    bool grouping = false;
    Map<String, dynamic> configInfosT = {};
    for (int i = 0; i < preferenceSpecifiersE.children.length; i++) {
      XmlNode congigDict = preferenceSpecifiersE.children[i];
      Map<String, dynamic> cofigInfos = keysValsXmlNodeToMap(congigDict);
      if (cofigInfos.isEmpty) continue;
      String? chkItem = chkConfigItem(cofigInfos);
      if (chkItem != null) {
        log.e("ERR DATA: $cofigInfos");
        throw Exception(chkItem);
      }
      // log.d("遇到分組 PSGroupSpecifier 物件，處理分組");
      if ((cofigInfos["Type"] ?? "") == "PSGroupSpecifier") {
        if (grouping) {
          // log.d("處於分組狀態中，結束分組");
          data.preferenceSpecifiers.add(configInfosT);
          configInfosT = {};
          grouping = false;
        }
        // log.d("不處於分組狀態中，開始分組");
        List<Map<String, dynamic>> childs = [];
        configInfosT = cofigInfos; // 延迟保存当前分组信息
        configInfosT["Childs"] = childs; // 创建 Childs 项用于保存子项
        grouping = true;
      } else {
        if (grouping) {
          // log.d("處於分組狀態中，新增子項");
          configInfosT["Childs"].add(cofigInfos);
        } else {
          // log.d("不處於分組狀態中，直接新增");
          data.preferenceSpecifiers.add(cofigInfos);
        }
      }
      String logstr = grouping ? "GROUP: ${data.title}/${configInfosT["Title"] ?? ""}" : "ROOT: ${data.title}";
      log.i("- $logstr");
    }
    if (grouping) {
      // log.d("最終處於分組狀態中，結束分組");
      data.preferenceSpecifiers.add(configInfosT);
      configInfosT = {};
      grouping = false;
    }
    return data;
  }

  /// 檢查配置項 [cofigInfos] 中是否包含必要的屬性，如果不包含，則返回錯誤資訊。
  String? chkConfigItem(Map<String, dynamic> cofigInfos) {
    List<String> errs = [];
    List<String> keys = ["Type"]; // , "Title"
    for (String key in keys) {
      if (!cofigInfos.containsKey(key)) {
        errs.add("$key is empty");
      }
    }
    return errs.isEmpty ? null : errs.join(", ");
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
          if (type == "array") {
            log.i("$key = ($type) (length: ${map[key].children.length}) :");
          } else {
            log.i("$key = ($type) ${map[key]}");
          }
          key = "";
        }
      }
    }
    return map;
  }
}

library settingspageflutter;

import 'package:flutter/services.dart';
import 'package:settingspageflutter/settingspagedata.dart';
import 'package:settingspageflutter/settingspagedebug.dart';
import 'package:settingspageflutter/utilities/xml_type_convert.dart';
import 'package:xml/xml.dart';

/// 配置檔案載入器
class SettingsPageLoader {
  SettingsPageFlutterDebug log = SettingsPageFlutterDebug(className: "Loader");
  String baseDir;

  /// 需要指定一個儲存 plist 檔案的基本路徑 [baseDir] 目錄。
  SettingsPageLoader({this.baseDir = "Settings.bundle/"}) {
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
    Map dictChild = XMLDataTypeConvert.keysValsXmlNodeToMap(dict);
    data.title = dictChild["Title"] ?? "Config";
    data.stringsTable = dictChild["StringsTable"] ?? "";
    XmlElement preferenceSpecifiersE = dictChild["PreferenceSpecifiers"];
    log.i("-");
    bool grouping = false;
    Map<String, dynamic> configInfosT = {};
    for (int i = 0; i < preferenceSpecifiersE.children.length; i++) {
      XmlNode congigDict = preferenceSpecifiersE.children[i];
      Map<String, dynamic> cofigInfos = XMLDataTypeConvert.keysValsXmlNodeToMap(congigDict);
      // 清理無效 key 或 value
      if (cofigInfos.containsKey("")) {
        cofigInfos.remove("");
      }
      for (String key in cofigInfos.keys) {
        dynamic val = cofigInfos[key];
        if (key.isEmpty || key.trim().isEmpty || val == null) {
          cofigInfos.remove(key);
        }
        if (val is String) {
          if (val.isEmpty || val.trim().isEmpty) {
            cofigInfos.remove(key);
          }
        }
      }
      if (cofigInfos.isEmpty) continue;
      String? chkItem = chkConfigItem(cofigInfos);
      if (chkItem != null) {
        log.e("ERR DATA: $cofigInfos");
        throw Exception(chkItem);
      }
      if ((cofigInfos["Type"] ?? "") == "PSGroupSpecifier") {
        // log.d("遇到分組 PSGroupSpecifier 物件，額外處理");
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
        if ((cofigInfos["Type"] ?? "") == "PSMultiValueSpecifier") {
          // log.d("遇到多項選擇 PSMultiValueSpecifier 物件，額外處理");
          String newTitleValueKey = "TitleValues";
          // cofigInfos[newTitleValueKey] = XMLDataTypeConvert.doubleArrayXmlNodeToMap(cofigInfos["Titles"], cofigInfos["Values"], logTitle: newTitleValueKey);
          List<Map<String, dynamic>> nList = XMLDataTypeConvert.doubleArrayXmlNodeToListMap(cofigInfos["Titles"], cofigInfos["Values"], logTitle: newTitleValueKey);
          cofigInfos["TitleValues"] = nList;
          cofigInfos.remove("Titles");
          cofigInfos.remove("Values");
        }
      }
      String logstr = grouping ? "GROUP: ${data.title}/${configInfosT["Title"] ?? ""}" : "ROOT: ${data.title}";
      log.i("^ $logstr");
    }
    if (grouping) {
      // log.d("最終處於分組狀態中，結束分組");
      data.preferenceSpecifiers.add(configInfosT);
      configInfosT = {};
      grouping = false;
    }
    log.i("Load File OK: $plistFilePath , Title: ${data.title} , Table: ${data.stringsTable} , Specifiers length: ${data.preferenceSpecifiers.length}");
    // log.i(data.preferenceSpecifiers);
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
}

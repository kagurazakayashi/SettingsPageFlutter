library settingspageflutter;

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:settingspageflutter/global.dart';
import 'package:settingspageflutter/settingspagedata.dart';
import 'package:settingspageflutter/settingspagedebug.dart';
import 'package:settingspageflutter/utilities/xml_type_convert.dart';
import 'package:xml/xml.dart';

/// 配置檔案載入器
class SettingsPageLoader {
  SettingsPageFlutterDebug log = SettingsPageFlutterDebug(className: "Loader");
  String baseDir;

  /// 需要指定一個儲存 plist 檔案的基本路徑 [baseDir] 目錄。
  SettingsPageLoader({this.baseDir = "Settings.bundle/", isShowLog = false}) {
    if (!baseDir.endsWith("/")) {
      baseDir += "/";
    }
    Global.i.isShowLog = isShowLog;
  }

  /// 讀取 plist
  /// 可以提供以下三個選項之一（不可以提供多個）：
  /// 1. plist 檔案路徑 [plistFilePath] ，絕對路徑。
  /// 2. 直接提供 plist 內容 [importData] 。
  /// 3. plist 檔名 [plistFileName] （不是路徑），路徑基於 [baseDir] 屬性，不帶副檔名。
  Future<SettingsPageData> loadPlist({
    String plistFilePath = "",
    String importData = "",
    String i18n = "",
    String plistFileName = "Root",
  }) async {
    SettingsPageData data = SettingsPageData();
    String dataString = "";
    if (plistFilePath.isNotEmpty) {
      File f = File(plistFilePath);
      log.i("- Load Path: $plistFilePath");
      dataString = await f.readAsString();
    } else if (importData.isNotEmpty) {
      dataString = importData;
      if (Global.i.isShowLog) {
        log.i("- Load Data: length: ${dataString.length} :");
      }
    } else {
      String plistFilePath = baseDir;
      if (i18n.isNotEmpty) {
        if (i18n.toUpperCase() == "ZH-CN" ||
            i18n.toUpperCase() == "ZHCN" ||
            i18n.toUpperCase() == "ZH") {
          i18n = "zh_CN";
        }
        plistFilePath += "$i18n/";
      }
      plistFilePath += "$plistFileName.plist";
      dataString = await rootBundle.loadString(plistFilePath);
      if (Global.i.isShowLog) {
        log.i("- Load File: $plistFilePath , length: ${dataString.length} :");
      }
    }
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
    if (Global.i.isShowLog) {
      log.i("-");
    }
    bool grouping = false;
    Map<String, dynamic> configInfosT = {};
    for (int i = 0; i < preferenceSpecifiersE.children.length; i++) {
      XmlNode congigDict = preferenceSpecifiersE.children[i];
      Map<String, dynamic> cofigInfos =
          XMLDataTypeConvert.keysValsXmlNodeToMap(congigDict);
      // 清理無效 key 或 value
      if (cofigInfos.containsKey("")) {
        cofigInfos.remove("");
      }
      for (var i = cofigInfos.keys.length - 1; i >= 0; i--) {
        String key = cofigInfos.keys.elementAt(i);
        dynamic val = cofigInfos[key];
        if (key.isEmpty || key.trim().isEmpty || val == null) {
          cofigInfos.remove(key);
          continue;
        }
        if (val is String) {
          if (val.isEmpty || val.trim().isEmpty) {
            cofigInfos.remove(key);
            // cofigInfos[key] = "";
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
          List<Map<String, dynamic>> nList =
              XMLDataTypeConvert.doubleArrayXmlNodeToListMap(
            cofigInfos["Titles"],
            cofigInfos["Values"],
            logTitle: newTitleValueKey,
          );
          cofigInfos["TitleValues"] = nList;
          cofigInfos.remove("Titles");
          cofigInfos.remove("Values");
        }
      }

      List<String> keys = cofigInfos.keys.toList();
      for (var i = 0; i < keys.length; i++) {
        dynamic val = cofigInfos[keys[i]];
        if (val is XmlElement) {
          cofigInfos[keys[i]] = XMLDataTypeConvert.arrayXmlNodeToMap(val);
        }
      }

      String logstr = grouping
          ? "GROUP: ${data.title}/${configInfosT["Title"] ?? ""}"
          : "ROOT: ${data.title}";
      if (Global.i.isShowLog) {
        log.i("^ $logstr");
      }
    }
    if (grouping) {
      // log.d("最終處於分組狀態中，結束分組");
      data.preferenceSpecifiers.add(configInfosT);
      configInfosT = {};
      grouping = false;
    }
    uploadIsShow(data.preferenceSpecifiers);
    if (Global.i.isShowLog) {
      log.i(
          "Load File OK: $plistFilePath , Title: ${data.title} , Table: ${data.stringsTable} , Specifiers length: ${data.preferenceSpecifiers.length}");
    }
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

  /// 判断各个控件是否显示
  void uploadIsShow(List<Map<String, dynamic>> data) {
    Map<String, dynamic> temp = _listfor(data);
    _findKey(data, temp);
    _setShow(data, temp);
  }

  /// 查找所有需要修改显示的key
  Map<String, dynamic> _listfor(List data) {
    Map<String, dynamic> showKeysMap = {};
    for (Map<String, dynamic> setting in data) {
      List<String> keys = setting.keys.toList();
      for (var ks in keys) {
        switch (ks) {
          case "Childs":
            Map<String, dynamic> temp = _listfor(setting[ks]);
            showKeysMap.addAll(temp);
            break;
          case "Showkey":
            if (!setting.containsKey("ShowSetting")) {
              continue;
            }
            List showSettings = showKeysMap[setting[ks]] ?? [];
            Map<String, dynamic> showSetting = setting;
            showSetting["Show"] = false;
            if (setting.containsKey("Show") &&
                ((setting["Show"] is bool && setting["Show"]) ||
                    (setting["Show"] is String &&
                        (setting["Show"].toString().toUpperCase() == "TRUE" ||
                            setting["Show"] == "1")))) {
              showSetting["Show"] = true;
            }
            showSettings.add(showSetting);
            showKeysMap[setting[ks]] = showSettings;
            break;
          case "RegExpkey":
            if (!setting.containsKey("RegExpSetting")) {
              continue;
            }
            List showSettings = showKeysMap[setting[ks]] ?? [];
            Map<String, dynamic> showSetting = setting;
            showSetting["RegExp"] = 0;
            if (setting.containsKey("RegExp") &&
                (setting["RegExp"] is int || setting["RegExp"] is String)) {
              showSetting["RegExp"] = setting["RegExp"];
            }
            showSettings.add(showSetting);
            showKeysMap[setting[ks]] = showSettings;
            break;
          default:
        }
      }
    }
    return showKeysMap;
  }

  /// 显示字典根据`ShowSetting`的值进行显示判断
  void _findKey(List data, Map<String, dynamic> showKeysMap) {
    for (Map<String, dynamic> setting in data) {
      List<String> keys = setting.keys.toList();
      for (var ks in keys) {
        if (ks == "Childs") {
          _findKey(setting[ks], showKeysMap);
        } else {
          if (ks != "Key") {
            continue;
          }
          showKeysMap.forEach((key, value) {
            if (setting[ks] != key) {
              return;
            }
            Object val = "";
            if (setting.containsKey("Value")) {
              switch (setting["Value"].runtimeType.toString()) {
                case "String":
                  val = setting["Value"];
                  break;
                case "Map":
                case "_Map<String, dynamic>":
                  if (setting["Value"].containsKey("Val")) {
                    val = setting["Value"]["Val"];
                  }
                  break;
                default:
                  val = setting["Value"];
              }
            } else if (setting.containsKey("DefaultValue")) {
              val = setting["DefaultValue"];
              // Object? temp = setting["DefaultValue"];
              // if (temp != null) {
              //   switch (temp.runtimeType) {
              //     case String:
              //       val = setting["DefaultValue"];
              //       break;
              //     case List<String>:
              //       Map tempMap = {"Title": "", "Value": ""};
              //       for (int i = 0; i < (temp as List).length; i++) {
              //         String tempStr = temp[i];
              //         if (i + 1 < temp.length) {
              //           if (tempStr == "Value") {
              //             tempMap["Value"] = temp[i + 1];
              //           }
              //           if (tempStr == "Title") {
              //             tempMap["Title"] = temp[i + 1];
              //           }
              //         }
              //       }
              //       setting["DefaultValue"] = tempMap;
              //       break;
              //     default:
              //   }
              // }
            }
            if (val.toString().isEmpty) {
              return;
            }
            for (var v in value) {
              if (v is! Map) {
                continue;
              }
              if (v.containsKey("Show")) {
                bool isShow = false;
                switch (v["ShowSetting"].runtimeType.toString()) {
                  case "List<String>":
                    List showSettings = v["ShowSetting"];
                    for (var i = 0; i < showSettings.length; i++) {
                      Object temp = showSettings[i];
                      if (temp == val) {
                        isShow = true;
                      }
                    }
                    break;
                  case "bool":
                    if (val == v["ShowSetting"]) {
                      isShow = true;
                    }
                    break;
                  default:
                }
                v["Show"] = isShow;
              }
              if (v.containsKey("RegExp")) {
                int regExpItem = 0;
                List regExpSettings = v["RegExpSetting"];
                for (var i = 0; i < regExpSettings.length; i++) {
                  bool temp = regExpSettings[i];
                  if (temp == val) {
                    regExpItem = i;
                  }
                }
                v["RegExp"] = regExpItem;
              }
            }
          });
        }
      }
    }
  }

  /// 设置显示
  bool _setShow(List data, Map<String, dynamic> showKeysMap) {
    bool isUpload = false;
    for (Map<String, dynamic> setting in data) {
      List<String> keys = setting.keys.toList();
      for (var ks in keys) {
        if (ks == "Childs") {
          _setShow(setting[ks], showKeysMap);
        } else {
          if (ks != "Key") {
            continue;
          }
          String settingKey = setting[ks];
          showKeysMap.forEach((_, value) {
            for (var v in value) {
              if (!v.containsKey("Key")) {
                continue;
              }
              String key = v["Key"];
              if (settingKey != key) {
                return;
              }
              if (!v.containsKey("Show")) {
                continue;
              }
              bool isShow = v["Show"];
              setting["Show"] = isShow;
              isUpload = true;
            }
          });
        }
      }
    }
    return isUpload;
  }
}

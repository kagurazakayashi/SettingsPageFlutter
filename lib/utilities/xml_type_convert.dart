import 'package:settingspageflutter/global.dart';
import 'package:settingspageflutter/settingspagedebug.dart';
import 'package:xml/xml.dart';

class XMLDataTypeConvert {
  /// 獲取 [element] 對應的數據類型。
  static Type xmlElementType(XmlElement element) {
    String type = element.name.toString();
    switch (type) {
      case "string":
        return String;
      case "integer":
        return int;
      case "double":
        return double;
      case "true":
        return bool;
      case "false":
        return bool;
      case "array":
        return List;
      case "dict":
        return Map;
      default:
        return String;
    }
  }

  /// 將 [element] 轉換為對應的數據類型。
  static dynamic xmlElementTypeConvert(XmlElement element) {
    String type = element.name.toString();
    String text = element.text;
    switch (type) {
      case "string":
        return text;
      case "integer":
        return int.parse(text);
      case "double":
        return double.parse(text);
      case "true":
        return true;
      case "false":
        return false;
      case "array":
        {
          List<dynamic> list = [];
          for (XmlNode node in element.children) {
            if (node.nodeType != XmlNodeType.ELEMENT) continue;
            list.add(xmlElementTypeConvert(node as XmlElement));
          }
          return list;
        }
      case "dict":
        {
          Map<String, dynamic> map = {};
          for (XmlNode node in element.children) {
            if (node.nodeType != XmlNodeType.ELEMENT) continue;
            XmlElement e = node as XmlElement;
            String key = e.text;
            dynamic val = xmlElementTypeConvert(e);
            map[key] = val;
          }
          return map;
        }
      default:
        return text;
    }
  }

  /// 將類似於 `{xxxx:[string,string]}` 的 XML 格式轉換為 Map
  static List<Object> arrayXmlNodeToMap(XmlElement val, {logTitle = ""}) {
    SettingsPageFlutterDebug log =
        SettingsPageFlutterDebug(className: "XMLConvert");
    List<XmlNode> array = val.children;
    List<Object> list = [];
    for (XmlNode arr in array) {
      if (arr.nodeType != XmlNodeType.ELEMENT) {
        continue;
      }
      if (arr is XmlText) {
        list.add(arr.innerText);
      } else if (arr is XmlElement) {
        switch (arr.name.toString()) {
          case "true":
            list.add(true);
            break;
          case "false":
            list.add(false);
            break;
          case "integer":
            list.add(int.parse(arr.innerText));
            break;
          case "double":
            list.add(double.parse(arr.innerText));
            break;
          default:
            list.add(arr.innerText);
        }
      }
    }
    if (Global.i.isShowLog) {
      log.i("$logTitle = $list");
    }
    return list;
  }

  /// 將類似於 `{Titles:[string,string],Values:[string,string]}` 的 XML 格式轉換為 Map
  static Map<String, dynamic> doubleArrayXmlNodeToMap(
      XmlElement key, XmlElement val,
      {logTitle = ""}) {
    SettingsPageFlutterDebug log =
        SettingsPageFlutterDebug(className: "XMLConvert");
    Map<String, dynamic> map = {};
    List<XmlNode> keys = key.children; // XmlNodeList<XmlNode>
    List<XmlNode> vals = val.children; // XmlNodeList<XmlNode>
    if (keys.length != vals.length) {
      String e = "Invalid plist file: keys.length != vals.length";
      SettingsPageFlutterDebug(className: "XMLConvert").e(e);
      throw Exception(e);
    }
    for (int i = 0; i < keys.length; i++) {
      XmlNode nKey = keys[i];
      XmlNode nVal = vals[i];
      if (nKey.nodeType != XmlNodeType.ELEMENT ||
          nVal.nodeType != XmlNodeType.ELEMENT) {
        continue;
      }
      map[nKey.innerText] =
          XMLDataTypeConvert.xmlElementTypeConvert(nVal as XmlElement);
    }
    if (Global.i.isShowLog) {
      log.i("$logTitle = (${map.runtimeType}) $map");
    }
    return map;
  }

  static List<Map<String, dynamic>> doubleArrayXmlNodeToListMap(
    XmlElement key,
    XmlElement val, {
    String keyName = "Title",
    String valName = "Val",
    logTitle = "",
  }) {
    SettingsPageFlutterDebug log =
        SettingsPageFlutterDebug(className: "XMLConvert");
    List<Map<String, dynamic>> list = [];
    List<XmlNode> keys = key.children; // XmlNodeList<XmlNode>
    List<XmlNode> vals = val.children; // XmlNodeList<XmlNode>
    if (keys.length != vals.length) {
      String e = "Invalid plist file: keys.length != vals.length";
      SettingsPageFlutterDebug(className: "XMLConvert").e(e);
      throw Exception(e);
    }
    for (int i = 0; i < keys.length; i++) {
      XmlNode nKey = keys[i];
      XmlNode nVal = vals[i];
      if (nKey.nodeType != XmlNodeType.ELEMENT ||
          nVal.nodeType != XmlNodeType.ELEMENT) {
        continue;
      }
      list.add({
        keyName: nKey.text,
        valName: XMLDataTypeConvert.xmlElementTypeConvert(nVal as XmlElement)
      });
    }
    if (Global.i.isShowLog) {
      log.i("$logTitle = (${list.runtimeType}) $list");
    }
    return list;
  }

  /// 將類似於 `<key></key><string></string><key></key><integer></integer><key></key><true/>` 這樣的 [node] 轉換為 [Map] 。
  /// [node] 可以是 [XmlElement] 或 [XmlNode] 。
  /// 可以識別的資料型別有: [String] , [int] , [bool] , [XmlElement] , [XmlNode] 。
  static Map<String, dynamic> keysValsXmlNodeToMap(dynamic node) {
    SettingsPageFlutterDebug log =
        SettingsPageFlutterDebug(className: "XMLConvert");
    Map<String, dynamic> map = {};
    String key = "";
    var children = node.children;
    for (int i = 0; i < children.length; i++) {
      XmlNode child = children[i];
      if (child is XmlText) {
        map[key] = child.innerText;
      } else if (child is XmlElement) {
        String type = child.name.toString();
        if (type == "key") {
          key = child.innerText;
        } else if (key.isNotEmpty) {
          // map[key] = XMLDataTypeConvert.xmlElementTypeConvert(child);
          switch (type) {
            case "string":
              map[key] = child.innerText;
              break;
            case "integer":
              map[key] = int.parse(child.innerText);
              break;
            case "double":
              map[key] = double.parse(child.innerText);
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
            if (Global.i.isShowLog) {
              log.i("$key = ($type) (length: ${map[key].children.length})");
            }
          } else {
            if (Global.i.isShowLog) {
              log.i("$key = ($type) ${map[key]}");
            }
          }
          key = "";
        }
      }
    }
    return map;
  }

  /// 將兩個 [keys] 和 [vals] 轉換成 Map。
  static Map<String, String> stringDoubleList2Map(
      List<String> keys, List<String> vals) {
    Map<String, String> map = {};
    for (int i = 0; i < keys.length; i++) {
      map[keys[i]] = vals[i];
    }
    return map;
  }

  /// 將 XmlElementArray [element] 轉換為 [List]。
  static xmlArray2List(XmlElement element) {
    List<dynamic> list = [];
    for (XmlNode node in element.children) {
      if (node.nodeType != XmlNodeType.ELEMENT) continue;
      list.add(xmlElementTypeConvert(node as XmlElement));
    }
    return list;
  }

  static selectListXmlNode(XmlElement element) {
    List<Map<String, dynamic>> list = [];
    for (XmlNode node in element.children) {
      if (node.nodeType != XmlNodeType.ELEMENT) continue;
      Map map = keysValsXmlNodeToMap(node);
      List selectVals = xmlArray2List(map["SelectValue"] as XmlElement);
      List select = doubleArrayXmlNodeToListMap(map["Titles"],map["Values"]);
      Map<String, dynamic> selectMap = {
        "SelectValue":selectVals,
        "TitleValues":select,
      };
      list.add(selectMap);
    }
    return list;
  }
}

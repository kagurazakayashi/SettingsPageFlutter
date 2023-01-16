import 'package:settingspageflutter/settingspagedebug.dart';
import 'package:xml/xml.dart';

class XMLDataTypeConvert {
  /// 將類似於 `{Titles:[string,string],Values:[string,string]}` 的 XML 格式轉換為 Map
  static Map<String, dynamic> doubleArrayXmlNodeToMap(XmlElement key, XmlElement val, {logTitle = ""}) {
    SettingsPageFlutterDebug log = SettingsPageFlutterDebug(className: "XMLConvert");
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
      if (nKey.nodeType != XmlNodeType.ELEMENT || nVal.nodeType != XmlNodeType.ELEMENT) {
        continue;
      }
      switch (nVal.name.toString()) {
        case "string":
          map[nKey.text] = nVal.text;
          break;
        case "integer":
          map[nKey.text] = int.parse(nVal.text);
          break;
        case "true":
          map[nKey.text] = true;
          break;
        case "false":
          map[nKey.text] = false;
          break;
        default:
          map[nKey.text] = nVal;
          break;
      }
    }
    log.i("$logTitle = (Map) $map");
    return map;
  }

  /// 將類似於 `<key></key><string></string><key></key><integer></integer><key></key><true/>` 這樣的 [node] 轉換為 [Map] 。
  /// [node] 可以是 [XmlElement] 或 [XmlNode] 。
  /// 可以識別的資料型別有: [String] , [int] , [bool] , [XmlElement] , [XmlNode] 。
  static Map<String, dynamic> keysValsXmlNodeToMap(dynamic node) {
    SettingsPageFlutterDebug log = SettingsPageFlutterDebug(className: "XMLConvert");
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
          // map[key] = XMLDataTypeConvert.xmlElementTypeConvert(child);
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

  /// 將兩個 [keys] 和 [vals] 轉換成 Map。
  static Map<String, String> stringDoubleList2Map(List<String> keys, List<String> vals) {
    Map<String, String> map = {};
    for (int i = 0; i < keys.length; i++) {
      map[keys[i]] = vals[i];
    }
    return map;
  }
}

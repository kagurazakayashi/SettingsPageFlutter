
import 'dart:convert';

/// 处理Value
String handleValue(Object? value) {
  String val = "";
  switch (value.runtimeType) {
    case String:
      val = value as String;
      try {
        Map tempMap = jsonDecode(val);
        val = tempMap.containsKey("Title") ? tempMap["Title"] : "";
      } catch (e) {
        val = value;
      }
      break;
    case Map<String, dynamic>:
    case Map<dynamic, dynamic>:
      val = (value as Map).containsKey("Title") ? value["Title"] : "";
      break;
    default:
      if (value.runtimeType.toString() == "_Map<String, dynamic>" ||
          value.runtimeType.toString() == "_Map<dynamic, dynamic>") {
        val = (value as Map).containsKey("Title") ? value["Title"] : "";
      }
  }
  return val;
}

import 'dart:convert';

/// 处理Value
String handleValueRODefaultValue(Map<String, dynamic> data, String value) {
  String val = "";
  dynamic type = data.containsKey("Type") ? data["Type"] : "";
  if (type == "PSMultiValueSpecifier") {
    val = handleMultiValue(data, value);
  } else {
    val = handleValue(value);
  }
  return val;
}

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

/// 处理PSMultiValueSpecifier Value
String handleMultiValue(Map<String, dynamic> data, String value) {
  String val = "";
  List titleValues = data.containsKey("TitleValues") ? data["TitleValues"] : [];
  for (var tv in titleValues) {
    String tvValue = tv.containsKey("Val") ? tv["Val"] : "";
    if (tvValue == value) {
      val = tv.containsKey("Title") ? tv["Title"] : "";
      break;
    }
  }
  return val;
}

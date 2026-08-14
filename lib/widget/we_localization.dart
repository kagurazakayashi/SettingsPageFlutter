import 'dart:ui' show PlatformDispatcher;

import "package:flutter/material.dart";

/// 多语言文案字典。
///
/// 使用 [weTr] 根据当前 locale 获取对应语言的文案，
/// 未匹配到语言时回退到默认语言 [weDefaultLocale]。
///
/// 宿主应用可以直接向 [weStrings] 添加或覆盖语言，
/// 也可以通过 [weLocale]/[setWeLocale] 指定当前语言。
Map<String, Map<String, String>> weStrings = {
  // 简体中文
  "zh_CN": {
    "selectAll": "全选",
    "unselectAll": "取消全选",
    "cancel": "取消",
    "confirm": "确定",
    "noData": "没有数据",
    "noResultsFound": "没有找到结果",
  },
  // 繁体中文
  "zh_TW": {
    "selectAll": "全選",
    "unselectAll": "取消全選",
    "cancel": "取消",
    "confirm": "確定",
    "noData": "沒有資料",
    "noResultsFound": "沒有找到結果",
  },
  // 英语
  "en": {
    "selectAll": "Select All",
    "unselectAll": "Unselect All",
    "cancel": "Cancel",
    "confirm": "OK",
    "noData": "No Data",
    "noResultsFound": "No results found!",
  },
  // 西班牙语
  "es": {
    "selectAll": "Seleccionar todo",
    "unselectAll": "Deseleccionar todo",
    "cancel": "Cancelar",
    "confirm": "Aceptar",
    "noData": "Sin datos",
    "noResultsFound": "Sin resultados",
  },
};

/// 默认语言，未匹配到语言时回退使用。
String weDefaultLocale = "zh_CN";

/// 当前语言代码（对外接口）。
///
/// - 为 `null`（默认）时，自动跟随系统语言；
/// - 传入语言代码时使用对应语言，支持 `"zh_CN"`、`"zh_TW"`、`"en"`、`"es"` 等
///   （与 [weStrings] 的 key 对应，也兼容 `"zh-CN"` 这类带横线的写法）。
///
/// 未匹配到对应语言时回退到 [weDefaultLocale]。
String? weLocale;

/// 设置当前语言（对外接口）。
///
/// [locale] 为 `null` 时恢复自动跟随系统语言。
void setWeLocale(String? locale) {
  weLocale = locale;
}

/// 根据语言代码 [localeCode] 获取文案 [key]（不依赖 [context]，便于测试）。
///
/// [localeCode] 支持 `"zh_CN"`、`"zh_TW"`、`"en"`、`"es"` 等，
/// 也兼容带横线的写法（如 `"zh-CN"`）。
String weTrByLocale(String localeCode, String key) {
  Map<String, String>? table = _matchLocale(localeCode);
  return table?[key] ?? key;
}

/// 根据当前语言获取文案 [key]。
///
/// 语言选择顺序：
/// 1. [weLocale]（手动指定，非 null 时优先）；
/// 2. 系统语言（[PlatformDispatcher] 或 [context] 的 Localizations）；
/// 3. 默认语言 [weDefaultLocale]。
///
/// 匹配时依次尝试 `语言_地区`（如 `zh_CN`）、语言码（如 `en`），
/// 仍未找到对应 [key] 时直接返回 [key] 本身。
String weTr(BuildContext context, String key) {
  if (weLocale != null && weLocale!.isNotEmpty) {
    return weTrByLocale(weLocale!, key);
  }
  return weTrByLocale(_detectSystemLocale(context), key);
}

/// 根据语言代码 [localeCode] 匹配文案表。
Map<String, String>? _matchLocale(String localeCode) {
  List<String> parts = localeCode.replaceAll("-", "_").split("_");
  if (parts.isEmpty || parts[0].isEmpty) {
    return weStrings[weDefaultLocale];
  }
  String lang = parts[0];
  String script = "";
  String country = "";
  if (parts.length >= 2) {
    String second = parts[1];
    if (second.length == 4) {
      // 第二段为脚本代码（如 Hans、Hant）
      script = second;
      if (parts.length >= 3) {
        country = parts[2];
      }
    } else {
      // 第二段为地区代码（如 CN、TW、US）
      country = second;
    }
  }
  if (country.isEmpty && script.isNotEmpty) {
    // 仅含脚本无地区时，按脚本映射地区（Hans→CN，Hant→TW）
    if (script == "Hans") {
      country = "CN";
    } else if (script == "Hant") {
      country = "TW";
    }
  }
  String langCountry = country.isNotEmpty ? "${lang}_$country" : lang;
  return weStrings[langCountry] ?? weStrings[lang] ?? weStrings[weDefaultLocale];
}

/// 检测系统语言代码。
String _detectSystemLocale(BuildContext context) {
  try {
    return PlatformDispatcher.instance.locale.toString();
  } catch (_) {
    try {
      return Localizations.localeOf(context).toString();
    } catch (_) {
      return weDefaultLocale;
    }
  }
}

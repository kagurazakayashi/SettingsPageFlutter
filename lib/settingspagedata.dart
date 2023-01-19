library settingspageflutter;

class SettingsPageData {
  /// {@template settingspageflutter.SettingsPageData.title}
  /// 設定頁面标题
  /// {@endtemplate}
  String title = "";
  /// {@template settingspageflutter.SettingsPageData.stringsTable}
  /// 設定頁面的Key值
  /// {@endtemplate}
  String stringsTable = "";
  /// {@template settingspageflutter.SettingsPageData.preferenceSpecifiers}
  /// 从 plist 文件中读取的配置信息
  /// {@endtemplate}
  List<Map<String,dynamic>> preferenceSpecifiers = [];
}

import "package:flutter_test/flutter_test.dart";
import "package:settingspageflutter/widget/we_localization.dart";

void main() {
  group("weTrByLocale", () {
    test("简体中文", () {
      expect(weTrByLocale("zh_CN", "selectAll"), "全选");
      expect(weTrByLocale("zh_CN", "confirm"), "确定");
    });

    test("繁体中文", () {
      expect(weTrByLocale("zh_TW", "selectAll"), "全選");
      expect(weTrByLocale("zh_TW", "confirm"), "確定");
    });

    test("英语", () {
      expect(weTrByLocale("en", "selectAll"), "Select All");
      expect(weTrByLocale("en", "cancel"), "Cancel");
    });

    test("西班牙语", () {
      expect(weTrByLocale("es", "selectAll"), "Seleccionar todo");
      expect(weTrByLocale("es", "confirm"), "Aceptar");
    });

    test("兼容带横线的语言代码", () {
      expect(weTrByLocale("zh-CN", "selectAll"), "全选");
    });

    test("带地区的语言码回退到语言码", () {
      expect(weTrByLocale("en_US", "cancel"), "Cancel");
    });

    test("繁体脚本映射到繁体中文", () {
      expect(weTrByLocale("zh_Hant", "confirm"), "確定");
      expect(weTrByLocale("zh_Hans", "confirm"), "确定");
    });

    test("未匹配语言回退到默认语言", () {
      expect(weTrByLocale("fr", "confirm"), "确定");
    });

    test("未知 key 返回 key 本身", () {
      expect(weTrByLocale("en", "unknownKey"), "unknownKey");
    });
  });
}

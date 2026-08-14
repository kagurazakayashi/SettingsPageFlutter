import "package:flutter_test/flutter_test.dart";
import "package:settingspageflutter/widget/material/wewidget/we_multi_select.dart";

void main() {
  final List<Map<String, dynamic>> options = [
    {"Title": "A", "Val": 1},
    {"Title": "B", "Val": 2},
    {"Title": "C", "Val": 4},
    {"Title": "D", "Val": 8},
    {"Title": "E", "Val": 16},
    {"Title": "F", "Val": 32},
    {"Title": "G", "Val": 64},
    {"Title": "H", "Val": 128},
    {"Title": "I", "Val": 256},
    {"Title": "J", "Val": 512},
  ];

  group("multiSelectToInt", () {
    test("int 类型直接返回", () {
      expect(multiSelectToInt(20), 20);
    });

    test("double 类型转为 int", () {
      expect(multiSelectToInt(20.0), 20);
    });

    test("String 类型解析为 int", () {
      expect(multiSelectToInt("604"), 604);
    });

    test("无法解析时返回 0", () {
      expect(multiSelectToInt("abc"), 0);
    });
  });

  group("multiSelectSelectedTitles", () {
    test("值为 20 代表选中 C、E", () {
      expect(multiSelectSelectedTitles(20, options), ["C", "E"]);
    });

    test("值为 604 代表选中 C、D、E、G、J", () {
      expect(multiSelectSelectedTitles(604, options), ["C", "D", "E", "G", "J"]);
    });

    test("值为 0 代表无选中", () {
      expect(multiSelectSelectedTitles(0, options), []);
    });

    test("字符串值也能正确解析", () {
      expect(multiSelectSelectedTitles("20", options), ["C", "E"]);
    });
  });

  group("multiSelectToggle", () {
    test("勾选后位被置 1", () {
      expect(multiSelectToggle(0, 4, true), 4);
    });

    test("取消后位被清零", () {
      expect(multiSelectToggle(20, 4, false), 16);
    });

    test("重复勾选不影响结果", () {
      expect(multiSelectToggle(20, 4, true), 20);
    });
  });

  group("multiSelectAllValue", () {
    test("计算所有位值的按位或", () {
      expect(multiSelectAllValue(options), 1023);
    });
  });

  group("multiSelectSelectedBits（正向/反向）", () {
    test("正向：值为 20 选中 C、E", () {
      expect(multiSelectSelectedBits(20, options, false), 20);
    });

    test("反向：全选值为 0", () {
      // 选项 1-A 2-B 4-C，反向全选 = 0
      expect(multiSelectSelectedBits(0, options, true), 1023);
    });

    test("反向：值为 6 表示选中 A（未选 B、C）", () {
      // 选项 1-A 2-B 4-C，反向值 6 = 2+4 = 未选 B、C，即选中 A
      final abc = [
        {"Title": "A", "Val": 1},
        {"Title": "B", "Val": 2},
        {"Title": "C", "Val": 4},
      ];
      expect(multiSelectSelectedBits(6, abc, true), 1);
    });
  });

  group("multiSelectIsChecked（正向/反向）", () {
    test("正向：位为 1 表示选中", () {
      expect(multiSelectIsChecked(4, 4, false), true);
      expect(multiSelectIsChecked(4, 2, false), false);
    });

    test("反向：位为 0 表示选中", () {
      expect(multiSelectIsChecked(6, 1, true), true);
      expect(multiSelectIsChecked(6, 2, true), false);
    });
  });
}

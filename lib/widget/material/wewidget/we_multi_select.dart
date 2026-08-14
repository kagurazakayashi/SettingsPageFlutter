import "package:flutter/material.dart";

import "../../we_localization.dart";
import "../../we_textstyle.dart";

/// 将动态类型转换为整数（位掩码值）。
///
/// 支持 [int]、[double]、[String] 三种类型，无法解析时返回 0。
int multiSelectToInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

/// 根据位掩码 [value] 计算选中的选项标题列表。
///
/// [options] 为选项列表，每项包含 `Title` 与 `Val` 两个键，
/// 其中 `Val` 为对应的 2 的幂次位值。
List<String> multiSelectSelectedTitles(
  dynamic value,
  List<Map<String, dynamic>> options,
) {
  int current = multiSelectToInt(value);
  List<String> selected = [];
  for (final option in options) {
    int bit = multiSelectToInt(option["Val"]);
    if (bit != 0 && (current & bit) != 0) {
      selected.add(option["Title"]?.toString() ?? "");
    }
  }
  return selected;
}

/// 切换某个位 [bit] 的选择状态 [checked]，返回新的位掩码。
int multiSelectToggle(int value, int bit, bool checked) {
  if (checked) {
    return value | bit;
  }
  return value & ~bit;
}

/// 计算所有选项位值的按位或结果（即全选值）。
int multiSelectAllValue(List<Map<String, dynamic>> options) {
  int all = 0;
  for (final option in options) {
    all |= multiSelectToInt(option["Val"]);
  }
  return all;
}

/// 根据当前值 [value] 计算实际选中的位值。
///
/// 当 [invert] 为 true（反向）时，值为「未选中位」的按位或，
/// 等价于用全选值对 [value] 取反。
int multiSelectSelectedBits(
  dynamic value,
  List<Map<String, dynamic>> options,
  bool invert,
) {
  int v = multiSelectToInt(value);
  if (invert) {
    return multiSelectAllValue(options) ^ v;
  }
  return v;
}

/// 判断某个位 [bit] 是否处于选中状态。
///
/// 正向：该位为 1 表示选中；反向（[invert] 为 true）：该位为 0 表示选中。
bool multiSelectIsChecked(int value, int bit, bool invert) {
  if (invert) {
    return (value & bit) == 0;
  }
  return (value & bit) != 0;
}

/// 数字多选（位掩码多选）控件。
///
/// 每个选项对应一个 2 的幂次位（如 1、2、4、8、16 ...），
/// 选中的值通过按位或（相加）组合成一个整数。
///
/// 例如：选项 `1-A;2-B;4-C;8-D;16-E`
///   - 值为 `20` 表示选中了 `C`（4）与 `E`（16）；
///   - 值为 `604` 表示选中了 `C`（4）、`D`（8）、`E`（16）、`G`（64）、`J`（512）。
class WeMultiSelect extends StatefulWidget {
  const WeMultiSelect({
    Key? key,
    required this.id,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
    this.readOnly = false,
    this.isDev = false,
    this.isDark = false,
    this.invert = false,
    this.titleStyle,
    this.summaryStyle,
  }) : super(key: key);

  /// 数据的键（用于修改对应项）
  final String id;

  /// 控件标题
  final String title;

  /// 当前位掩码值（可读可写）
  final dynamic value;

  /// 选项列表，每项包含 `Title`（标题）与 `Val`（位值）
  final List<Map<String, dynamic>> options;

  /// 值改变回调
  final Function(String key, dynamic value, bool isTip) onChanged;

  /// 是否为只读
  final bool readOnly;

  /// 是否为开发模式
  final bool isDev;

  /// 是否为深色模式
  final bool isDark;

  /// 是否取反（反向）：为 true 时，值为「未选中位」的按位或
  final bool invert;

  /// 标题文字样式，为 null 时使用默认样式（[tsMaincalculate]）
  final TextStyle? titleStyle;

  /// 已选项摘要文字样式，为 null 时使用默认样式（[tsMainVal]）
  final TextStyle? summaryStyle;

  @override
  State<WeMultiSelect> createState() => _WeMultiSelectState();
}

class _WeMultiSelectState extends State<WeMultiSelect> {
  /// 打开多选弹窗，返回后根据结果更新值
  Future<void> _openDialog() async {
    int current = multiSelectToInt(widget.value);
    int? result = await showDialog<int>(
      context: context,
      builder: (context) => WeMultiSelectDialog(
        title: widget.title,
        value: current,
        options: widget.options,
        isDark: widget.isDark,
        invert: widget.invert,
      ),
    );
    if (result != null && result != current) {
      widget.onChanged(widget.id, result, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 反向模式下，实际选中位为「全选值取反」
    int selectedBits =
        multiSelectSelectedBits(widget.value, widget.options, widget.invert);
    List<String> selected = multiSelectSelectedTitles(selectedBits, widget.options);

    return Semantics(
      container: true,
      child: InkWell(
        onTap: widget.readOnly ? null : _openDialog,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题（含开发模式 key）
                    if (widget.title.isNotEmpty)
                      Text(
                        widget.title,
                        style: widget.titleStyle ?? tsMaincalculate,
                        maxLines: 99,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (widget.isDev && widget.id.isNotEmpty)
                      Text(
                        widget.id,
                        style: tsGroupTag,
                      ),
                    // 已选项：在标题下方，用分割线隔离，长内容可换行显示。
                    // 使用 Wrap 让每个选项标题独立换行，避免长单词被裁剪。
                    if (selected.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: widget.isDark ? Colors.white24 : Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 2,
                        children: selected
                            .map(
                              (s) => Text(
                                s,
                                style: widget.summaryStyle ?? tsMainVal,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              // 箭头：位于整个选项右侧，垂直居中
              if (!widget.readOnly) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  weight: 1000,
                  color: Colors.grey[500]!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 数字多选的弹窗，用于勾选多个选项。
class WeMultiSelectDialog extends StatefulWidget {
  const WeMultiSelectDialog({
    Key? key,
    required this.title,
    required this.value,
    required this.options,
    this.isDark = false,
    this.invert = false,
  }) : super(key: key);

  /// 弹窗标题
  final String title;

  /// 初始位掩码值
  final int value;

  /// 选项列表
  final List<Map<String, dynamic>> options;

  /// 是否为深色模式
  final bool isDark;

  /// 是否取反（反向）
  final bool invert;

  @override
  State<WeMultiSelectDialog> createState() => _WeMultiSelectDialogState();
}

class _WeMultiSelectDialogState extends State<WeMultiSelectDialog> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  /// 计算所有选项位值的按位或结果（即全选值）。
  int _allValue() {
    return multiSelectAllValue(widget.options);
  }

  /// 判断当前是否处于「全选」状态。
  bool _isAllSelected() {
    int all = _allValue();
    return widget.invert ? _value == 0 : _value == all;
  }

  /// 切换全选/取消全选。
  void _selectAll() {
    int all = _allValue();
    setState(() {
      if (widget.invert) {
        // 反向：全选值为 0，取消全选值为 all
        _value = _isAllSelected() ? all : 0;
      } else {
        // 正向：全选值为 all，取消全选值为 0
        _value = _isAllSelected() ? 0 : all;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 深色模式下使用深色背景与浅色文字，避免与主题色冲突导致不可见
    Color textColor = widget.isDark ? Colors.white : Colors.black87;
    Color? backgroundColor = widget.isDark ? const Color(0xFF303030) : null;
    // 全选/取消为次要操作，确定为主要操作，颜色加以区分
    Color secondaryColor = widget.isDark ? Colors.white70 : Colors.grey[600]!;
    Color confirmColor = Theme.of(context).colorScheme.primary;
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text(
        widget.title,
        style: TextStyle(color: textColor),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 全选复选框：独立一行，更直观
            CheckboxListTile(
              title: Text(
                weTr(
                  context,
                  _isAllSelected() ? "unselectAll" : "selectAll",
                ),
                style: TextStyle(color: textColor),
              ),
              value: _isAllSelected(),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeColor: confirmColor,
              checkColor: widget.isDark ? Colors.black : Colors.white,
              side: widget.isDark
                  ? const BorderSide(color: Colors.white54)
                  : null,
              onChanged: (_) => _selectAll(),
            ),
            // 选项列表
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView(
                shrinkWrap: true,
                children: widget.options.map((option) {
                  String title = option["Title"]?.toString() ?? "";
                  int bit = multiSelectToInt(option["Val"]);
                  bool checked =
                      bit != 0 && multiSelectIsChecked(_value, bit, widget.invert);
                  return CheckboxListTile(
                    title: Text(
                      title,
                      style: TextStyle(color: textColor),
                    ),
                    value: checked,
                    activeColor: confirmColor,
                    checkColor: widget.isDark ? Colors.black : Colors.white,
                    side: widget.isDark
                        ? const BorderSide(color: Colors.white54)
                        : null,
                    onChanged: bit == 0
                        ? null
                        : (bool? val) {
                            setState(() {
                              bool wantChecked = val == true;
                              // 反向模式下勾选=清除该位，取消=设置该位
                              _value = widget.invert
                                  ? multiSelectToggle(_value, bit, !wantChecked)
                                  : multiSelectToggle(_value, bit, wantChecked);
                            });
                          },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // 取消：次要颜色
        TextButton(
          style: TextButton.styleFrom(foregroundColor: secondaryColor),
          onPressed: () => Navigator.pop(context),
          child: Text(weTr(context, "cancel")),
        ),
        // 确定：主题色（主要操作）
        TextButton(
          style: TextButton.styleFrom(foregroundColor: confirmColor),
          onPressed: () => Navigator.pop(context, _value),
          child: Text(weTr(context, "confirm")),
        ),
      ],
    );
  }
}

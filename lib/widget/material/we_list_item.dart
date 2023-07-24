import "package:flutter/material.dart";

import "../we_size.dart";
import "we_get_widget.dart";

class WeListItem extends StatelessWidget {
  /// 提供交互的控件
  ///
  /// Provides an interactive control
  const WeListItem({
    Key? key,
    this.isDev = false,
    this.isDark = false,
    this.decoration,
    this.visibilitySemantics,
    this.clearSemantics,
    required this.data,
    this.onClick,
    required this.onChanged,
    this.openFile,
  }) : super(key: key);

  /// {@template settingspageflutter.widget.wegroupitem.isDev}
  /// 是否为开发模式
  ///
  /// 默认为false
  ///
  /// Is it development mode
  ///
  /// Default is false
  /// {@endtemplate}
  final bool isDev;

  /// {@template settingspageflutter.widget.welistitem.isDark}
  /// 是否为暗黑模式
  ///
  /// 默认为false
  ///
  /// Is it dark mode
  ///
  /// Default is false
  /// {@endtemplate}
  final bool isDark;

  /// {@template settingspageflutter.widget.welistitem.decoration}
  /// 条目样式
  ///
  /// Item style
  /// {@endtemplate}
  final BoxDecoration? decoration;

  /// {@template settingspageflutter.widget.welistitem.visibilitySemantics}
  /// 显示密码语义
  ///
  /// Show password semantics
  /// {@endtemplate}
  final String? visibilitySemantics;

  /// {@template settingspageflutter.widget.welistitem.clearSemantics}
  /// 清除语义
  ///
  /// Clear semantics
  /// {@endtemplate}
  final String? clearSemantics;

  /// {@template settingspageflutter.widget.welistitem.data}
  /// 数据
  ///
  /// Data
  /// {@endtemplate}
  final Map<String, dynamic> data;

  /// {@template settingspageflutter.widget.welistitem.onClick}
  /// 点击事件
  ///
  /// 数据中的key`Childs`或`File`不为空时，点击事件才会触发
  ///
  /// * [childs] 为数据中的key`Childs`的值,用于返回子级数据
  ///
  /// * [file] 为数据中的key`File`的值,用于返回下一页 plist 的文件名
  ///
  /// * [type] 为数据中的key`Type`的值,用于返回当前项的类型
  ///
  /// Click event
  ///
  /// The click event will be triggered when the key `Childs` or `File` in the data is not empty
  ///
  /// * [childs] is the value of the key `Childs` in the data, used to return sub-level data
  ///
  /// * [file] is the value of the key `File` in the data, used to return the file name of the next page plist
  ///
  /// * [type] is the value of the key `Type` in the data, used to return the type of the current item
  /// {@endtemplate}
  ///
  /// {@tool snippet}
  /// ```
  /// onClick: (childs, file, type) {
  ///   if (type == "PSMultiValueSpecifier") {
  ///     BotToast.showText(
  ///       text: "Multi Value",
  ///     );
  ///   }
  ///   Navigator.push(
  ///     context,
  ///     MaterialPageRoute(
  ///       builder: (context) => SelectPage(
  ///         file: file != null && file.isNotEmpty ? file : "root",
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final Function(List<Map<String, dynamic>>? childs, String? file, String type)?
      onClick;

  /// {@template settingspageflutter.widget.welistitem.onChanged}
  /// 值改变事件
  ///
  /// 用于返回根据Key修改值
  ///
  /// * [key] 为数据中的key`Key`的值,用于需要修改项的key
  ///
  /// * [value] 为数据中的key`Value`的值,用于需要修改项的value
  ///
  /// * [isTip] 用于判断是否需要提示，当前只有`PSTextFieldSpecifier`类型的项才会有提示
  ///
  /// Value change event
  ///
  /// Used to return the value modified according to Key
  ///
  /// * [key] is the value of the key `Key` in the data, used to modify the key of the item that needs to be modified
  ///
  /// * [value] is the value of the key `Value` in the data, used to modify the value of the item that needs to be modified
  ///
  /// * [isTip] used to determine whether to prompt, only the `PSTextFieldSpecifier` type item will have a prompt
  /// {@endtemplate}
  ///
  /// {@tool snippet}
  /// ```
  /// onChanged: (key, value, isTip) {
  ///   bool isUpLoad = weSetVal(_settingData, key, value);
  ///   if (isUpLoad) {
  ///     NotificationCenter.instance
  ///         .postNotification(nkey, [key, value]);
  ///     if (isTip) {
  ///       BotToast.showText(
  ///         text: 'K: $key - V: $value\n已修改',
  ///       );
  ///     }
  ///   }
  /// }
  /// ```
  /// {@end-tool}
  final Function(String key, dynamic value, bool isTip) onChanged;

  /// {@template settingspageflutter.widget.welistitem.openFile}
  /// 打开文件事件
  ///
  /// * [key] 为数据中的key`Key`的值,用于需要修改项的key
  ///
  /// Open file event
  ///
  /// * [key] is the value of the key `Key` in the data, used to modify the key of the item that needs to be modified
  /// {@endtemplate}
  final Function(String key)? openFile;

  @override
  Widget build(BuildContext context) {
    String type = data.containsKey("Type") ? data["Type"] : "";
    List<Map<String, dynamic>>? childs =
        data.containsKey("Childs") ? data["Childs"] : null;
    String? file = data.containsKey("File") ? data["File"] : null;
    bool isShow = data.containsKey("Show") ? data["Show"] : true;
    String? val = data.containsKey("Val") ? data["Val"] : null;

    Widget c = getWidget(
      data,
      onChanged,
      openFile: openFile,
      visibilitySemantics: visibilitySemantics,
      clearSemantics: clearSemantics,
      isDev: isDev,
    );
    Function()? onTap;

    if (childs != null || file != null) {
      onTap = () {
        bool isNext = false;
        if (type == "PSChildPaneSpecifier") {
          isNext = true;
        }
        if (file != null && file.isNotEmpty) {
          isNext = true;
        }
        if (isNext) {
          onClick!(childs, file, type);
        }
      };
    }
    if (type == "PSMultiValueSpecifier") {
      onTap = () {
        onClick!([data], null, type);
      };
      c = Semantics(
        selected: true,
        child: c,
      );
    }
    if (val != null) {
      onTap = () {
        onClick!([data], null, type);
      };
    }

    if (isShow) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 3,
            bottom: 3,
          ),
          margin: const EdgeInsets.all(1),
          width: weSize.width - 86,
          child: c,
        ),
      );
    } else {
      return Container();
    }
  }
}

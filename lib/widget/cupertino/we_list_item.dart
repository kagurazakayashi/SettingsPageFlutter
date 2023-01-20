import "package:flutter/cupertino.dart";

import "../we_size.dart";
import "we_get_widget.dart";

class WeCupertinoListItem extends StatelessWidget {
  /// 提供交互的控件
  ///
  /// Provides an interactive control
  const WeCupertinoListItem({
    Key? key,
    this.isDark = false,
    this.decoration,
    required this.data,
    this.onClick,
    required this.onChanged,
  }) : super(key: key);

  /// {@template settingspageflutter.widget.wecupertinolistitem.isDark}
  /// 是否为暗黑模式
  /// 
  /// 默认为false
  /// 
  /// Is it dark mode
  /// 
  /// Default is false
  /// {@endtemplate}
  final bool isDark;

  /// {@template settingspageflutter.widget.wecupertinolistitem.decoration}
  /// 条目样式
  /// 
  /// Item style
  /// {@endtemplate}
  final BoxDecoration? decoration;

  /// {@template settingspageflutter.widget.wecupertinolistitem.data}
  /// 数据
  ///
  /// Data
  /// {@endtemplate}
  final Map<String, dynamic> data;

  /// {@template settingspageflutter.widget.wecupertinolistitem.onClick}
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

  /// {@template settingspageflutter.widget.wecupertinolistitem.onChanged}
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

  @override
  Widget build(BuildContext context) {
    String type = data.containsKey("Type") ? data["Type"] : "";
    List<Map<String, dynamic>>? childs =
        data.containsKey("Childs") ? data["Childs"] : null;
    String? file = data.containsKey("File") ? data["File"] : null;

    Widget c = getWidget(data, onChanged);
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
    }

    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
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
      ),
    );
  }
}

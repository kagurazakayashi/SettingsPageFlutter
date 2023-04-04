import 'package:flutter/cupertino.dart';

import 'we_column.dart';
import 'we_group.dart';
import 'we_item.dart';
import 'we_list_item.dart';

class WeCupertinoGroupItem extends StatelessWidget {
  /// 把 plist 文件中的数据的转换为UI的入口组件
  ///
  /// The entry component that converts the data in the plist file into a UI
  const WeCupertinoGroupItem({
    Key? key,
    this.isDark = false,
    this.decoration,
    required this.data,
    this.onClick,
    required this.onChanged,
  }) : super(key: key);

  /// {@template settingspageflutter.widget.wecupertinogroupitem.isDark}
  /// 是否为暗黑模式
  ///
  /// 默认为false
  ///
  /// Is it dark mode
  ///
  /// Default is false
  /// {@endtemplate}
  final bool isDark;

  /// {@template settingspageflutter.widget.wecupertinogroupitem.decoration}
  /// 条目样式
  ///
  /// Item style
  /// {@endtemplate}
  final BoxDecoration? decoration;

  /// {@template settingspageflutter.widget.wecupertinogroupitem.data}
  /// plist 文件中的数据
  ///
  /// The data in the plist file
  /// {@endtemplate}
  final Map<String, dynamic> data;

  /// {@template settingspageflutter.widget.wecupertinogroupitem.onClick}
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

  /// {@template settingspageflutter.widget.wecupertinogroupitem.onChanged}
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
    // 从数据中获取需要的值
    String? titleStr = data.containsKey("Title") ? data["Title"] : null;
    String type = data.containsKey("Type") ? data["Type"] : "";
    String? foot = data.containsKey("FooterText") ? data["FooterText"] : null;
    List<Map<String, dynamic>>? childs =
        data.containsKey("Childs") ? data["Childs"] : null;
    bool isShow = data.containsKey("Show") ? data["Show"] : true;
    return isShow
        ? Padding(
            padding: const EdgeInsets.all(25),
            //根据类型返回不同的组件
            child: type == "PSGroupSpecifier"
                ? WeCupertinoGroup(
                    title: titleStr,
                    foot: foot,
                    isDark: isDark,
                    decoration: decoration,
                    child: childs != null && childs.isNotEmpty
                        ? WeCupertinoColumn(
                            isDark: isDark,
                            decoration: decoration,
                            childs: childs,
                            onClick: onClick,
                            onChanged: onChanged,
                          )
                        : null,
                  )
                : WeCupertinoItem(
                    isDark: isDark,
                    decoration: decoration,
                    child: WeCupertinoListItem(
                      isDark: isDark,
                      decoration: decoration,
                      data: data,
                      onClick: onClick,
                      onChanged: onChanged,
                    ),
                  ),
          )
        : Container();
  }
}

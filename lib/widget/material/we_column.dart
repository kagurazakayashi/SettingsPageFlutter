import "package:flutter/material.dart";
import 'package:settingspageflutter/widget/we_size.dart';

import 'we_list_item.dart';

class WeColumn extends StatelessWidget {
  /// 组的内容控件
  ///
  /// 如果为多项则在各项之间添加分割线
  ///
  /// group child
  ///
  /// If it is multiple items, add a separator between each item
  const WeColumn({
    Key? key,
    this.isDev = false,
    this.isDark = false,
    this.fillColor,
    this.visibilitySemantics,
    this.clearSemantics,
    this.decoration,
    this.childs,
    this.onClick,
    required this.onChanged,
    this.openFile,
    this.saveFile,
    this.btnClick,
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

  /// {@template settingspageflutter.widget.wecolumn.isDark}
  /// 是否为暗黑模式
  ///
  /// 默认为false
  ///
  /// Is it dark mode
  ///
  /// Default is false
  /// {@endtemplate}
  final bool isDark;

  /// {@template settingspageflutter.widget.wecolumn.fillColor}
  /// TextFiled填充颜色
  ///
  /// TextFiled fill color
  /// {@endtemplate}
  final Color? fillColor;

  /// {@template settingspageflutter.widget.wecolumn.visibilitySemantics}
  /// 显示密码语义
  ///
  /// Show password semantics
  /// {@endtemplate}
  final String? visibilitySemantics;

  /// {@template settingspageflutter.widget.wecolumn.clearSemantics}
  /// 清除语义
  ///
  /// Clear semantics
  /// {@endtemplate}
  final String? clearSemantics;

  /// {@template settingspageflutter.widget.wecolumn.decoration}
  /// 条目样式
  ///
  /// Item style
  /// {@endtemplate}
  final BoxDecoration? decoration;

  /// {@template settingspageflutter.widget.wecolumn.childs}
  /// 组内项数据
  ///
  /// group item data
  /// {@endtemplate}
  final List<Map<String, dynamic>>? childs;

  /// {@template settingspageflutter.widget.wecolumn.onClick}
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

  /// {@template settingspageflutter.widget.wecolumn.onChanged}
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

  /// {@template settingspageflutter.widget.wecolumn.openFile}
  /// 打开文件事件
  ///
  /// * [key] 为数据中的key`Key`的值,用于需要修改项的key
  ///
  /// * [extList] 为数据中的key`ExtList`的值,用于需要修改项的key
  ///
  /// Open file event
  ///
  /// * [key] is the value of the key `Key` in the data, used to modify the key of the item that needs to be modified
  ///
  /// * [extList] is the value of the key `ExtList` in the data, used to modify the key of the item that needs to be modified
  /// {@endtemplate}
  final Function(String key, List<String> extList)? openFile;

  ///  {@template settingspageflutter.widget.welistitem.saveFile}
  /// 保存文件事件
  /// 
  /// * [path] 为数据中的key`Path`的值,用于需要修改项的key
  /// 
  /// * [value] 为数据中的key`Value`的值,当期输入框中的值
  /// 
  /// {@endtemplate}
  /// 
  final Function(String path, String value)? saveFile;

  ///  {@template settingspageflutter.widget.welistitem.btnClick}
  /// 按钮点击事件
  ///
  /// * [keyList] 为数据中的key`Key`的值,用于需要修改项的key
  ///
  /// * [actionList] 为数据中的key`Action`的值,用于需要修改项的key
  ///
  /// {@endtemplate}
  final Function(List keyList, List actionList)? btnClick;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>?> data = [];
    if (childs != null) {
      bool topShow = false;
      for (var i = 0; i < childs!.length; i++) {
        var e = childs![i];
        data.add(e);
        bool isShow = true;
        if (e.containsKey("Show")) {
          isShow = e["Show"];
        }
        if (isShow) {
          topShow = true;
        }
        if (i == 0 && i < childs!.length - 1) {
          if (!isShow) {
            continue;
          }
        }
        if (i < childs!.length - 1) {
          var next = childs![i + 1];
          if (next.containsKey("Show")) {
            isShow = next["Show"];
            if (!isShow) {
              continue;
            }
          }
          if (!topShow) {
            continue;
          }
          data.add(null);
        }
      }
    }
    return data.isEmpty
        ? Center(
            child: Text(
              "No Data",
              style: TextStyle(
                fontSize: 16 * weSP,
                color: Colors.grey,
              ),
            ),
          )
        : Column(
            children: data.map((e) {
              bool isShow =
                  e != null && e.containsKey("Show") ? e["Show"] : true;
              if (!isShow) {
                return const SizedBox();
              }
              if (e == null) {
                return const Divider(indent: 15, endIndent: 15);
              }
              return WeListItem(
                isDev: isDev,
                isDark: isDark,
                fillColor: fillColor,
                visibilitySemantics: visibilitySemantics,
                clearSemantics: clearSemantics,
                decoration: decoration,
                data: e,
                onClick: onClick,
                onChanged: onChanged,
                openFile: openFile,
                saveFile: saveFile,
                btnClick: btnClick,
              );
            }).toList(),
          );
  }
}

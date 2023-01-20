import "package:flutter/material.dart";
import 'package:flutter/services.dart';

import 'default.dart';
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
    this.leading,
    this.automaticallyImplyLeading = true,
    this.automaticallyImplyMiddle = true,
    this.previousPageTitle,
    this.middle,
    this.trailing,
    this.border = kDefaultNavBarBorder,
    this.backgroundColor,
    this.brightness,
    this.padding,
    this.transitionBetweenRoutes = true,
    this.decoration,
    required this.data,
    this.onClick,
    required this.onChanged,
  }) : super(key: key);

  /// {@template flutter.cupertino.CupertinoNavigationBar.leading}
  /// Widget to place at the start of the navigation bar. Normally a back button
  /// for a normal page or a cancel button for full page dialogs.
  ///
  /// If null and [automaticallyImplyLeading] is true, an appropriate button
  /// will be automatically created.
  /// {@endtemplate}
  final Widget? leading;

  /// {@template flutter.cupertino.CupertinoNavigationBar.automaticallyImplyLeading}
  /// Controls whether we should try to imply the leading widget if null.
  ///
  /// If true and [leading] is null, automatically try to deduce what the [leading]
  /// widget should be. If [leading] widget is not null, this parameter has no effect.
  ///
  /// Specifically this navigation bar will:
  ///
  /// 1. Show a 'Close' button if the current route is a `fullscreenDialog`.
  /// 2. Show a back chevron with [previousPageTitle] if [previousPageTitle] is
  ///    not null.
  /// 3. Show a back chevron with the previous route's `title` if the current
  ///    route is a [CupertinoPageRoute] and the previous route is also a
  ///    [CupertinoPageRoute].
  ///
  /// This value cannot be null.
  /// {@endtemplate}
  final bool automaticallyImplyLeading;

  /// Controls whether we should try to imply the middle widget if null.
  ///
  /// If true and [middle] is null, automatically fill in a [Text] widget with
  /// the current route's `title` if the route is a [CupertinoPageRoute].
  /// If [middle] widget is not null, this parameter has no effect.
  ///
  /// This value cannot be null.
  final bool automaticallyImplyMiddle;

  /// {@template flutter.cupertino.CupertinoNavigationBar.previousPageTitle}
  /// Manually specify the previous route's title when automatically implying
  /// the leading back button.
  ///
  /// Overrides the text shown with the back chevron instead of automatically
  /// showing the previous [CupertinoPageRoute]'s `title` when
  /// [automaticallyImplyLeading] is true.
  ///
  /// Has no effect when [leading] is not null or if [automaticallyImplyLeading]
  /// is false.
  /// {@endtemplate}
  final String? previousPageTitle;

  /// Widget to place in the middle of the navigation bar. Normally a title or
  /// a segmented control.
  ///
  /// If null and [automaticallyImplyMiddle] is true, an appropriate [Text]
  /// title will be created if the current route is a [CupertinoPageRoute] and
  /// has a `title`.
  final Widget? middle;

  /// {@template flutter.cupertino.CupertinoNavigationBar.trailing}
  /// Widget to place at the end of the navigation bar. Normally additional actions
  /// taken on the page such as a search or edit function.
  /// {@endtemplate}
  final Widget? trailing;

  // TODO(xster): https://github.com/flutter/flutter/issues/10469 implement
  // support for double row navigation bars.

  /// {@template flutter.cupertino.CupertinoNavigationBar.backgroundColor}
  /// The background color of the navigation bar. If it contains transparency, the
  /// tab bar will automatically produce a blurring effect to the content
  /// behind it.
  ///
  /// Defaults to [CupertinoTheme]'s `barBackgroundColor` if null.
  /// {@endtemplate}
  final Color? backgroundColor;

  /// {@template flutter.cupertino.CupertinoNavigationBar.brightness}
  /// The brightness of the specified [backgroundColor].
  ///
  /// Setting this value changes the style of the system status bar. Typically
  /// used to increase the contrast ratio of the system status bar over
  /// [backgroundColor].
  ///
  /// If set to null, the value of the property will be inferred from the relative
  /// luminance of [backgroundColor].
  /// {@endtemplate}
  final Brightness? brightness;

  /// {@template flutter.cupertino.CupertinoNavigationBar.padding}
  /// Padding for the contents of the navigation bar.
  ///
  /// If null, the navigation bar will adopt the following defaults:
  ///
  ///  * Vertically, contents will be sized to the same height as the navigation
  ///    bar itself minus the status bar.
  ///  * Horizontally, padding will be 16 pixels according to iOS specifications
  ///    unless the leading widget is an automatically inserted back button, in
  ///    which case the padding will be 0.
  ///
  /// Vertical padding won't change the height of the nav bar.
  /// {@endtemplate}
  final EdgeInsetsDirectional? padding;

  /// {@template flutter.cupertino.CupertinoNavigationBar.border}
  /// The border of the navigation bar. By default renders a single pixel bottom border side.
  ///
  /// If a border is null, the navigation bar will not display a border.
  /// {@endtemplate}
  final Border? border;

  /// {@template flutter.cupertino.CupertinoNavigationBar.transitionBetweenRoutes}
  /// Whether to transition between navigation bars.
  ///
  /// When [transitionBetweenRoutes] is true, this navigation bar will transition
  /// on top of the routes instead of inside it if the route being transitioned
  /// to also has a [CupertinoNavigationBar] or a [CupertinoSliverNavigationBar]
  /// with [transitionBetweenRoutes] set to true.
  ///
  /// This transition will also occur on edge back swipe gestures like on iOS
  /// but only if the previous page below has `maintainState` set to true on the
  /// [PageRoute].
  ///
  /// When set to true, only one navigation bar can be present per route unless
  /// [heroTag] is also set.
  ///
  /// This value defaults to true and cannot be null.
  /// {@endtemplate}
  final bool transitionBetweenRoutes;

  /// {@template settingspageflutter.widget.weitem.decoration}
  /// 条目样式
  /// {@endtemplate}
  final BoxDecoration? decoration;

  /// {@template settingspageflutter.widget.wegroupitem.data}
  /// plist 文件中的数据
  ///
  /// The data in the plist file
  /// {@endtemplate}
  final Map<String, dynamic> data;

  /// {@template settingspageflutter.widget.wegroupitem.onClick}
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

  /// {@template settingspageflutter.widget.wegroupitem.onChanged}
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
    return Padding(
      padding: const EdgeInsets.all(25),
      //根据类型返回不同的组件
      child: type == "PSGroupSpecifier"
          ? WeCupertinoGroup(
              title: titleStr,
              foot: foot,
              decoration: decoration,
              child: childs != null && childs.isNotEmpty
                  ? WeCupertinoColumn(
                      leading: leading,
                      automaticallyImplyLeading: automaticallyImplyLeading,
                      previousPageTitle: previousPageTitle,
                      middle: middle,
                      automaticallyImplyMiddle: automaticallyImplyMiddle,
                      trailing: trailing,
                      backgroundColor: backgroundColor,
                      brightness: brightness,
                      padding: padding,
                      border: border,
                      transitionBetweenRoutes: transitionBetweenRoutes,
                      childs: childs,
                      onClick: onClick,
                      onChanged: onChanged,
                    )
                  : null,
            )
          : WeCupertinoItem(
              decoration: decoration,
              child: WeCupertinoListItem(
                leading: leading,
                automaticallyImplyLeading: automaticallyImplyLeading,
                previousPageTitle: previousPageTitle,
                middle: middle,
                automaticallyImplyMiddle: automaticallyImplyMiddle,
                trailing: trailing,
                backgroundColor: backgroundColor,
                brightness: brightness,
                padding: padding,
                border: border,
                transitionBetweenRoutes: transitionBetweenRoutes,
                data: data,
                onClick: onClick,
                onChanged: onChanged,
              ),
            ),
    );
  }
}

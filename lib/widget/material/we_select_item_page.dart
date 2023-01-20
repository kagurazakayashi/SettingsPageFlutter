import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:settingspageflutter/widget/we_textstyle.dart";

import "../we_size.dart";

class WeSelectItemPage extends StatelessWidget {
  const WeSelectItemPage({
    Key? key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.backwardsCompatibility,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.isDark = false,
    this.decoration,
    required this.data,
  }) : super(key: key);
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final ScrollNotificationPredicate notificationPredicate;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Brightness? brightness;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final TextTheme? textTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? toolbarHeight;
  final double? leadingWidth;
  final bool? backwardsCompatibility;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// {@template settingspageflutter.widget.weselectitempage.isDark}
  /// 是否为暗黑模式
  /// 
  /// 默认为false
  /// 
  /// Is it dark mode
  /// 
  /// Default is false
  /// {@endtemplate}
  final bool isDark;

  /// {@template settingspageflutter.widget.weselectitempage.decoration}
  /// 条目样式
  /// 
  /// Item style
  /// {@endtemplate}
  final BoxDecoration? decoration;

  /// {@template settingspageflutter.widget.weselectitempage.data}
  /// Data
  ///
  /// format:
  ///
  /// ```dart
  /// [
  ///  {
  ///   "Title": "title 1",
  ///   "Value": "value 1",
  ///  },
  ///  {
  ///   "Title": "title 2",
  ///   "Value": "value 2",
  ///  },
  /// ]
  /// ```
  /// {@endtemplate}
  final List<Map<String, dynamic>>? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        leading: leading,
        actions: actions,
        flexibleSpace: flexibleSpace,
        bottom: bottom,
        elevation: elevation,
        shadowColor: shadowColor,
        shape: shape,
        backgroundColor:
            backgroundColor ?? (isDark ? Colors.black26 : Colors.blue),
        foregroundColor: foregroundColor,
        brightness: brightness,
        iconTheme: iconTheme,
        actionsIconTheme: actionsIconTheme,
        textTheme: textTheme,
        primary: primary,
        centerTitle: centerTitle,
        titleSpacing: titleSpacing,
        toolbarOpacity: toolbarOpacity,
        bottomOpacity: bottomOpacity,
        toolbarHeight: toolbarHeight,
        leadingWidth: leadingWidth,
        backwardsCompatibility: backwardsCompatibility,
        toolbarTextStyle: toolbarTextStyle,
        titleTextStyle: titleTextStyle,
        systemOverlayStyle: systemOverlayStyle,
      ),
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[300],
      body: Column(
        children: data!.map((e) {
          String titleStr = e.containsKey("Title") ? e["Title"] : "";
          return Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 15.0,
              right: 15.0,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context, e);
              },
              child: Container(
                width: weSize.width,
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(2),
                decoration: decoration ??
                    BoxDecoration(
                      color: isDark ? Colors.black38 : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                child: Center(
                  child: Text(
                    titleStr,
                    style: tsMain,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

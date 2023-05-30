import "package:flutter/material.dart";
import "package:settingspageflutter/widget/we_size.dart";

class WeItem extends StatelessWidget {
  /// 处理分组的UI样式
  ///
  /// Provides a group UI style
  const WeItem({
    Key? key,
    this.isDev = false,
    this.decoration,
    required this.child,
    this.isDark = false,
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

  /// {@template settingspageflutter.widget.weitem.isDark}
  /// 是否为暗黑模式
  ///
  /// 默认为false
  ///
  /// Is it dark mode
  ///
  /// Default is false
  /// {@endtemplate}
  final bool isDark;

  /// {@template settingspageflutter.widget.weitem.decoration}
  /// 条目样式
  ///
  /// Item style
  /// {@endtemplate}
  final BoxDecoration? decoration;

  /// {@template settingspageflutter.widget.weitem.child}
  /// 组内的内容控件
  ///
  /// group child
  /// {@endtemplate}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: weSize.width,
      decoration: decoration ??
          BoxDecoration(
            color: isDark ? Colors.black38 : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
      child: Container(
        margin: const EdgeInsets.only(
          top: 12.0,
          bottom: 12.0,
          left: 10.0,
          right: 10.0,
        ),
        child: child,
      ),
    );
  }
}

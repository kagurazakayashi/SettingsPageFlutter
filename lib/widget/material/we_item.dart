import "package:flutter/material.dart";
import "package:settingspageflutter/widget/we_size.dart";

class WeItem extends StatelessWidget {
  /// 处理分组的UI样式
  ///
  /// Provides a group UI style
  const WeItem({
    Key? key,
    this.decoration,
    required this.child,
  }) : super(key: key);

  /// {@template settingspageflutter.widget.weitem.decoration}
  /// 条目样式
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
      child: child,
    );
  }
}

import "package:flutter/cupertino.dart";
import "package:settingspageflutter/widget/we_size.dart";

class WeCupertinoItem extends StatelessWidget {
  /// 处理分组的UI样式
  ///
  /// Provides a group UI style
  const WeCupertinoItem({
    Key? key,
    this.isDark = false,
    this.decoration,
    required this.child,
  }) : super(key: key);

  /// {@template settingspageflutter.widget.wecupertinoitem.isDark}
  /// 是否为暗黑模式
  /// 
  /// 默认为false
  /// 
  /// Is it dark mode
  /// 
  /// Default is false
  /// {@endtemplate}
  final bool isDark;

  /// {@template settingspageflutter.widget.wecupertinoitem.decoration}
  /// 条目样式
  /// 
  /// Item style
  /// {@endtemplate}
  final BoxDecoration? decoration;

  /// {@template settingspageflutter.widget.wecupertinoitem.child}
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
            color: isDark ? CupertinoColors.darkBackgroundGray : CupertinoColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
      child: child,
    );
  }
}

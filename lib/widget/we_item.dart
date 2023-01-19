import "package:flutter/material.dart";
import "package:settingspageflutter/widget/we_size.dart";

class WeItem extends StatelessWidget {
  /// 处理分组的UI样式
  ///
  /// Provides a group UI style
  const WeItem({
    Key? key,
    required this.child,
  }) : super(key: key);

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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[350]!,
            blurRadius: 5,
            spreadRadius: 3,
          ),
        ],
      ),
      child: child,
    );
  }
}

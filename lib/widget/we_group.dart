import "package:flutter/material.dart";

import "we_item.dart";
import "we_textstyle.dart";

class WeGroup extends StatelessWidget {
  /// 处理数据中的组(`PSGroupSpecifier`)控件
  /// 
  /// Provides a group (`PSGroupSpecifier`) control in the data
  const WeGroup({
    Key? key,
    required this.title,
    this.foot,
    required this.child,
  }) : super(key: key);
  /// {@template settingspageflutter.widget.wegroup.title}
  /// 组标题
  /// 
  /// 该属性为必填项
  /// 
  /// 该属性为`PSGroupSpecifier`控件的`Title`属性
  /// 
  /// 内容会在内容的上方显示
  /// 
  /// group title
  /// 
  /// This property is required
  /// 
  /// This property is the `Title` property of the `PSGroupSpecifier` control
  /// 
  /// The content will be displayed above the content
  /// {@endtemplate}
  final String? title;
  /// {@template settingspageflutter.widget.wegroup.foot}
  /// 组尾
  /// 
  /// 该属性为选填项
  /// 
  /// 该属性为`PSGroupSpecifier`控件的`FooterText`属性
  /// 
  /// 内容会在内容的下方显示
  /// 
  /// group foot
  /// 
  /// This property is optional
  /// 
  /// This property is the `FooterText` property of the `PSGroupSpecifier` control
  /// 
  /// The content will be displayed below the content
  /// {@endtemplate}
  final String? foot;
  /// {@template settingspageflutter.widget.wegroup.child}
  /// 组内的内容控件
  /// 
  /// 该属性为必填项
  /// 
  /// 该项为空时，组标题和组尾会居中显示
  /// 
  /// group child
  /// 
  /// This property is required
  /// 
  /// When this item is empty, the group title and group foot will be displayed in the center
  /// {@endtemplate}
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Align(
              alignment:
                  child != null ? Alignment.centerLeft : Alignment.center,
              child: Text(
                title!,
                style: tsGroupTag,
              ),
            ),
          ),
        if (child != null) WeItem(child: child!),
        if (foot != null)
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Align(
              alignment:
                  child != null ? Alignment.centerLeft : Alignment.center,
              child: Text(
                foot!,
                style: tsGroupTag,
              ),
            ),
          ),
      ],
    );
  }
}

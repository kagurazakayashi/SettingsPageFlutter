import "package:flutter/material.dart";
import 'package:flutter/services.dart';

import 'we_column.dart';
import 'we_group.dart';
import 'we_item.dart';
import 'we_list_item.dart';

class WeGroupItem extends StatelessWidget {
  const WeGroupItem({
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
    required this.data,
    this.onClick,
    required this.onChanged,
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
  final Map<String, dynamic> data;
  final Function(List<Map<String, dynamic>>? childs, String? file, String type)? onClick;
  final Function(String key, dynamic value, bool isTip) onChanged;

  @override
  Widget build(BuildContext context) {
    String? titleStr = data.containsKey("Title") ? data["Title"] : null;
    String type = data.containsKey("Type") ? data["Type"] : "";
    String? foot = data.containsKey("FooterText") ? data["FooterText"] : null;
    List<Map<String, dynamic>>? childs =
        data.containsKey("Childs") ? data["Childs"] : null;
    return Padding(
      padding: const EdgeInsets.all(25),
      child: type == "PSGroupSpecifier"
          ? WeGroup(
              title: titleStr,
              foot: foot,
              child: childs != null && childs.isNotEmpty
                  ? WeColumn(
                      title: title,
                      leading: leading,
                      actions: actions,
                      flexibleSpace: flexibleSpace,
                      bottom: bottom,
                      elevation: elevation,
                      shadowColor: shadowColor,
                      shape: shape,
                      backgroundColor: backgroundColor,
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
                      childs: childs,
                      onClick: onClick,
                      onChanged: onChanged,
                    )
                  : null,
            )
          : WeItem(
              child: WeListItem(
                title: title,
                leading: leading,
                actions: actions,
                flexibleSpace: flexibleSpace,
                bottom: bottom,
                elevation: elevation,
                shadowColor: shadowColor,
                shape: shape,
                backgroundColor: backgroundColor,
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
                data: data,
                onClick: onClick,
                onChanged: onChanged,
              ),
            ),
    );
  }
}

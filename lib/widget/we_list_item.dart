import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:settingspageflutter/widget/we_get_widget.dart";
import "package:settingspageflutter/widget/we_select_item_page.dart";

import "we_size.dart";

class WeListItem extends StatelessWidget {
  const WeListItem({
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
    String key = data.containsKey("Key") ? data["Key"] : "";
    String type = data.containsKey("Type") ? data["Type"] : "";
    List<Map<String, dynamic>>? childs =
        data.containsKey("Childs") ? data["Childs"] : null;
    String? file = data.containsKey("File") ? data["File"] : null;

    Widget c = getWidget(data, onChanged);
    Function()? onTap;

    if (childs != null || file != null) {
      onTap = () {
        bool isNext = false;
        if (type == "PSChildPaneSpecifier") {
          isNext = true;
        }
        if (file != null && file.isNotEmpty) {
          isNext = true;
        }
        if (isNext) {
          onClick!(childs, file, type);
        }
      };
    }
    if (type == "PSMultiValueSpecifier") {
      onTap = () {
        String? titleStr = data.containsKey("Title") ? data["Title"] : null;
        List<Map<String, dynamic>>? titleValues =
            data.containsKey("TitleValues") ? data["TitleValues"] : null;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return WeSelectItemPage(
            title: titleStr != null ? Text(titleStr) : title,
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
            data: titleValues,
          );
        })).then((value) {
          if (value is Map) {
            onChanged(key, value, false);
          }
        });
      };
    }

    return SizedBox(
      width: weSize.width - 86,
      child: InkWell(
        onTap: onTap,
        child: c,
      ),
    );
  }
}

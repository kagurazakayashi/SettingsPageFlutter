import "package:flutter/cupertino.dart";

import "../we_size.dart";
import "default.dart";

class WeCupertinoSelectItemPage extends StatelessWidget {
  const WeCupertinoSelectItemPage({
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
    required this.data,
  }) : super(key: key);
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool automaticallyImplyMiddle;
  final String? previousPageTitle;
  final Widget? middle;
  final Widget? trailing;
  final Color? backgroundColor;
  final Brightness? brightness;
  final EdgeInsetsDirectional? padding;
  final Border? border;
  final bool transitionBetweenRoutes;

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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
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
      ),
      backgroundColor: CupertinoColors.systemGrey5,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 50),
            Column(
              mainAxisSize: MainAxisSize.min,
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
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        border: Border.all(color: CupertinoColors.systemGrey5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(titleStr),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
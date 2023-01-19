import "package:flutter/material.dart";

import "we_item.dart";
import "we_textstyle.dart";

class WeGroup extends StatelessWidget {
  const WeGroup({
    Key? key,
    required this.title,
    this.foot,
    required this.child,
  }) : super(key: key);

  final String? title;
  final String? foot;
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

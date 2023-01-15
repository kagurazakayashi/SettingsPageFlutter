import "package:flutter/material.dart";

import "we_size.dart";
import "we_textstyle.dart";

class WeListItem extends StatelessWidget {
  const WeListItem({
    Key? key,
    required this.id,
    this.fatherID,
    this.title,
    required this.val,
    required this.type,
    this.childs,
    this.file,
    this.onClick,
  }) : super(key: key);
  final String id;
  final String? fatherID;
  final String? title;
  final String val;
  final String type;
  final List? childs;
  final String? file;
  final Function(bool isSelect, List? childs, String? file)? onClick;

  @override
  Widget build(BuildContext context) {
    // print(
    // "id: $id, fatherID: $fatherID, title: $title, val: $val, childs: $childs");
    return SizedBox(
      width: size.width - 86,
      child: InkWell(
        onTap: fatherID != null
            ? () {
                Navigator.pop(context, [fatherID, title]);
              }
            : childs != null || file != null
                ? () {
                    bool isNext = false;
                    bool isSelect = false;
                    if (type == "Multi Value") {
                      isNext = true;
                      isSelect = true;
                    }
                    if (type == "PSChildPaneSpecifier") {
                      isNext = true;
                    }
                    if (file != null && file!.isNotEmpty) {
                      isNext = true;
                    }
                    if (isNext) {
                      onClick!(isSelect, childs, file);
                    }
                  }
                : null,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (title != null)
              Text(
                title!,
                style: tsMain,
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  val,
                  style: tsMainVal,
                ),
                if (childs != null || file != null) const SizedBox(width: 5),
                if (childs != null || file != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    weight: 1000,
                    color: Colors.grey[500]!,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

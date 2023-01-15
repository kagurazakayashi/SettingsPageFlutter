import "package:flutter/material.dart";

import 'we_list_item.dart';

class WeColumn extends StatelessWidget {
  const WeColumn({Key? key, this.childs, this.onClick}) : super(key: key);
  final List? childs;
  final Function(bool isSelect, List? childs, String? file)? onClick;

  @override
  Widget build(BuildContext context) {
    List data = [];
    if (childs != null) {
      for (var i = 0; i < childs!.length; i++) {
        var e = childs![i];
        data.add(e);
        if (i < childs!.length - 1) {
          data.add(null);
        }
      }
    }
    return Column(
      children: data.map((e) {
        if (e == null) {
          return const Divider(indent: 15, endIndent: 15);
        }
        String id = e.containsKey("Key") ? e["Key"] : "";
        String title = e.containsKey("Title") ? e["Title"] : "";
        String type = e.containsKey("Type") ? e["Type"] : "";
        // String? foot = e.containsKey("foot") ? e["foot"] : null;
        String val = e.containsKey("val") ? e["val"] : "";
        List<Map<String, dynamic>>? childs =
            e.containsKey("Childs") ? e["Childs"] : null;
        String? file = e.containsKey("File") ? e["File"] : null;
        return WeListItem(
          id: id,
          title: title,
          val: val,
          type: type,
          childs: childs,
          file: file,
          onClick: onClick,
        );
      }).toList(),
    );
  }
}

import "package:flutter/material.dart";

import 'we_column.dart';
import 'we_group.dart';
import 'we_item.dart';
import 'we_list_item.dart';

class WeGroupItem extends StatelessWidget {
  const WeGroupItem({
    Key? key,
    required this.title,
    required this.foot,
    required this.type,
    required this.id,
    required this.fatherID,
    required this.val,
    required this.file,
    required this.childs,
    required this.onClick,
  }) : super(key: key);
  final String? title;
  final String? foot;
  final String type;
  final String id;
  final String? fatherID;
  final String val;
  final String? file;
  final List? childs;
  final Function(bool isSelect, List? childs, String? file)? onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: type == "PSGroupSpecifier"
          ? WeGroup(
              title: title,
              foot: foot,
              child: WeColumn(
                childs: childs,
                onClick: onClick,
              ),
            )
          : WeItem(
              child: WeListItem(
                id: id,
                fatherID: fatherID,
                title: title,
                val: val,
                type: type,
                childs: childs,
                file: file,
                onClick: onClick,
              ),
            ),
    );
  }
}

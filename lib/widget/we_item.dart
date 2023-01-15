import "package:flutter/material.dart";

import "we_textstyle.dart";

class WeItem extends StatelessWidget {
  const WeItem({
    Key? key,
    this.title,
    required this.child,
  }) : super(key: key);
  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(2),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null)
            Text(
              title!,
              style: tsMain,
            ),
          child,
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';

import 'we_size.dart';
import 'we_textstyle.dart';

void setTextStyle({bool isDark = false}) {
  tsMain = TextStyle(
    fontSize: 15 * sp,
    color: isDark ? Colors.white : Colors.black,
  );

  tsMainVal = TextStyle(
    fontSize: 15 * sp,
    color: isDark ? Colors.white70 : Colors.grey[500],
  );

  tsGroupTag = TextStyle(
    fontSize: 12 * sp,
    color: isDark ? Colors.white60 : Colors.grey[700],
  );
}

/// 适配屏幕
void setSize(Size size, {double pixelRatio = -1.0}) {
  weSize = size;
  w = weSize.width;
  h = weSize.height;
  sp = (((h + w) +
              ((pixelRatio != -1 ? pixelRatio : window.devicePixelRatio) *
                  aspectRatio(w, h))) /
          10.8) /
      100;
  print(sp);
}

/// 获取屏幕宽高比
double aspectRatio(double width, double height) {
  if (height != 0.0) {
    return width / height;
  }
  if (width > 0.0) {
    return double.infinity;
  }
  if (width < 0.0) {
    return double.negativeInfinity;
  }
  return 0.0;
}

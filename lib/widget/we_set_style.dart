import 'dart:ui';

import 'package:flutter/material.dart';

import 'we_size.dart';
import 'we_textstyle.dart';

void setTextStyle({bool isDark = false}) {
  tsMain = TextStyle(
    fontSize: 15 * weSP,
    color: isDark ? Colors.white : Colors.black,
  );

  tsMainVal = TextStyle(
    fontSize: 15 * weSP,
    color: isDark ? Colors.white70 : Colors.grey[500],
  );

  tsGroupTag = TextStyle(
    fontSize: 12 * weSP,
    color: isDark ? Colors.white60 : Colors.grey[700],
  );
}

/// 适配屏幕
void setSize(Size size, {double pixelRatio = -1.0}) {
  weSize = size;
  weWidth = weSize.width;
  weHeight = weSize.height;
  weSP = (((weWidth + weHeight) +
              ((pixelRatio != -1 ? pixelRatio : window.devicePixelRatio) *
                  aspectRatio(weWidth, weHeight))) /
          10.8) /
      100;
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

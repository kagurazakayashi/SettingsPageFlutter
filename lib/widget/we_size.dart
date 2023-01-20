import 'dart:ui';

import 'we_set_style.dart';

/// 获取屏幕尺寸
Size weSize = window.physicalSize;
/// 获取屏幕宽度
double w = weSize.width;
/// 获取屏幕高度
double h = weSize.height;
/// 获取当前屏幕中较为合适的字体单位大小
double sp =
    (((h + w) + (window.devicePixelRatio * aspectRatio(w, h))) / 10.8) / 100;

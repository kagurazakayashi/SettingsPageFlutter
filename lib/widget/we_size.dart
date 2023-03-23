import 'dart:ui';

import 'we_set_style.dart';

/// 获取屏幕尺寸
Size weSize = window.physicalSize;

/// 获取屏幕宽度
double weWidth = weSize.width;

/// 获取屏幕高度
double weHeight = weSize.height;

/// 获取当前屏幕中较为合适的字体单位大小
double weSP = (((weWidth + weHeight) +
            (window.devicePixelRatio * aspectRatio(weWidth, weHeight))) /
        10.8) /
    100;

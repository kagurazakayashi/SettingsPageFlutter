import 'dart:ui';

import 'we_set_style.dart';

/// 获取当前窗口（首个 FlutterView）
FlutterView _view = PlatformDispatcher.instance.views.first;

/// 获取屏幕尺寸
Size weSize = _view.physicalSize;

/// 获取屏幕宽度
double weWidth = weSize.width;

/// 获取屏幕高度
double weHeight = weSize.height;

/// 获取当前屏幕中较为合适的字体单位大小
double weSP = (((weWidth + weHeight) +
            (_view.devicePixelRatio * aspectRatio(weWidth, weHeight))) /
        10.8) /
    100;

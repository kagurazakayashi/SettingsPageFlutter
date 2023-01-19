import 'dart:ui';

/// 获取屏幕尺寸
Size weSize = window.physicalSize;
/// 获取屏幕宽度
double w = weSize.width;
/// 获取屏幕高度
double h = weSize.height;
/// 获取当前屏幕中较为合适的字体单位大小
double sp =
    (((h + w) + (window.devicePixelRatio * aspectRatio(w, h))) / 10.8) / 100;

/// 适配屏幕
void setSize(Size size) {
  weSize = size;
  w = weSize.width;
  h = weSize.height;
  sp = (((h + w) + (window.devicePixelRatio * aspectRatio(w, h))) / 10.8) / 100;
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

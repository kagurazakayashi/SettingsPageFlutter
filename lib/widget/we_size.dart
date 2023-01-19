import 'dart:ui';

Size weSize = window.physicalSize;
double w = weSize.width;
double h = weSize.height;
double sp =
    (((h + w) + (window.devicePixelRatio * aspectRatio(w, h))) / 10.8) / 100;

void setSize(Size size) {
  weSize = size;
  w = weSize.width;
  h = weSize.height;
  sp = (((h + w) + (window.devicePixelRatio * aspectRatio(w, h))) / 10.8) / 100;
}

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

import 'dart:ui';

Size size = window.physicalSize;
final w = size.width;
final h = size.height;
final sp =
    (((h + w) + (window.devicePixelRatio * aspectRatio(w, h))) / 10.8) / 100;

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

class Global {
  bool isShowLog = false;

  static final Global i = Global._internal();
  factory Global() {
    return i;
  }
  Global._internal() {
    // 此處進行初始化操作
  }
}

import "package:bot_toast/bot_toast.dart";
import "package:flutter/material.dart";
import "package:settingspageflutter/settingspageloader.dart";
import "package:settingspageflutter/widget/material/we_group_item.dart";
import "package:settingspageflutter/widget/we_set_style.dart";

import "data.dart";
import "notification_center.dart";
import "we_set_val.dart";

class SelectPage extends StatefulWidget {
  const SelectPage({
    super.key,
    this.option,
    this.file = "Root",
    this.type,
  });
  final List<Map<String, dynamic>>? option;
  final String file;
  final String? type;

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> with WidgetsBindingObserver {
  List<Map<String, dynamic>> _settingData = [];
  String nkey = "";
  String _title = "";

  @override
  void initState() {
    if (widget.option == null) {
      loadFile(widget.file);
    } else {
      if (widget.type != null &&
          widget.type == "PSMultiValueSpecifier" &&
          widget.option != null &&
          widget.option!.isNotEmpty) {
        String title = widget.option![0].containsKey("Title")
            ? widget.option![0]["Title"]
            : "";
        List<Map<String, dynamic>>? titleValues =
            widget.option![0].containsKey("TitleValues")
                ? widget.option![0]["TitleValues"]
                : null;
        _title = title;
        _settingData = titleValues!;
      } else {
        _settingData = widget.option!;
      }
    }
    nkey = "upload";
    for (var i = 0; i < 1000; i++) {
      if (NotificationCenter.instance.postNameMap.containsKey(nkey)) {
        nkey = "upload$i";
      } else {
        break;
      }
    }
    NotificationCenter.instance.addObserver(nkey, (object) {
      // 判断各个控件是否显示
      SettingsPageLoader().uploadIsShow(_settingData);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    NotificationCenter.instance.removeNotification(nkey);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    setTextStyle(isDark: isDark);
    setState(() {});
    super.didChangePlatformBrightness();
  }

  /// 加载`plist`文件
  void loadFile(String fileName) {
    SettingsPageLoader().loadPlistFile(plistFileName: fileName).then((value) {
      _settingData = value.preferenceSpecifiers;
      _title = value.title;
      print("loadFile：\n$_settingData");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    setSize(
      MediaQuery.of(context).size,
      pixelRatio: MediaQuery.of(context).devicePixelRatio,
    );
    setTextStyle(isDark: isDark);
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: isDark ? Colors.black26 : Colors.blue,
      ),
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[300],
      body: _settingData.isNotEmpty
          ? ListView.builder(
              itemCount: _settingData.length,
              itemBuilder: (context, i) {
                Map<String, dynamic> o = _settingData[i];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: widget.type == "PSMultiValueSpecifier"
                      ? () {
                          Navigator.pop(context, o);
                        }
                      : null,
                  child: WeGroupItem(
                    isDark: isDark,
                    data: o,
                    onClick: (childs, file, type) {
                      BotToast.showText(
                        text: "type: $type",
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectPage(
                            option: childs,
                            file:
                                file != null && file.isNotEmpty ? file : "root",
                            type: type,
                          ),
                        ),
                      ).then((value) {
                        Map data = {};
                        if (type == "PSMultiValueSpecifier" &&
                            childs != null &&
                            childs.isNotEmpty) {
                          data = childs[0];
                          String key =
                              data.containsKey("Key") ? data["Key"] : "";
                          bool isUpLoad = weSetVal(_settingData, key, value);
                          if (isUpLoad) {
                            NotificationCenter.instance
                                .postNotification(nkey, [key, value]);
                          }
                        }
                      });
                    },
                    onChanged: (key, value, isTip) {
                      bool isUpLoad = weSetVal(_settingData, key, value);
                      if (isUpLoad) {
                        NotificationCenter.instance
                            .postNotification(nkey, [key, value]);
                        if (isTip) {
                          BotToast.showText(
                            text: 'K: $key - V: $value\n已修改',
                          );
                        }
                      }
                    },
                  ),
                );
              },
            )
          : Container(),
    );
  }
}

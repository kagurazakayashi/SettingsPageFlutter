import "dart:convert";
import "dart:ui";

import "package:bot_toast/bot_toast.dart";
import "package:flutter/material.dart";
import "package:settingspageflutter/settingspageloader.dart";
import "package:settingspageflutter/widget/we_group_item.dart";
import "package:settingspageflutter/widget/we_setting_page.dart";
import "package:settingspageflutter/widget/we_size.dart";

import "notification_center.dart";
import "we_set_val.dart";

class SelectPage extends StatefulWidget {
  const SelectPage({
    super.key,
    this.option,
    this.file = "Root",
  });
  final List? option;
  final String file;

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  List _settingData = [];
  String nkey = "";

  @override
  void initState() {
    // _data = widget.option;
    if (widget.option == null) {
      loadFile(widget.file);
    } else {
      _settingData = widget.option!;
    }
    // if (widget.fatherID == null) {
    nkey = "upload";
    for (var i = 0; i < 1000; i++) {
      if (postNames.contains(nkey)) {
        nkey = "upload$i";
      } else {
        break;
      }
    }

    for (Map<String, dynamic> e in _settingData) {
      _data.add(e);
    }
    postNames.add(nkey);
    NotificationCenter.instance.addObserver(nkey, (object) {
      setState(() {});
    });
    // }
    super.initState();
  }

  void loadFile(String fileName) {
    SettingsPageLoader().loadPlistFile(plistFileName: fileName).then((value) {
      _settingData = value.preferenceSpecifiers;
      setState(() {});
    });
  }

  @override
  void dispose() {
    postNames.remove(nkey);
    NotificationCenter.instance.removeNotification(nkey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    weSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          ),
      ),
      backgroundColor: Colors.grey[300],
      body: _settingData.isNotEmpty
          ? ListView.builder(
              itemCount: _settingData.length,
              itemBuilder: (context, i) {
                Map<String, dynamic> o = _settingData[i];
                return WeGroupItem(
                  data: o,
                  onClick: (childs, file, type) {
                    if (type == "PSMultiValueSpecifier") {
                      BotToast.showText(
                        text: "Multi Value",
                      );
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectPage(
                          option: childs,
                          file: file != null && file.isNotEmpty ? file : "root",
                        ),
                      ),
                    ).then((value) {
                      if (value is List) {
                        String vid = value[0];
                        String vVal = value[1];
                        bool isUpLoad = weSetVal(_settingData, vid, vVal);
                        if (isUpLoad) {
                          NotificationCenter.instance
                              .postNotification("upload", [vid, vVal]);
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
                );
              },
            )
          : Container(),
    );
  }
}

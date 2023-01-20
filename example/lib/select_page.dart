import "package:bot_toast/bot_toast.dart";
import "package:flutter/material.dart";
import "package:settingspageflutter/settingspageloader.dart";
import "package:settingspageflutter/widget/material/we_group_item.dart";
import "package:settingspageflutter/widget/we_set_style.dart";

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
  String _title = "";
  final bool _isDark = false;

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
      if (NotificationCenter.instance.postNameMap.containsKey(nkey)) {
        nkey = "upload$i";
      } else {
        break;
      }
    }
    NotificationCenter.instance.addObserver(nkey, (object) {
      setState(() {});
    });
    // }
    super.initState();
  }

  void loadFile(String fileName) {
    SettingsPageLoader().loadPlistFile(plistFileName: fileName).then((value) {
      _settingData = value.preferenceSpecifiers;
      _title = value.title;
      print(">> _settingData: ${value.stringsTable}");
      setState(() {});
    });
  }

  @override
  void dispose() {
    NotificationCenter.instance.removeNotification(nkey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setSize(MediaQuery.of(context).size);
    setTextStyle(isDark: _isDark);
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: _isDark ? Colors.black26 : Colors.blue,
      ),
      backgroundColor: _isDark ? Colors.grey[900] : Colors.grey[300],
      body: _settingData.isNotEmpty
          ? ListView.builder(
              itemCount: _settingData.length,
              itemBuilder: (context, i) {
                Map<String, dynamic> o = _settingData[i];
                return WeGroupItem(
                  isDark: _isDark,
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   border: Border.all(color: Colors.grey[300]!),
                  //   borderRadius: const BorderRadius.all(Radius.circular(20)),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.grey[300]!,
                  //       blurRadius: 5,
                  //       spreadRadius: 3,
                  //     ),
                  //   ],
                  // ),
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
                          file: file != null && file.isNotEmpty ? file : "root",
                        ),
                      ),
                    );
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

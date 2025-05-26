import "dart:io";

import "package:bot_toast/bot_toast.dart";
import "package:file_picker/file_picker.dart";
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
    this.type,
    // 可以提供以下三個選項之一（不可以提供多個）：
    // 1. plist 檔案路徑，絕對路徑。
    this.path = "",
    // 2. 直接提供 plist 內容。
    this.data = "",
    // 3. plist 檔名，路徑基於 [baseDir] 屬性，不帶副檔名。
    this.file = "Root",
    this.baseDir = "Settings.bundle/",
  });
  final List<Map<String, dynamic>>? option;
  final String path;
  final String data;
  final String file;
  final String baseDir;
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
      SettingsPageLoader(baseDir: widget.baseDir)
          .loadPlist(
              plistFilePath: widget.path,
              importData: widget.data,
              plistFileName: widget.file)
          .then((value) {
        _settingData = value.preferenceSpecifiers;
        print(_settingData);
        _title = value.title;
        setState(() {});
      });
    } else {
      if (widget.type != null &&
          widget.type == "PSMultiValueSpecifier" &&
          widget.option != null &&
          widget.option!.isNotEmpty) {
        String title = widget.option![0].containsKey("Title")
            ? widget.option![0]["Title"]
            : "";
        _title = title;
        if (widget.option![0].containsKey("TitleValues")) {
          List<Map<String, dynamic>>? titleValues =
              widget.option![0]["TitleValues"];
          _settingData = [
            {
              "Type": "PSGroupSpecifier",
              "Childs": titleValues,
            }
          ];
        }
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

  @override
  Widget build(BuildContext context) {
    isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    setTextStyle(isDark: isDark);
    setSize(
      MediaQuery.of(context).size,
      pixelRatio: MediaQuery.of(context).devicePixelRatio,
    );
    setTextStyle(isDark: isDark);
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: isDark ? Colors.black26 : const Color(0xFF214473),
        actions: [
          IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            icon: const Icon(Icons.send),
          )
        ],
      ),
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[300],
      body: _settingData.isNotEmpty
          ? ListView.builder(
              itemCount: _settingData.length,
              itemBuilder: (context, i) {
                Map<String, dynamic> o = _settingData[i];
                return WeGroupItem(
                  isDark: isDark,
                  fillColor: isDark
                      ? Colors.white10
                      : const Color(0xFFBDD6EE),
                  data: o,
                  onClick: (childs, file, type) {
                    if (childs != null) {
                      for (var c in childs) {
                        if (!c.containsKey("Val")) {
                          continue;
                        }
                        Navigator.pop(context, c);
                        return;
                      }
                    }
                    BotToast.showText(
                      text: "type: $type",
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectPage(
                          option: childs,
                          file: file != null && file.isNotEmpty ? file : "root",
                          type: type,
                        ),
                      ),
                    ).then((value) {
                      Map data = {};
                      if (type == "PSMultiValueSpecifier" &&
                          childs != null &&
                          childs.isNotEmpty) {
                        data = childs[0];
                        String key = data.containsKey("Key") ? data["Key"] : "";
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
                  openFile: (String key, List<String> extList) async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: extList,
                    );
                    print(">>> extList: $extList");

                    if (result != null && result.files.single.path != null) {
                      File file = File(result.files.single.path!);
                      String crtStr = file.readAsStringSync();
                      print(" ================ ");
                      print(file);
                      print(crtStr);
                      List<int> bytes = crtStr.codeUnits;
                      print(bytes);
                      bytes = file.readAsBytesSync();
                      print(bytes);

                      bool isUpLoad = weSetVal(_settingData, key, crtStr);
                      if (isUpLoad) {
                        NotificationCenter.instance
                            .postNotification(nkey, [key, crtStr]);
                      }
                    } else {
                      // User canceled the picker
                    }
                  },
                  saveFile: (path, value) {
                    BotToast.showText(text: "saveFile: $path\n$value");
                  },
                );
              },
            )
          : Container(),
    );
  }
}

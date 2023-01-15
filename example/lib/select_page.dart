import "package:flutter/material.dart";
import "package:settingspageflutter/settingspageloader.dart";
import "package:settingspageflutter/widget/we_group_item.dart";
import "package:settingspageflutter/widget/we_set_val.dart";

import "notification_center.dart";

class SelectPage extends StatefulWidget {
  const SelectPage({
    super.key,
    this.option,
    this.fatherID,
    this.file = "Root",
  });
  final List? option;
  final String? fatherID;
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
    if (widget.fatherID == null) {
      nkey = "upload";
      for (var i = 0; i < 1000; i++) {
        if (postNames.contains(nkey)) {
          nkey = "upload$i";
        } else {
          break;
        }
      }

      postNames.add(nkey);
      NotificationCenter.instance.addObserver(nkey, (object) {
        print("postNames: $postNames <=> data: $object");
        setState(() {});
      });
    }
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
    return Scaffold(
      appBar: AppBar(
          // actions: [
          //   IconButton(
          //     onPressed: () => setState(() {}),
          //     icon: const Icon(Icons.replay_sharp),
          //   ),
          // ],
          ),
      backgroundColor: Colors.grey[300],
      body: _settingData.isNotEmpty
          ? ListView.builder(
              itemCount: _settingData.length,
              itemBuilder: (context, i) {
                Map o = _settingData[i];
                String id = o.containsKey("Key") ? o["Key"] : "";
                String title = o.containsKey("Title") ? o["Title"] : "";
                String type = o.containsKey("Type") ? o["Type"] : "";
                String? foot = o.containsKey("Foot") ? o["Foot"] : null;
                String val = o.containsKey("val") ? o["val"] : "";
                List? childs = o.containsKey("Childs") ? o["Childs"] : null;
                String? file = o.containsKey("File") ? o["File"] : null;
                return WeGroupItem(
                  title: title,
                  foot: foot,
                  type: type,
                  id: id,
                  fatherID: widget.fatherID,
                  val: val,
                  file: file,
                  childs: childs,
                  onClick: (isSelect, childs, file) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectPage(
                          option: childs,
                          fatherID: isSelect ? id : null,
                          file: file != null && file.isNotEmpty ? file : "root",
                        ),
                      ),
                    ).then((value) {
                      print(value);
                      if (value is List) {
                        String vid = value[0];
                        String vVal = value[1];
                        bool isUpLoad = weSetVal(_settingData, vid, vVal);
                        print('_settingData: $_settingData >> isUpLoad: $isUpLoad');
                        if (isUpLoad) {
                          NotificationCenter.instance.postNotification("upload", [vid, vVal]);
                        }
                      }
                    });
                  },
                );
              },
            )
          : Container(),
    );
  }
}

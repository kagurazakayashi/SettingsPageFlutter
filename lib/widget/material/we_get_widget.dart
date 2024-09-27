import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:settingspageflutter/widget/material/we_TextField.dart";
import "package:settingspageflutter/widget/material/we_timepicker.dart";
import "package:settingspageflutter/widget/we_size.dart";

import "../we_handle.dart";
import "../we_textstyle.dart";

/// 根据数据返回控件
///
/// * [data] 数据
///
/// * [onChanged] 数据改变时的回调
///
///   * [key] 为数据中的key`Key`的值,用于需要修改项的key
///
///   * [value] 为数据中的key`Value`的值,用于需要修改项的value
///
///   * [isTip] 用于判断是否需要提示，当前只有`PSTextFieldSpecifier`类型的项才会有提示
///
/// * [openFile] 打开文件的回调
///
///   * [key] 为数据中的key`Key`的值,用于需要修改项的key
///
///   * [extList] 为文件扩展名列表
///
/// * [isDev] 是否为开发模式
///
/// * [isDark] 是否为深色模式
///
/// * [fillColor] TextField填充颜色
///
/// Returns a control based on data
///
/// * [data] data
///
/// * [onChanged] callback when data changes
///
///   * [key] is the value of the key `Key` in the data, used for the key of the item to be modified
///
///   * [value] is the value of the key `Value` in the data, used for the value of the item to be modified
///
///   * [isTip] is used to determine whether a prompt is needed. Currently, only items of type `PSTextFieldSpecifier` will have prompts
///
/// * [openFile] callback to open the file
///
///   * [key] is the value of the key `Key` in the data, used for the key of the item to be modified
///
///   * [extList] is the list of file extensions
///
/// * [isDev] Whether it is development mode
///
/// * [isDark] Whether it is dark mode
///
/// * [fillColor] TextField fill color
/// {@tool snippet}
/// ```
/// onChanged: (key, value, isTip) {
///   bool isUpLoad = weSetVal(_settingData, key, value);
///   if (isUpLoad) {
///     NotificationCenter.instance
///         .postNotification(nkey, [key, value]);
///     if (isTip) {
///       BotToast.showText(
///         text: 'K: $key - V: $value\n已修改',
///       );
///     }
///   }
/// }
/// ```
/// {@end-tool}
Widget getWidget(
  BuildContext context,
  Map<String, dynamic> data,
  final Function(String key, dynamic value, bool isTip) onChanged, {
  final Function(String key, List<String> extList)? openFile,
  String? visibilitySemantics,
  String? clearSemantics,
  Color? fillColor,
  bool isDev = false,
  bool isDark = false,
}) {
  late Widget c;
  String id = data.containsKey("Key") ? data["Key"] : "";
  String title = data.containsKey("Title") ? data["Title"] : "";
  String type = data.containsKey("Type") ? data["Type"] : "";
  List<Map<String, dynamic>>? childs =
      data.containsKey("Childs") ? data["Childs"] : null;
  String? file = data.containsKey("File") ? data["File"] : null;
  List<Map<String, dynamic>>? titleValues =
      data.containsKey("TitleValues") ? data["TitleValues"] : null;

  //根据类型返回控件
  switch (type) {
    case "PSToggleSwitchSpecifier": //开关(Switch)
      String key = data.containsKey("Key") ? data["Key"] : ""; //键
      Object temp = data.containsKey("Value")
          ? data["Value"]
          : data.containsKey("DefaultValue")
              ? data["DefaultValue"]
              : false;
      bool val = false;

      Object valtrue = data.containsKey("True") ? data["True"] : true;
      Object valfalse = data.containsKey("False") ? data["False"] : false;

      switch (temp.runtimeType) {
        case bool:
          if (temp.toString() == valtrue.toString()) {
            val = true;
          } else if (temp.toString() == valfalse.toString()) {
            val = false;
          } else {
            val = temp as bool;
          }
          break;
        case String:
          if (temp == valtrue.toString()) {
            val = true;
          } else if (temp == valfalse.toString()) {
            val = false;
          }
          break;
      }

      const int maxLine = 99;
      List<String> texts = [title];
      List<TextStyle> styles = [tsMaincalculate];
      if (isDev && key.isNotEmpty) {
        texts.add(key);
        styles.add(tsGroupTagcalculate);
      }
      double titleWidth = calculateMaxTextWidth(texts, styles);
      double cellWidth = weWidth - 135;
      int titleMaxLines = 1;
      if (titleWidth > cellWidth / 2) {
        titleWidth = weWidth - 180;
        titleMaxLines = 99;
      }
      double titleHeight = calculateTextHeight(
          title, tsMaincalculate, titleWidth,
          maxLines: titleMaxLines);
      c = SizedBox(
        child: Semantics(
          toggled: val,
          onTap: () => onChanged(id, !val, false),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title.isNotEmpty)
                    SizedBox(
                      width: titleWidth,
                      height: titleHeight,
                      child: Text(
                        title,
                        style: tsMain,
                        maxLines: maxLine,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (isDev && key.isNotEmpty)
                    Text(
                      key,
                      style: tsGroupTag,
                    ),
                ],
              ),
              const SizedBox(width: 8),
              ExcludeSemantics(
                child: Switch(
                  value: val,
                  onChanged: (val) => onChanged(id, val, false),
                ),
              ),
            ],
          ),
        ),
      );
      break;
    case "PSTextFieldSpecifier": //文本框(TextField)
      String key = data.containsKey("Key") ? data["Key"] : ""; //键
      String val = data.containsKey("Value") ? data["Value"] : ""; //内容
      String label = data.containsKey('Title') ? data['Title'] : ""; //标签
      String hintText = data.containsKey('HintText')
          ? data['HintText']
          : data.containsKey('DefaultValue')
              ? data['DefaultValue']
              : ""; //提示文本
      bool autoCorrect = false; //自动纠正拼写
      bool readOnly = false; //是否为只读
      TextCapitalization autoCapitalization = TextCapitalization.none; //自动大写
      bool obscureText = false; //是否密文显示
      List<TextInputFormatter> inputFormatters = []; //输入格式化程序
      RegExp? regExp; //正则表达式
      TextInputType keyboardType = TextInputType.text; //键盘样式
      TextInputAction textInputAction = TextInputAction.done; //键盘回车键样式
      String? helperText;
      int maxLines = 1; //最大行数
      int? maxLength; //最大长度
      bool autofocus = false; //是否自动获取焦点
      bool isFile = false; //是否为文件
      List<String> fileExt = []; //文件扩展名

      //自动纠正拼写
      Object temp = data.containsKey("AutocorrectionStyle")
          ? data["AutocorrectionStyle"]
          : false;
      switch (temp.runtimeType) {
        case bool:
          autoCorrect = temp as bool;
          break;
        case String:
          if (temp == "true") {
            autoCorrect = true;
          } else if (temp == "false") {
            autoCorrect = false;
          }
          break;
      }
      //是否为只读
      temp = data.containsKey("IsReadonly") ? data["IsReadonly"] : false;
      switch (temp.runtimeType) {
        case bool:
          readOnly = temp as bool;
          break;
        case String:
          if (temp == "true") {
            readOnly = true;
          } else if (temp == "false") {
            readOnly = false;
          }
          break;
      }
      //自动大写
      temp = data.containsKey("AutocapitalizationStyle")
          ? data["AutocapitalizationStyle"]
          : 'none';
      switch (temp.runtimeType) {
        case String:
          switch (temp) {
            case "words":
              autoCapitalization = TextCapitalization.words;
              break;
            case "sentences":
              autoCapitalization = TextCapitalization.sentences;
              break;
            case "allCharacters":
              autoCapitalization = TextCapitalization.characters;
              break;
            case "none":
              break;
            default:
              autoCapitalization = TextCapitalization.none;
          }
          break;
      }
      //是否密文显示
      temp = data.containsKey('TextFieldIsSecure')
          ? data['TextFieldIsSecure']
          : false;
      switch (temp.runtimeType) {
        case bool:
          obscureText = temp as bool;
          break;
        case String:
          if (temp == "true") {
            obscureText = true;
          } else if (temp == "false") {
            obscureText = false;
          }
          break;
      }
      //正则表达式
      temp = data.containsKey("RegExp") ? data["RegExp"] : "";
      if (temp is String && temp.isNotEmpty) {
        inputFormatters.add(
          FilteringTextInputFormatter.allow(
            RegExp(temp),
          ),
        );
        Object regExpRang =
            data.containsKey("RegExpRang") ? data["RegExpRang"] : "";
        if (regExpRang is List<Object> && regExpRang.length >= 2) {
          double? regExpStart;
          double? regExpEnd;
          switch (regExpRang[0].runtimeType) {
            case double:
              regExpStart = regExpRang[0] as double;
              break;
            case int:
              regExpStart = (regExpRang[0] as int).toDouble();
              break;
            case String:
              try {
                regExpStart = double.parse(regExpRang[0] as String);
              } catch (_) {
                regExpStart = null;
              }
              break;
            default:
          }
          switch (regExpRang[1].runtimeType) {
            case double:
              regExpEnd = regExpRang[1] as double;

              break;
            case int:
              regExpEnd = (regExpRang[1] as int).toDouble();
              break;
            case String:
              try {
                regExpEnd = double.parse(regExpRang[1] as String);
              } catch (_) {
                regExpEnd = null;
              }
              break;
            default:
          }
          print(">>> 000 $regExpStart $regExpEnd");
          // String reStartStr = doubleToStr(regExpStart);
          // String reEndStr = doubleToStr(regExpEnd);
          // print(">>> >>> $reStartStr $reEndStr");
          helperText = "${doubleToStr(regExpStart)} ~ ${doubleToStr(regExpEnd)}";
          inputFormatters.add(
            TextInputFormatter.withFunction((oldValue, newValue) {
              if (newValue.text.isEmpty || newValue.text == '-') {
                return newValue;
              }
              final double? value = double.tryParse(newValue.text);
              if (value == null) {
                return oldValue;
              }
              if (regExpStart != null && value < regExpStart) {
                return oldValue;
              }
              if (regExpEnd != null && value > regExpEnd) {
                return oldValue;
              }
              return newValue;
            }),
          );
        }
      }
      temp = data.containsKey("RegExpItem") ? data["RegExpItem"] : -1;
      if (temp is int && temp >= 0) {
        List<Object> tAllow =
            data.containsKey("RegExpAllow") ? data["RegExpAllow"] : [];
        if (temp < tAllow.length) {
          String regExp = "";
          if (tAllow[temp] is String) {
            regExp = tAllow[temp] as String;
          }
          if (regExp.isNotEmpty) {
            inputFormatters.add(
              FilteringTextInputFormatter.allow(
                RegExp(regExp),
              ),
            );
          }
        }
        List<Object> tDeny =
            data.containsKey("RegExpDeny") ? data["RegExpDeny"] : [];
        if (temp < tDeny.length) {
          String regExp = "";
          if (tDeny[temp] is String) {
            regExp = tDeny[temp] as String;
          }
          if (regExp.isNotEmpty) {
            inputFormatters.add(
              FilteringTextInputFormatter.deny(
                RegExp(regExp),
              ),
            );
          }
        }
      }
      // switch (temp.runtimeType) {
      //   case List:
      //   case List<String>:
      //   case List<dynamic>:
      //     List regExpList = temp as List;
      //     for (Object regExp in regExpList) {
      //       if (regExp.runtimeType != String||regExp.toString().isEmpty) {
      //         continue;
      //       }
      //       inputFormatters.add(
      //         FilteringTextInputFormatter.allow(
      //           RegExp(regExp as String),
      //         ),
      //       );
      //     }
      //     break;
      // }

      // 正则检查
      temp = data.containsKey("OnSubmittedRegExp")
          ? data["OnSubmittedRegExp"]
          : false;
      if (temp is String && temp.isNotEmpty) {
        regExp = RegExp(temp);
      }

      //键盘样式
      temp = data.containsKey('KeyboardType') ? data['KeyboardType'] : 'text';
      switch (temp.runtimeType) {
        case String:
          switch (temp) {
            case "text":
              keyboardType = TextInputType.text;
              break;
            case "number":
              keyboardType = TextInputType.number;
              break;
            case "phone":
              keyboardType = TextInputType.phone;
              break;
            case "email":
              keyboardType = TextInputType.emailAddress;
              break;
            case "url":
              keyboardType = TextInputType.url;
              break;
            case "datetime":
              keyboardType = TextInputType.datetime;
              break;
            case "multiline":
              keyboardType = TextInputType.multiline;
              break;
            case "visiblePassword":
              keyboardType = TextInputType.visiblePassword;
              break;
          }
      }
      //键盘回车键样式
      temp = data.containsKey('ReturnKeyType') ? data['ReturnKeyType'] : 'done';
      switch (temp.runtimeType) {
        case String:
          switch (temp) {
            case "done":
              textInputAction = TextInputAction.done;
              break;
            case "go":
              textInputAction = TextInputAction.go;
              break;
            case "next":
              textInputAction = TextInputAction.next;
              break;
            case "previous":
              textInputAction = TextInputAction.previous;
              break;
            case "search":
              textInputAction = TextInputAction.search;
              break;
            case "send":
              textInputAction = TextInputAction.send;
              break;
          }
      }
      //帮助文本
      temp = data.containsKey('HelpText') ? data['HelpText'] : "";
      if (temp is String && temp.isNotEmpty) {
        helperText = temp;
      }
      //最大行数
      temp = data.containsKey('MaxLines') ? data['MaxLines'] : 1;
      switch (temp.runtimeType) {
        case int:
          maxLines = temp as int;
          break;
        case String:
          try {
            maxLines = int.parse(temp as String);
          } catch (e) {
            maxLines = 1;
          }
          break;
      }
      //最大长度
      temp = data.containsKey('MaxLength') ? data['MaxLength'] : 'null';
      switch (temp.runtimeType) {
        case int:
          maxLength = temp as int;
          break;
        case String:
          try {
            maxLength = int.parse(temp as String);
          } catch (e) {
            maxLength = null;
          }
          break;
      }
      //是否自动获取焦点
      temp = data.containsKey('Autofocus') ? data['Autofocus'] : false;
      switch (temp.runtimeType) {
        case bool:
          autofocus = temp as bool;
          break;
        case String:
          if (temp == "true") {
            autofocus = true;
          } else if (temp == "false") {
            autofocus = false;
          }
          break;
      }
      //是否为文件
      temp = data.containsKey('IsFile') ? data['IsFile'] : false;
      switch (temp.runtimeType) {
        case bool:
          isFile = temp as bool;
          break;
        case String:
          if (temp == "true") {
            isFile = true;
          } else if (temp == "false") {
            isFile = false;
          }
          break;
      }
      //文件扩展名
      temp = data.containsKey('FileExt') ? data['FileExt'] : [];
      switch (temp.runtimeType) {
        case List:
        case List<String>:
        case List<dynamic>:
        case List<Object>:
          for (dynamic ext in (temp as List)) {
            if (ext.runtimeType == String && ext.toString().isNotEmpty) {
              fileExt.add(ext.toString());
            }
          }
          break;
      }

      TextEditingController controller = TextEditingController.fromValue(
        TextEditingValue(
          text: val,
          selection: TextSelection.fromPosition(
            TextPosition(
              affinity: TextAffinity.downstream,
              offset: val.length,
            ),
          ),
        ),
      );
      c = Semantics(
        textField: true,
        child: WeTextField(
          controller: controller,
          id: id,
          value: val,
          onChanged: onChanged,
          style: tsMain,
          readOnly: readOnly,
          labelText: label.isEmpty
              ? null
              : (label + (isDev && key.isNotEmpty ? " - $key" : "")),
          labelStyle: tsMain,
          hintText: hintText.isEmpty ? null : hintText,
          hintStyle: tsGroupTag,
          helpText: helperText,
          helpStyle: null,
          fillColor: fillColor,
          border: InputBorder.none,
          autocorrect: autoCorrect,
          textCapitalization: autoCapitalization,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          minLines: 1,
          maxLines: maxLines,
          maxLength: maxLength,
          autofocus: autofocus,
          visibilitySemantics: visibilitySemantics,
          clearSemantics: clearSemantics,
          onSubRegExp: regExp,
          isDark: isDark,
        ),
      );
      if (isFile) {
        c = Row(
          children: [
            Expanded(child: c),
            IconButton(
              icon: Icon(
                Icons.folder_open,
                color: !isDark ? Colors.black54 : null,
              ),
              onPressed: () => openFile!(id, fileExt),
            ),
          ],
        );
      }
      break;
    case "PSSliderSpecifier": //滑动条(Slider)
      String key = data.containsKey("Key") ? data["Key"] : ""; //键
      double val = 0; //当前值
      double min = 0; //最小值
      double max = 100; //最大值
      int? divisions; //分段数
      int accuracy = 0; //分段数
      // String label = ""; //默认值标签
      Color activeColor = Colors.blue; //激活颜色
      Color inactiveColor = Colors.grey; //未激活颜色
      //最小值
      Object temp =
          data.containsKey("MinimumValue") ? data["MinimumValue"] : 0.0;
      switch (temp.runtimeType) {
        case double:
          min = temp as double;
          break;
        case int:
          min = (temp as int).toDouble();
          break;
        case String:
          try {
            min = double.parse(temp as String);
          } catch (e) {
            min = 0;
          }
          break;
      }
      //最大值
      temp = data.containsKey("MaximumValue") ? data["MaximumValue"] : 100.0;
      switch (temp.runtimeType) {
        case double:
          max = temp as double;
          break;
        case int:
          max = (temp as int).toDouble();
          break;
        case String:
          try {
            max = double.parse(temp as String);
          } catch (e) {
            max = 100;
          }
          break;
      }
      //当前值,如果val不存在,则使用DefaultValue
      temp = data.containsKey("Value")
          ? data["Value"]
          : data.containsKey("DefaultValue")
              ? data["DefaultValue"]
              : false;
      switch (temp.runtimeType) {
        case double:
          val = temp as double;
          break;
        case int:
          val = (temp as int).toDouble();
          break;
        case String:
          try {
            val = double.parse(temp as String);
          } catch (e) {
            val = 0;
          }
      }
      //分段数
      temp = data.containsKey("NumberOfSteps") ? data["NumberOfSteps"] : 'null';
      switch (temp.runtimeType) {
        case int:
          divisions = temp as int;
          break;
        case String:
          try {
            divisions = int.parse(temp as String);
          } catch (e) {
            divisions = null;
          }
          break;
      }
      //默认值标签
      // temp = data.containsKey("DefaultValue") ? data["DefaultValue"] : "";
      // switch(temp.runtimeType){
      //   case String:
      //     label = temp as String;
      //     break;
      //     case int:

      // }
      //精度
      temp = data.containsKey("Accuracy") ? data["Accuracy"] : 0;
      switch (temp.runtimeType) {
        case int:
          accuracy = temp as int;
          break;
        case double:
          accuracy = int.parse((temp as double).toStringAsFixed(0));
          break;
        case String:
          try {
            accuracy = int.parse(temp as String);
          } catch (e) {
            accuracy = 0;
          }
          break;
      }
      //激活颜色
      temp = data.containsKey("activeColor") ? data["activeColor"] : 'null';
      switch (temp.runtimeType) {
        case String:
          temp = colorStrHanlder(temp as String);
          if (temp != -1) {
            activeColor = Color(temp);
          }
          break;
      }
      //未激活颜色
      temp = data.containsKey("inactiveColor") ? data["inactiveColor"] : 'null';
      switch (temp.runtimeType) {
        case String:
          temp = colorStrHanlder(temp as String);
          if (temp != -1) {
            inactiveColor = Color(temp);
          }
          break;
      }

      int titleMaxLines = 1;
      List<String> texts = [title];
      List<TextStyle> styles = [tsMaincalculate];
      if (isDev && key.isNotEmpty) {
        texts.add(key);
        styles.add(tsGroupTagcalculate);
      }
      double titleWidth = calculateMaxTextWidth(texts, styles);
      double cellWidth = weWidth - 107;
      if (titleWidth > cellWidth / 3) {
        titleWidth = cellWidth / 3 + 12;
        titleMaxLines = 99;
      }
      double titleHeight = calculateTextHeight(
        title,
        tsMaincalculate,
        titleWidth,
        maxLines: titleMaxLines,
      );
      double valWidth = cellWidth - titleWidth;
      double valTxtWidth =
          calculateMaxTextWidth([max.toStringAsFixed(accuracy)], styles);
      double sliderWidth = valWidth - valTxtWidth / 2 + 10;
      if (sliderWidth < 150) {
        sliderWidth += 20;
      } else if (sliderWidth < 500) {
        sliderWidth += 10;
      }
      c = SizedBox(
        width: cellWidth,
        height: titleHeight,
        child: Semantics(
          slider: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title.isNotEmpty)
                    SizedBox(
                      width: titleWidth,
                      height: titleHeight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: tsMain,
                          maxLines: titleMaxLines,
                        ),
                      ),
                    ),
                  if (isDev && key.isNotEmpty)
                    Text(
                      key,
                      style: tsGroupTag,
                    ),
                ],
              ),
              SizedBox(
                width: valWidth,
                child: Stack(
                  children: [
                    SizedBox(
                      width: sliderWidth,
                      child: Transform.translate(
                        offset: const Offset(-10, 0),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2.0,
                          ),
                          child: Slider(
                            label: val.toStringAsFixed(accuracy),
                            value: val,
                            min: min,
                            max: max,
                            divisions: divisions,
                            activeColor: activeColor,
                            inactiveColor: inactiveColor,
                            onChanged: (val) => onChanged(id, val, false),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: valTxtWidth,
                        height: titleHeight,
                        child: Center(
                          child: Text(
                            val.toStringAsFixed(accuracy),
                            style: tsMain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      break;
    case "PSTimePickerSpecifier": //时间选择框
      String key = data.containsKey("Key") ? data["Key"] : ""; //键
      bool isReadonly =
          data.containsKey("IsReadonly") ? data["IsReadonly"] : false;
      String val = data.containsKey("Value") ? data["Value"] : ""; //内容

      const int maxLine = 99;
      List<String> texts = [title];
      List<TextStyle> styles = [tsMaincalculate];
      if (isDev && key.isNotEmpty) {
        texts.add(key);
        styles.add(tsGroupTagcalculate);
      }
      double titleWidth = calculateMaxTextWidth(texts, styles);
      double cellWidth = weWidth - 135;
      int titleMaxLines = 1;
      if (titleWidth > cellWidth / 2 && val.isNotEmpty) {
        titleWidth = weWidth - 190;
        titleMaxLines = 99;
      }
      double titleHeight = calculateTextHeight(
          title, tsMaincalculate, titleWidth,
          maxLines: titleMaxLines);
      c = SizedBox(
        height: titleHeight,
        child: Semantics(
          child: InkWell(
            onTap: isReadonly
                ? null
                : () async {
                    DateTime valTime = DateTime.now();
                    try {
                      // 将时间字符串转换为 DateTime 对象
                      final now = DateTime.now();
                      final timeParts = val.split(":");
                      final hours = int.parse(timeParts[0]);
                      final minutes = int.parse(timeParts[1]);
                      valTime = DateTime(
                          now.year, now.month, now.day, hours, minutes);
                    } catch (e) {
                      // print(">> ERROR: $e");
                    }
                    TimeOfDay valTD = TimeOfDay.fromDateTime(valTime);

                    TimeOfDay? selectedTime = await weTimePicker(
                      context,
                      valTD,
                    );
                    if (selectedTime == null) {
                      return;
                    }
                    onChanged(
                        id,
                        "${"${selectedTime.hour}".padLeft(2, "0")}:${"${selectedTime.minute}".padLeft(2, "0")}",
                        false);
                  },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title.isNotEmpty)
                      SizedBox(
                        width: titleWidth,
                        height: titleHeight,
                        child: Text(
                          title,
                          style: tsMain,
                          maxLines: maxLine,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (isDev && key.isNotEmpty)
                      Text(
                        key,
                        style: tsGroupTag,
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(Icons.schedule),
                ExcludeSemantics(
                  child: Text(
                    val,
                    style: tsMain,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      break;
    default: //其他
      String key = data.containsKey("Key") ? data["Key"] : ""; //键
      dynamic temp = data.containsKey("Value") ? data["Value"] : "";
      String val = "";
      bool isReadonly =
          data.containsKey("IsReadonly") ? data["IsReadonly"] : false;
      if (temp is String && temp.isEmpty) {
        temp = data.containsKey("DefaultValue") ? data["DefaultValue"] : "";
        if (temp is String && temp.isEmpty) {
          val = "";
        } else {
          val = handleValueRODefaultValue(data, temp);
        }
      } else {
        val = handleValueRODefaultValue(data, temp);
      }
      const int maxLine = 99;
      List<String> texts = [title];
      List<TextStyle> styles = [tsMaincalculate];
      if (isDev && key.isNotEmpty) {
        texts.add(key);
        styles.add(tsGroupTagcalculate);
      }
      double titleWidth = calculateMaxTextWidth(texts, styles);
      double valWidth = calculateMaxTextWidth([val], styles);
      if (valWidth != 0) {
        valWidth += 10;
      }
      double cellWidth = weWidth - 107;
      int titleMaxLines = 1;
      if (valWidth > cellWidth / 2) {
        valWidth = cellWidth / 2;
        if (titleWidth > cellWidth / 2 && val.isNotEmpty) {
          titleWidth = cellWidth / 2 + 12;
          titleMaxLines = 99;
        }
        valWidth = cellWidth - titleWidth;
      } else {
        if (titleWidth > cellWidth) {
          titleMaxLines = 99;
          titleWidth = cellWidth - valWidth;
          if (valWidth != 0) {
            titleWidth -= 30;
          }
        }
      }
      if (!isReadonly && (titleValues != null)) {
        titleWidth = cellWidth / 2;
        valWidth = cellWidth / 2;
      }
      double titleHeight = calculateTextHeight(
          title, tsMaincalculate, titleWidth,
          maxLines: titleMaxLines);
      if (valWidth < 0) valWidth = 0;
      TextAlign valAlign = TextAlign.right;
      if (valWidth < calculateTextWidth(val, tsMaincalculate)) {
        valAlign = TextAlign.left;
      }
      if (valWidth > cellWidth / 2 - 20) {
        valWidth = valWidth - 30;
      }
      c = Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 6),
        child: SizedBox(
          height: titleHeight,
          child: Semantics(
            container: true,
            selected: (childs != null || file != null || titleValues != null),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title.isNotEmpty)
                      SizedBox(
                        width: titleWidth,
                        height: titleHeight,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title,
                            style: tsMain,
                            maxLines: maxLine,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    if (isDev && key.isNotEmpty)
                      Text(
                        key,
                        style: tsGroupTag,
                      ),
                  ],
                ),
                if (val.isNotEmpty) const SizedBox(width: 8),
                if (val.isNotEmpty)
                  SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: valWidth,
                          child: Text(
                            val,
                            style: tsMainVal,
                            textAlign: valAlign,
                            maxLines: maxLine,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isReadonly &&
                            (childs != null ||
                                file != null ||
                                titleValues != null))
                          const SizedBox(width: 5),
                        if (!isReadonly &&
                            (childs != null ||
                                file != null ||
                                titleValues != null))
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            weight: 1000,
                            color: Colors.grey[500]!,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
  }
  return c;
}

///颜色字符串处理
int colorStrHanlder(String colorStr) {
  if (colorStr.length < 6 || colorStr.length > 10) return -1;
  List<String> colorStrList = colorStr.split("x");
  if (colorStrList.length < 2) {
    switch (colorStr.length) {
      case 6:
        colorStr = '0xff$colorStr';
        break;
      case 8:
        colorStr = '0x$colorStr';
        break;
      default:
    }
    colorStr = colorStrList[1];
  }
  int color = 0;
  try {
    color = int.parse(colorStr);
  } catch (e) {
    color = -1;
  }
  return color;
}

double calculateMaxTextWidth(List<String> texts, List<TextStyle> styles) {
  double max = 0;
  for (int i = 0; i < texts.length; i++) {
    if (i >= styles.length) {
      continue;
    }
    double width = calculateTextWidth(texts[i], styles[i]);
    if (width > max) {
      max = width;
    }
  }
  return max;
}

double calculateTextWidth(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.width;
}

double calculateTextHeight(String text, TextStyle style, double maxWidth,
    {int maxLines = 1}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: maxWidth);
  return textPainter.height;
}

String doubleToStr(double? value) {
  if (value == null) return "";
  final intValue = value.toInt();
  return intValue == value ? intValue.toString() : value.toStringAsFixed(1);
}

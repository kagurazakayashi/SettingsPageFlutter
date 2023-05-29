import "package:flutter/material.dart";
import "package:settingspageflutter/widget/material/we_TextField.dart";

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
  Map<String, dynamic> data,
  final Function(String key, dynamic value, bool isTip) onChanged,
) {
  late Widget c;
  String id = data.containsKey("Key") ? data["Key"] : "";
  String? title = data.containsKey("Title") ? data["Title"] : null;
  String type = data.containsKey("Type") ? data["Type"] : "";
  List<Map<String, dynamic>>? childs =
      data.containsKey("Childs") ? data["Childs"] : null;
  String? file = data.containsKey("File") ? data["File"] : null;
  List<Map<String, dynamic>>? titleValues =
      data.containsKey("TitleValues") ? data["TitleValues"] : null;

  //根据类型返回控件
  switch (type) {
    case "PSToggleSwitchSpecifier": //开关(Switch)
      Object temp = data.containsKey("Value")
          ? data["Value"]
          : data.containsKey("DefaultValue")
              ? data["DefaultValue"]
              : false;
      bool val = false;

      switch (temp.runtimeType) {
        case bool:
          val = temp as bool;
          break;
        case String:
          if (temp == "true") {
            val = true;
          } else if (temp == "false") {
            val = false;
          }
          break;
      }
      c = SizedBox(
        height: 55,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (title != null)
              Text(
                title,
                style: tsMain,
              ),
            const SizedBox(width: 8),
            Switch(value: val, onChanged: (val) => onChanged(id, val, false))
          ],
        ),
      );
      break;
    case "PSTextFieldSpecifier": //文本框(TextField)
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
      TextInputType keyboardType = TextInputType.text; //键盘样式
      TextInputAction textInputAction = TextInputAction.done; //键盘回车键样式
      int maxLines = 1; //最大行数
      int? maxLength; //最大长度
      bool autofocus = false; //是否自动获取焦点

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
      c = WeTextField(
        controller: controller,
        id: id,
        value: val,
        onChanged: onChanged,
        style: tsMain,
        readOnly: readOnly,
        labelText: label.isEmpty ? null : label,
        labelStyle: tsMain,
        hintText: hintText.isEmpty ? null : hintText,
        hintStyle: tsGroupTag,
        border: InputBorder.none,
        autocorrect: autoCorrect,
        textCapitalization: autoCapitalization,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        minLines: 1,
        maxLines: maxLines,
        maxLength: maxLength,
        autofocus: autofocus,
        onSubmitted: (val) => onChanged(id, val, true),
      );
      break;
    case "PSSliderSpecifier": //滑动条(Slider)
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

      c = SizedBox(
        height: 55,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (title != null)
              Text(
                title,
                style: tsMain,
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Slider(
                      value: val,
                      min: min,
                      max: max,
                      divisions: divisions,
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      onChanged: (val) => onChanged(id, val, false),
                    ),
                  ),
                  Text(val.toStringAsFixed(accuracy), style: tsMain),
                ],
              ),
            )
          ],
        ),
      );
      break;
    default: //其他
      dynamic temp = data.containsKey("Value") ? data["Value"] : "";
      String val = "";
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
      c = Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: SizedBox(
          height: 39,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title != null)
                Text(
                  title,
                  style: tsMain,
                ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    val,
                    style: tsMainVal,
                  ),
                  if (childs != null || file != null || titleValues != null)
                    const SizedBox(width: 5),
                  if (childs != null || file != null || titleValues != null)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      weight: 1000,
                      color: Colors.grey[500]!,
                    ),
                ],
              )
            ],
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

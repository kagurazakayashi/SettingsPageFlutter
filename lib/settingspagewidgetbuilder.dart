library settingspageflutter;

import 'package:flutter/material.dart';

class SettingsPageWidgetBuilder {
  // 键盘类型 (keyboardType)

  Map<String, TextInputType> keyboardType = {
    "Default": TextInputType.text, // 文字鍵盤
    "Numbers and Punctuation": TextInputType.number, // 數字鍵盤
    "URL": TextInputType.url, // 網址鍵盤
    "Number Pad": TextInputType.phone, // 電話鍵盤
    "Email Address": TextInputType.emailAddress, // 電子郵件鍵盤
    "Multi Line": TextInputType.multiline, // 多行文字鍵盤
  };

  // 分組 (Group)

  TextStyle uiGroupStyle = const TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  Text uiGroup(String title) {
    return Text(
      title,
      style: uiGroupStyle,
    );
  }

  // 標題框 (Title)

  TextStyle uiTitleStyle = const TextStyle();

  Text uiTitle(String title) {
    return Text(
      title,
      style: uiTitleStyle,
    );
  }

  // 滑動條 (Slider)

  Map<String, dynamic> uiSliderStyle = {};

  Slider uiSlider(Map<String, dynamic> config) {
    return Slider(
      value: config["Default Value"] ?? 0,
      min: config["Minimum Value"] ?? 0,
      max: config["Maximum Value"] ?? 100,
      divisions: config["NumberOfSteps"] ?? 1,
      label: config["DefaultValue"]?.toString() ?? "",
      onChanged: (double value) {},
      onChangeEnd: (double value) {},
      activeColor: uiSliderStyle["activeColor"] ?? Colors.blue,
      inactiveColor: uiSliderStyle["inactiveColor"] ?? Colors.grey,
    );
  }

  // 文字輸入框 (TextField)

  Map<String, dynamic> uiTextFieldStyle = {};
  TextStyle uiTextFieldTextStyle = const TextStyle();

  /// return: List<[TextEditingController], [TextField]>
  List<dynamic> uiTextField(Map<String, dynamic> config) {
    TextEditingController controller = TextEditingController();
    TextField textField = TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: config["Title"] ?? "",
        hintText: config["Hint Text"] ?? config["Default Value"] ?? "",
        labelStyle: uiTextFieldTextStyle,
      ),
      autocorrect: config["Autocorrection Style"] ?? true,
      // textCapitalization: TextCapitalization.characters,
      obscureText: config["Text Field Is Secure"] ?? false,
      keyboardType: keyboardType[config["Keyboard Type"] ?? "Default"] ?? TextInputType.text,
    );
    return [controller, textField];
  }

  // 開關 (Toggle Switch)

  Map<String, dynamic> uiSwitchStyle = {};

  Switch uiSwitch(Map<String, dynamic> config) {
    return Switch(
      value: config["Default Value"] ?? false,
      onChanged: (bool value) {},
      activeColor: uiSwitchStyle["activeColor"] ?? Colors.blue,
      activeTrackColor: uiSwitchStyle["activeTrackColor"] ?? Colors.blue,
      inactiveThumbColor: uiSwitchStyle["inactiveThumbColor"] ?? Colors.grey,
      inactiveTrackColor: uiSwitchStyle["inactiveTrackColor"] ?? Colors.grey,
    );
  }
}

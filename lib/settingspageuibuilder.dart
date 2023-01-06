library settingspageflutter;

import 'package:flutter/material.dart';

class SettingsPageUIBuilder {
  TextField psTextFieldSpecifier(Map<String, dynamic> config) {
    return TextField(
      decoration: InputDecoration(
        labelText: config["Title"] ?? "",
        hintText: config["DefaultValue"] ?? "",
      ),
      keyboardType: TextInputType.text,
    );
  }
}

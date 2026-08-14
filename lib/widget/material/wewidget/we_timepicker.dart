import 'package:flutter/material.dart';

Future<TimeOfDay?> weTimePicker(
    BuildContext context, TimeOfDay defaultTime) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: defaultTime,
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );

  if (picked != null && picked != defaultTime) {
    return picked;
  }
  return null;
}

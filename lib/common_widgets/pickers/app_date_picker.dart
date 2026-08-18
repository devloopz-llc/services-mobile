import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Shows the platform-native date picker: a [CupertinoDatePicker] sliding
/// up in a sheet on iOS, the Material [showDatePicker] dialog on Android.
/// Returns the picked date, or `null` if cancelled.
Future<DateTime?> showAppDatePicker(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final isIOS = !kIsWeb && Platform.isIOS;
  final initial = initialDate ?? DateTime.now();
  final min = firstDate ?? DateTime.now().subtract(const Duration(days: 365));
  final max = lastDate ?? DateTime.now().add(const Duration(days: 365));

  if (isIOS) {
    DateTime picked = initial;
    final scheme = Theme.of(context).colorScheme;

    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) {
        return Container(
          height: 320,
          color: scheme.surface,
          child: Column(
            children: [
              SizedBox(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () => Navigator.of(context).pop(picked),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initial,
                  minimumDate: min,
                  maximumDate: max,
                  onDateTimeChanged: (value) => picked = value,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: min,
    lastDate: max,
  );
}

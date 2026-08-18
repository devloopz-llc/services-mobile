import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Reusable labeled dropdown field.
///
/// Tapping it opens the platform-native picker: a [CupertinoPicker] wheel
/// sliding up from the bottom on iOS, a Material dropdown menu on Android.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.itemLabel,
    this.value,
    this.label,
    this.hint = 'Select',
    this.onChanged,
  });

  final List<T> items;
  final String Function(T item) itemLabel;
  final T? value;
  final String? label;
  final String hint;
  final ValueChanged<T>? onChanged;

  bool get _isIOS => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
        ],
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: items.isEmpty ? null : () => _openPicker(context),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null ? itemLabel(value as T) : hint,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: value != null ? scheme.onSurface : scheme.onSurfaceVariant,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  _isIOS ? CupertinoIcons.chevron_down : Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openPicker(BuildContext context) {
    if (_isIOS) {
      _openCupertinoPicker(context);
    } else {
      _openMaterialSheet(context);
    }
  }

  void _openCupertinoPicker(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    var selectedIndex = value != null ? items.indexOf(value as T) : 0;
    if (selectedIndex < 0) selectedIndex = 0;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return Container(
          height: 260,
          color: scheme.surface,
          child: Column(
            children: [
              SizedBox(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () {
                        onChanged?.call(items[selectedIndex]);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                  onSelectedItemChanged: (index) => selectedIndex = index,
                  children: items.map((item) => Center(child: Text(itemLabel(item)))).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openMaterialSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(itemLabel(item)),
                trailing: item == value ? const Icon(Icons.check_rounded) : null,
                onTap: () {
                  onChanged?.call(item);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }
}

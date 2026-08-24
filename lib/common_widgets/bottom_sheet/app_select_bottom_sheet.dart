import 'dart:async';

import 'package:flutter/material.dart';

import '../feedback/app_loading_indicator.dart';
import '../inputs/app_text_field.dart';

/// Bottom sheet list picker with a search field — for any dropdown whose
/// options come from the API (trade categories, addresses, and similar
/// lookups) rather than a short fixed list. For a handful of static options,
/// prefer [AppDropdown]'s lighter picker instead.
///
/// Pass [onSearch] to query the backend as the user types (debounced 350ms);
/// omit it to filter [items] locally by [itemLabel].
Future<T?> showAppSelectBottomSheet<T>({
  required BuildContext context,
  required List<T> items,
  required String Function(T item) itemLabel,
  String Function(T item)? itemSubtitle,
  Widget Function(BuildContext context, T item)? leadingBuilder,
  String? title,
  T? selected,
  String searchHint = 'Search',
  Future<List<T>> Function(String query)? onSearch,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _SelectSheet<T>(
      items: items,
      itemLabel: itemLabel,
      itemSubtitle: itemSubtitle,
      leadingBuilder: leadingBuilder,
      title: title,
      selected: selected,
      searchHint: searchHint,
      onSearch: onSearch,
    ),
  );
}

class _SelectSheet<T> extends StatefulWidget {
  const _SelectSheet({
    required this.items,
    required this.itemLabel,
    required this.searchHint,
    this.itemSubtitle,
    this.leadingBuilder,
    this.title,
    this.selected,
    this.onSearch,
  });

  final List<T> items;
  final String Function(T item) itemLabel;
  final String Function(T item)? itemSubtitle;
  final Widget Function(BuildContext context, T item)? leadingBuilder;
  final String? title;
  final T? selected;
  final String searchHint;
  final Future<List<T>> Function(String query)? onSearch;

  @override
  State<_SelectSheet<T>> createState() => _SelectSheetState<T>();
}

class _SelectSheetState<T> extends State<_SelectSheet<T>> {
  final _searchController = TextEditingController();
  late List<T> _results = widget.items;
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    if (widget.onSearch == null) {
      setState(() {
        _results = query.trim().isEmpty
            ? widget.items
            : widget.items
                .where((item) => widget.itemLabel(item).toLowerCase().contains(query.trim().toLowerCase()))
                .toList();
      });
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      setState(() => _isSearching = true);
      final results = await widget.onSearch!(query.trim());
      if (!mounted) return;
      setState(() {
        _results = results;
        _isSearching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 120),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.title != null) ...[
                        Text(widget.title!, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 14),
                      ],
                      AppTextField(
                        controller: _searchController,
                        hint: widget.searchHint,
                        autofocus: false,
                        prefixIcon: Icon(Icons.search_rounded, color: scheme.onSurfaceVariant),
                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _searchController,
                          builder: (context, value, _) {
                            if (value.text.isEmpty) return const SizedBox.shrink();
                            return IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () {
                                _searchController.clear();
                                _onQueryChanged('');
                              },
                            );
                          },
                        ),
                        onChanged: _onQueryChanged,
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildBody(context, scrollController)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ScrollController scrollController) {
    final scheme = Theme.of(context).colorScheme;

    if (_isSearching) {
      return const Center(child: AppLoadingIndicator());
    }

    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No results found',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      itemCount: _results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 2),
      itemBuilder: (context, index) {
        final item = _results[index];
        final isSelected = widget.selected != null && widget.itemLabel(item) == widget.itemLabel(widget.selected as T);

        return ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          leading: widget.leadingBuilder?.call(context, item),
          title: Text(widget.itemLabel(item)),
          subtitle: widget.itemSubtitle != null ? Text(widget.itemSubtitle!(item)) : null,
          trailing: isSelected ? Icon(Icons.check_rounded, color: scheme.primary) : null,
          onTap: () => Navigator.of(context).pop(item),
        );
      },
    );
  }
}

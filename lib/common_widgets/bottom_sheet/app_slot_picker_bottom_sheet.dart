import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../buttons/app_button.dart';

/// What the slot picker resolved to: either "as soon as possible" (both
/// timestamps null, matching how the booking API represents ASAP — see
/// `requested_slot_starts_at`/`requested_slot_ends_at` in the customer job
/// endpoint) or a specific window.
class TimeSlotSelection {
  const TimeSlotSelection.asap() : isAsap = true, startsAt = null, endsAt = null;

  const TimeSlotSelection.window(DateTime start, DateTime end)
      : isAsap = false,
        startsAt = start,
        endsAt = end;

  final bool isAsap;
  final DateTime? startsAt;
  final DateTime? endsAt;
}

/// Custom-designed date/time picker: a bottom sheet with an "ASAP" card, a
/// horizontally scrolling row of date chips, and a grid of time-of-day
/// chips — not a calendar grid. Deliberately branded rather than the native
/// date picker, for booking a visit/appointment window specifically.
Future<TimeSlotSelection?> showAppSlotPickerBottomSheet({
  required BuildContext context,
  int dayCount = 6,
  List<TimeOfDay> timeSlots = const [
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
  ],
  Duration slotDuration = const Duration(hours: 2),
}) {
  return showModalBottomSheet<TimeSlotSelection>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _SlotPickerSheet(
      dayCount: dayCount,
      timeSlots: timeSlots,
      slotDuration: slotDuration,
    ),
  );
}

class _SlotPickerSheet extends StatefulWidget {
  const _SlotPickerSheet({
    required this.dayCount,
    required this.timeSlots,
    required this.slotDuration,
  });

  final int dayCount;
  final List<TimeOfDay> timeSlots;
  final Duration slotDuration;

  @override
  State<_SlotPickerSheet> createState() => _SlotPickerSheetState();
}

class _SlotPickerSheetState extends State<_SlotPickerSheet> {
  bool _isAsap = true;
  late final List<DateTime> _days = List.generate(
    widget.dayCount,
    (index) => DateTime.now().add(Duration(days: index)),
  );
  late DateTime _selectedDay = _days.first;
  TimeOfDay? _selectedTime;

  bool get _canContinue => _isAsap || _selectedTime != null;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 48),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: scheme.outline, borderRadius: BorderRadius.circular(2)),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select a time', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    _AsapCard(selected: _isAsap, onTap: () => setState(() => _isAsap = true)),
                    const SizedBox(height: 20),
                    Text('Choose a date', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    _DateChipRow(
                      days: _days,
                      selectedDay: _selectedDay,
                      onSelected: (day) => setState(() {
                        _isAsap = false;
                        _selectedDay = day;
                      }),
                    ),
                    const SizedBox(height: 20),
                    Text('Choose a time', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    _TimeChipGrid(
                      times: widget.timeSlots,
                      selectedTime: _isAsap ? null : _selectedTime,
                      onSelected: (time) => setState(() {
                        _isAsap = false;
                        _selectedTime = time;
                      }),
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      label: 'Continue',
                      onPressed: _canContinue ? () => Navigator.of(context).pop(_buildSelection()) : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TimeSlotSelection _buildSelection() {
    if (_isAsap) return const TimeSlotSelection.asap();
    final time = _selectedTime!;
    final start = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, time.hour, time.minute);
    return TimeSlotSelection.window(start, start.add(widget.slotDuration));
  }
}

class _AsapCard extends StatelessWidget {
  const _AsapCard({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? scheme.primary : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
              child: Icon(Icons.bolt_rounded, color: scheme.onPrimary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ASAP', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: scheme.onPrimaryContainer)),
                  Text(
                    'The earliest available slot today',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onPrimaryContainer),
                  ),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle_rounded, color: scheme.primary),
          ],
        ),
      ),
    );
  }
}

class _DateChipRow extends StatelessWidget {
  const _DateChipRow({required this.days, required this.selectedDay, required this.onSelected});

  final List<DateTime> days;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onSelected;

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final today = DateTime.now();

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = _isSameDay(day, selectedDay);
          final isToday = _isSameDay(day, today);

          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onSelected(day),
            child: Container(
              width: 64,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? scheme.primary : scheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isSelected ? scheme.primary : scheme.outline),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isToday ? 'Today' : DateFormat('EEE').format(day),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isSelected ? scheme.onPrimary : scheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('d MMM').format(day),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isSelected ? scheme.onPrimary : scheme.onSurface,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TimeChipGrid extends StatelessWidget {
  const _TimeChipGrid({required this.times, required this.selectedTime, required this.onSelected});

  final List<TimeOfDay> times;
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onSelected;

  String _label(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: times.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.4,
      ),
      itemBuilder: (context, index) {
        final time = times[index];
        final isSelected = selectedTime == time;

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onSelected(time),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? scheme.primary : scheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? scheme.primary : scheme.outline),
            ),
            child: Text(
              _label(time),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected ? scheme.onPrimary : scheme.onSurface,
                  ),
            ),
          ),
        );
      },
    );
  }
}

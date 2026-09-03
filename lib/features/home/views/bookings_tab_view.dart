import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/cards/booking_card.dart';
import '../../../common_widgets/misc/app_segmented_tabs.dart';
import '../controller/bookings_controller.dart';

class BookingsTabView extends GetView<BookingsController> {
  const BookingsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bookings', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                Obx(
                  () => AppSegmentedTabs(
                    labels: const ['Upcoming', 'Past'],
                    selectedIndex: controller.selectedTabIndex.value,
                    onChanged: controller.changeTab,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final bookings = controller.selectedTabIndex.value == 0 ? controller.upcoming : controller.past;

              if (bookings.isEmpty) {
                return Center(
                  child: Text(
                    'No bookings here yet.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                itemCount: bookings.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) => BookingCard(
                  booking: bookings[index],
                  onViewDetails: () => controller.viewDetails(bookings[index]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

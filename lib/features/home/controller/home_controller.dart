import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_models/booking_list_item.dart';
import '../../../common_models/service_category.dart';
import '../../../common_widgets/badges/status_badge.dart';
import '../../../core/theme/app_colors.dart';

class HomeController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;
  final TextEditingController searchController = TextEditingController();

  final BookingListItem? currentBooking = _buildCurrentBooking();

  static BookingListItem _buildCurrentBooking() {
    final today = DateTime.now();
    return BookingListItem(
      id: 1,
      title: 'Boiler not heating',
      icon: Icons.thermostat_rounded,
      iconColor: const Color(0xFF2F8F5B),
      statusLabel: 'In progress',
      statusGroup: AppStatusGroup.live,
      startsAt: DateTime(today.year, today.month, today.day, 14),
      endsAt: DateTime(today.year, today.month, today.day, 16),
      addressLine: '12 Oakfield Road, London SW12 8AB',
      technicianName: 'Amir K.',
      technicianRole: 'Heating engineer',
    );
  }

  /// Home only surfaces the most-requested trades; the job-report wizard
  /// shows the full list (see [ServiceCategory.defaults]).
  List<ServiceCategory> featuredCategories(AppColors colors) =>
      ServiceCategory.defaults(colors).take(4).toList();

  void changeTab(int index) => selectedTabIndex.value = index;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

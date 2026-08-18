import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../model/booking_summary.dart';
import '../model/service_category.dart';

class HomeController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;
  final TextEditingController searchController = TextEditingController();

  final BookingSummary? currentBooking = const BookingSummary(
    title: 'Boiler not heating',
    status: 'In progress',
    timeRange: 'Today, 2:00 pm – 4:00 pm',
    technicianName: 'Amir K.',
  );

  List<ServiceCategory> categories(AppColors colors) => [
        ServiceCategory(
          title: 'Plumbing',
          subtitle: 'Leaks, repairs & installations',
          icon: Icons.plumbing_rounded,
          color: colors.categoryBlue,
        ),
        ServiceCategory(
          title: 'Electrical',
          subtitle: 'Faults, sockets & lighting',
          icon: Icons.bolt_rounded,
          color: colors.categoryAmber,
        ),
        ServiceCategory(
          title: 'Heating',
          subtitle: 'Boilers, radiators & servicing',
          icon: Icons.thermostat_rounded,
          color: colors.categoryGreen,
        ),
        ServiceCategory(
          title: 'Handyman',
          subtitle: 'Repairs, fixes & assembly',
          icon: Icons.handyman_rounded,
          color: colors.categoryGrey,
        ),
      ];

  void changeTab(int index) => selectedTabIndex.value = index;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

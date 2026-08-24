import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_models/service_category.dart';
import '../../../core/theme/app_colors.dart';
import '../model/booking_summary.dart';

class HomeController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;
  final TextEditingController searchController = TextEditingController();

  final BookingSummary? currentBooking = const BookingSummary(
    title: 'Boiler not heating',
    status: 'In progress',
    timeRange: 'Today, 2:00 pm – 4:00 pm',
    technicianName: 'Amir K.',
  );

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

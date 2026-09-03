import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_models/booking_list_item.dart';
import '../../../common_widgets/badges/status_badge.dart';
import '../../../core/routes/app_routes.dart';
import '../../job_report/model/job_booking_summary.dart';

class BookingsController extends GetxController {
  final selectedTabIndex = 0.obs;

  final upcoming = [
    BookingListItem(
      id: 101,
      title: 'Boiler repair',
      icon: Icons.thermostat_rounded,
      iconColor: Color(0xFF2F8F5B),
      statusLabel: 'Confirmed',
      statusGroup: AppStatusGroup.confirmed,
      startsAt: DateTime(2025, 5, 26, 10, 0),
      addressLine: '12 Oakfield Road, London SW12 8AB',
      technicianName: 'Amir K.',
      technicianRole: 'Heating engineer',
      pricePence: 12000,
    ),
    BookingListItem(
      id: 102,
      title: 'Kitchen tap leak',
      icon: Icons.plumbing_rounded,
      iconColor: Color(0xFF2E7BE0),
      statusLabel: 'Technician assigned',
      statusGroup: AppStatusGroup.activePipeline,
      startsAt: DateTime(2025, 5, 28, 14, 0),
      addressLine: '12 Oakfield Road, London SW12 8AB',
      technicianName: 'Amir K.',
      technicianRole: 'Plumber',
      pricePence: 9000,
    ),
  ];

  final past = [
    BookingListItem(
      id: 90,
      title: 'Socket replacement',
      icon: Icons.bolt_rounded,
      iconColor: Color(0xFFE0A72E),
      statusLabel: 'Completed',
      statusGroup: AppStatusGroup.confirmed,
      startsAt: DateTime(2025, 5, 17, 11, 30),
      addressLine: '12 Oakfield Road, London SW12 8AB',
      technicianName: 'Amir K.',
      technicianRole: 'Electrician',
      pricePence: 7500,
    ),
  ];

  void changeTab(int index) => selectedTabIndex.value = index;

  void viewDetails(BookingListItem booking) {
    Get.toNamed(
      AppRoutes.bookingDetail,
      arguments: JobBookingSummary(
        referenceCode: 'JOB-${booking.id}',
        categoryTitle: booking.title,
        categoryIcon: booking.icon,
        categoryColor: booking.iconColor,
        description: booking.title,
        addressLine: booking.addressLine,
        postcode: '',
        isEmergency: false,
        isAsap: false,
        slotStart: booking.startsAt,
        slotEnd: booking.endsAt,
        statusLabel: booking.statusLabel,
        statusGroup: booking.statusGroup,
        technicianName: booking.technicianName,
        technicianRole: booking.technicianRole,
        pricePence: booking.pricePence,
      ),
    );
  }
}

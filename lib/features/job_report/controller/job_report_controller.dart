import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common_models/service_category.dart';
import '../../../common_widgets/bottom_sheet/app_slot_picker_bottom_sheet.dart';
import '../../../common_widgets/feedback/app_toast.dart';
import '../../../core/routes/app_routes.dart';
import '../model/job_booking_summary.dart';

/// Drives the 3-step job-report wizard. Field names mirror
/// `POST /customer/jobs` (see customer-api.yaml) so wiring this up to the
/// real endpoint later is a straight mapping, not a rewrite:
/// [selectedCategory] -> `trade_category_id`, [descriptionController] ->
/// `description`, [addressLineController]/[postcodeController] ->
/// `address_line`/`postcode`, [isEmergency] -> `is_emergency`,
/// [slotStart]/[slotEnd] -> `requested_slot_starts_at`/`_ends_at` (both
/// null when [isAsap]).
class JobReportController extends GetxController {
  final Rx<ServiceCategory?> selectedCategory = Rx<ServiceCategory?>(null);

  final descriptionController = TextEditingController();
  final photos = <XFile>[].obs;

  final addressLineController = TextEditingController(text: '31 Kingsway');
  final postcodeController = TextEditingController(text: 'M14 6UH');

  /// Reactive mirrors of the two controllers above, purely so
  /// [AddressSummaryCard] can display live edits inside an [Obx] —
  /// [TextEditingController] itself isn't observable by GetX.
  late final addressLine = addressLineController.text.obs;
  late final postcode = postcodeController.text.obs;

  final isEmergency = false.obs;
  final isAsap = true.obs;
  final slotStart = Rx<DateTime?>(null);
  final slotEnd = Rx<DateTime?>(null);

  /// Shown on the review screen only — not part of `POST /customer/jobs`
  /// today (the endpoint has no separate note field), so it isn't sent
  /// anywhere yet. Decide whether to fold it into `description` or drop it
  /// once this is wired to the real API.
  final noteController = TextEditingController();
  late final note = ''.obs;

  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Arriving from a Home category card carries the category as an
    // argument — skip straight to step 2 instead of asking again.
    final argument = Get.arguments;
    if (argument is ServiceCategory) {
      WidgetsBinding.instance.addPostFrameCallback((_) => selectCategory(argument));
    }
  }

  void selectCategory(ServiceCategory category) {
    selectedCategory.value = category;
    Get.toNamed(AppRoutes.jobDetails);
  }

  void onPhotosChanged(List<XFile> updated) => photos.assignAll(updated);

  void onAddressLineChanged(String value) => addressLine.value = value;

  void onPostcodeChanged(String value) => postcode.value = value;

  void onNoteChanged(String value) => note.value = value;

  void goToScheduleStep() {
    if (descriptionController.text.trim().length < 10) {
      AppToast.error('Tell us a little more about what\'s wrong (at least 10 characters).');
      return;
    }
    Get.toNamed(AppRoutes.jobSchedule);
  }

  void selectAsap() {
    isAsap.value = true;
    slotStart.value = null;
    slotEnd.value = null;
  }

  Future<void> pickTime(BuildContext context) async {
    final selection = await showAppSlotPickerBottomSheet(context: context);
    if (selection == null) return;

    if (selection.isAsap) {
      selectAsap();
    } else {
      isAsap.value = false;
      slotStart.value = selection.startsAt;
      slotEnd.value = selection.endsAt;
    }
  }

  void toggleEmergency(bool value) => isEmergency.value = value;

  void goToReview() {
    if (addressLine.value.trim().isEmpty || postcode.value.trim().isEmpty) {
      AppToast.error('Add your address and postcode to continue.');
      return;
    }
    Get.toNamed(AppRoutes.jobReview);
  }

  Future<void> submit() async {
    final category = selectedCategory.value;
    if (category == null) {
      AppToast.error('Something went wrong — please start again.');
      return;
    }

    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    isSubmitting.value = false;

    final summary = JobBookingSummary(
      referenceCode: 'JOB-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      categoryTitle: category.title,
      categoryIcon: category.icon,
      categoryColor: category.color,
      description: descriptionController.text.trim(),
      addressLine: addressLine.value.trim(),
      postcode: postcode.value.trim(),
      isEmergency: isEmergency.value,
      isAsap: isAsap.value,
      slotStart: slotStart.value,
      slotEnd: slotEnd.value,
    );

    Get.offNamed(AppRoutes.jobReceived, arguments: summary);
  }

  @override
  void onClose() {
    descriptionController.dispose();
    addressLineController.dispose();
    postcodeController.dispose();
    noteController.dispose();
    super.onClose();
  }
}

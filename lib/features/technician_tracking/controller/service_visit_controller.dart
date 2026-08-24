import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/feedback/app_toast.dart';
import '../../../core/routes/app_routes.dart';
import '../../quote/model/quotation.dart';

/// Drives the technician-tracking → quotation → payment flow. Registered
/// once on the entry screen and reused across all three via `Get.find`,
/// same pattern as `JobReportController` for the job-report wizard.
///
/// The quotation shape mirrors the real `QuotationVersion` schema, but
/// payment has nothing to wire up to — the backend has no payment gateway
/// at all yet (see "Known gaps" in the mobile-app-guide). The card fields
/// here are cosmetic only; no card data is sent, stored, or logged
/// anywhere.
class ServiceVisitController extends GetxController {
  final technicianName = 'Amir K.';
  final technicianRole = 'Heating engineer';
  final rating = 4.9;
  final reviewCount = 128;
  final etaMinutes = 12.obs;
  final technicianStatus = 'On the way'.obs;

  final quotation = const Quotation(
    id: 1,
    number: 1,
    pricingType: QuotationPricingType.fixed,
    pricingTypeLabel: 'Fixed price',
    isEstimate: false,
    lineItems: [
      QuotationLineItem(
        type: QuotationLineType.labour,
        typeLabel: 'Labour',
        description: 'Boiler diagnosis and repair',
        quantity: 2,
        unitPricePence: 6000,
        totalPence: 12000,
      ),
      QuotationLineItem(
        type: QuotationLineType.materials,
        typeLabel: 'Materials',
        description: 'Replacement parts',
        quantity: 1,
        unitPricePence: 4800,
        totalPence: 4800,
      ),
      QuotationLineItem(
        type: QuotationLineType.callOut,
        typeLabel: 'Call-out',
        description: 'Standard call-out fee',
        quantity: 1,
        unitPricePence: 6500,
        totalPence: 6500,
      ),
    ],
    netPence: 23300,
    vatPence: 4660,
    totalPence: 27960,
    vatRatePercent: 20,
    validUntil: null,
  );

  final isSubmittingQuoteDecision = false.obs;
  final isProcessingPayment = false.obs;

  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvcController = TextEditingController();
  final cardholderNameController = TextEditingController();

  Future<void> approveQuote() async {
    isSubmittingQuoteDecision.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isSubmittingQuoteDecision.value = false;
    Get.toNamed(AppRoutes.payment);
  }

  Future<void> declineQuote(String? reason) async {
    isSubmittingQuoteDecision.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isSubmittingQuoteDecision.value = false;
    AppToast.info("We've let the office know. They'll be in touch with a revised quote.");
    Get.until((route) => route.settings.name == AppRoutes.bookingDetail);
  }

  Future<void> pay() async {
    if (cardNumberController.text.trim().length < 12 ||
        expiryController.text.trim().isEmpty ||
        cvcController.text.trim().isEmpty ||
        cardholderNameController.text.trim().isEmpty) {
      AppToast.error('Fill in your card details to continue.');
      return;
    }

    isProcessingPayment.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    isProcessingPayment.value = false;

    AppToast.success('Payment received — thanks!');
    await Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvcController.dispose();
    cardholderNameController.dispose();
    super.onClose();
  }
}

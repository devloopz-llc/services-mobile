import 'dart:async';

import 'package:get/get.dart';

import '../../../common_widgets/feedback/app_toast.dart';
import '../../../core/routes/app_routes.dart';

class VerifyOtpController extends GetxController {
  static const _resendWindow = 45;

  late final String phoneNumber = Get.arguments is String ? Get.arguments as String : '';

  final code = ''.obs;
  final secondsLeft = _resendWindow.obs;
  final isSubmitting = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startCountdown();
  }

  void _startCountdown() {
    secondsLeft.value = _resendWindow;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value <= 1) {
        timer.cancel();
        secondsLeft.value = 0;
      } else {
        secondsLeft.value--;
      }
    });
  }

  void onCodeChanged(String value) => code.value = value;

  void resend() {
    if (secondsLeft.value > 0) return;
    _startCountdown();
    AppToast.success('A new code is on its way.');
  }

  Future<void> verify() async {
    if (code.value.length != 6) {
      AppToast.error('Enter the 6-digit code.');
      return;
    }

    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isSubmitting.value = false;
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

import 'package:get/get.dart';

import '../network/api_failure.dart';
import '../network/api_result.dart';
import '../utils/app_message.dart';

/// Base class for feature [GetxController]s that call [ApiClient].
///
/// Wraps any `ApiClient` call with the loading flag + error/success
/// messaging that nearly every screen needs, so feature controllers stay
/// down to just the call itself:
///
/// ```dart
/// class HomeController extends BaseController {
///   final services = <Service>[].obs;
///
///   Future<void> loadServices() async {
///     final data = await callApi(() => ServiceRepository().getServices());
///     if (data != null) services.assignAll(data);
///   }
/// }
/// ```
abstract class BaseController extends GetxController {
  final RxBool isLoading = false.obs;

  /// Runs [apiCall], toggling [isLoading] around it, and returns the
  /// unwrapped data on success or `null` on failure. Errors are shown via
  /// [AppMessage.error] unless [showError] is false; pass [showSuccessMessage]
  /// to also surface the backend's success message, if any.
  Future<T?> callApi<T>(
    Future<ApiResult<T>> Function() apiCall, {
    bool showError = true,
    bool showSuccessMessage = false,
    bool toggleLoading = true,
    void Function(ApiFailure failure)? onError,
  }) async {
    if (toggleLoading) isLoading.value = true;
    T? result;

    final response = await apiCall();
    response.when(
      success: (data, message) {
        result = data;
        if (showSuccessMessage && message != null && message.isNotEmpty) {
          AppMessage.success(message);
        }
      },
      failure: (failure) {
        if (showError) AppMessage.error(failure.message);
        onError?.call(failure);
      },
    );

    if (toggleLoading) isLoading.value = false;
    return result;
  }
}

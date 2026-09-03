import 'package:get/get.dart';

import '../../features/auth/model/app_user.dart';
import '../../features/auth/model/auth_session.dart';
import '../../features/auth/repository/auth_repository.dart';
import '../network/api_result.dart';
import '../network/auth_token_store.dart';

/// App-wide session state — who's signed in, if anyone. Registered once,
/// permanently, at app startup (see `main.dart`), so any screen can read
/// [currentUser] via `Get.find<AuthService>()`.
///
/// Deliberately returns the raw [ApiResult] from [register]/[login] rather
/// than swallowing it, so callers can run it through
/// `BaseController.callApi` and get the same loading/error-toast handling
/// every other API call gets — this class only owns the session
/// side-effect (persist the token, update [currentUser]), not the UI flow.
class AuthService extends GetxController {
  final _repository = AuthRepository();

  final Rx<AppUser?> currentUser = Rx<AppUser?>(null);

  bool get isLoggedIn => currentUser.value != null;

  Future<ApiResult<AuthSession>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final result = await _repository.register(name: name, email: email, password: password, phone: phone);
    await _applySession(result);
    return result;
  }

  Future<ApiResult<AuthSession>> login({required String email, required String password}) async {
    final result = await _repository.login(email: email, password: password);
    await _applySession(result);
    return result;
  }

  Future<void> _applySession(ApiResult<AuthSession> result) async {
    final session = result.dataOrNull;
    if (session == null) return;
    await AuthTokenStore.save(session.token);
    currentUser.value = session.user;
  }

  /// Called once at app startup. Returns true if a stored token still
  /// resolves to a valid session.
  Future<bool> restoreSession() async {
    if (AuthTokenStore.token == null) return false;

    final user = (await _repository.me()).dataOrNull;
    if (user == null) {
      await AuthTokenStore.clear();
      return false;
    }
    currentUser.value = user;
    return true;
  }

  /// Always clears the local session, even if the server call fails —
  /// getting the user signed out on this device shouldn't depend on
  /// network access.
  Future<void> logout() async {
    await _repository.logout();
    await AuthTokenStore.clear();
    currentUser.value = null;
  }
}

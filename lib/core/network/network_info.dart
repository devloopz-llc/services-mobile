import 'package:connectivity_plus/connectivity_plus.dart';

/// Thin wrapper around [Connectivity] so [ApiClient] can fail fast with a
/// clear "no internet" message instead of waiting on a timeout.
class NetworkInfo {
  const NetworkInfo();

  Future<bool> get isConnected async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}

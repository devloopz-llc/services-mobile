import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/constants/app_strings.dart';
import 'core/network/auth_token_store.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/services/auth_service.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthTokenStore.load();
  Get.put(AuthService(), permanent: true);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      defaultTransition: Transition.native,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}

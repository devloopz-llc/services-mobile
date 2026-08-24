import 'package:get/get.dart';

import '../../features/auth/controller/login_controller.dart';
import '../../features/auth/controller/register_controller.dart';
import '../../features/auth/controller/verify_otp_controller.dart';
import '../../features/auth/views/create_account_screen.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/verify_number_screen.dart';
import '../../features/auth/views/welcome_screen.dart';
import '../../features/home/controller/home_controller.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/job_report/controller/job_report_controller.dart';
import '../../features/job_report/views/booking_detail_screen.dart';
import '../../features/job_report/views/job_category_step_screen.dart';
import '../../features/job_report/views/job_details_step_screen.dart';
import '../../features/job_report/views/job_schedule_step_screen.dart';
import '../../features/job_report/views/request_received_screen.dart';
import '../../features/job_report/views/review_request_screen.dart';
import '../../features/payment/views/payment_screen.dart';
import '../../features/quote/views/quotation_screen.dart';
import '../../features/splash/controller/splash_controller.dart';
import '../../features/splash/views/splash_screen.dart';
import '../../features/technician_tracking/controller/service_visit_controller.dart';
import '../../features/technician_tracking/views/technician_tracking_screen.dart';
import 'app_routes.dart';

class AppPages {
  const AppPages._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.put(LoginController());
      }),
    ),
    GetPage(
      name: AppRoutes.createAccount,
      page: () => const CreateAccountScreen(),
      binding: BindingsBuilder(() {
        Get.put(RegisterController());
      }),
    ),
    GetPage(
      name: AppRoutes.verifyNumber,
      page: () => const VerifyNumberScreen(),
      binding: BindingsBuilder(() {
        Get.put(VerifyOtpController());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
    ),
    // Job-report wizard: only the entry step registers JobReportController —
    // the rest of the flow reuses that same instance via Get.find.
    GetPage(
      name: AppRoutes.jobCategory,
      page: () => const JobCategoryStepScreen(),
      binding: BindingsBuilder(() {
        Get.put(JobReportController());
      }),
    ),
    GetPage(name: AppRoutes.jobDetails, page: () => const JobDetailsStepScreen()),
    GetPage(name: AppRoutes.jobSchedule, page: () => const JobScheduleStepScreen()),
    GetPage(name: AppRoutes.jobReview, page: () => const ReviewRequestScreen()),
    GetPage(name: AppRoutes.jobReceived, page: () => const RequestReceivedScreen()),
    GetPage(name: AppRoutes.bookingDetail, page: () => const BookingDetailScreen()),
    // Technician tracking + quote + payment: only the entry step registers
    // ServiceVisitController — the rest reuse that instance via Get.find.
    GetPage(
      name: AppRoutes.technicianTracking,
      page: () => const TechnicianTrackingScreen(),
      binding: BindingsBuilder(() {
        Get.put(ServiceVisitController());
      }),
    ),
    GetPage(name: AppRoutes.quotation, page: () => const QuotationScreen()),
    GetPage(name: AppRoutes.payment, page: () => const PaymentScreen()),
  ];
}

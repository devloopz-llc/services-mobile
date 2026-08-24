abstract class AppRoutes {
  const AppRoutes._();

  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String verifyNumber = '/verify-number';
  static const String home = '/home';

  // Job-report wizard.
  static const String jobCategory = '/job/category';
  static const String jobDetails = '/job/details';
  static const String jobSchedule = '/job/schedule';
  static const String jobReview = '/job/review';
  static const String jobReceived = '/job/received';
  static const String bookingDetail = '/booking/detail';

  // Technician tracking + quote + payment.
  static const String technicianTracking = '/service/technician';
  static const String quotation = '/service/quotation';
  static const String payment = '/service/payment';
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/cards/info_banner.dart';
import '../../../common_widgets/inputs/app_text_field.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/home_controller.dart';
import '../../../common_widgets/cards/service_category_card.dart';
import '../widgets/current_booking_card.dart';

class HomeTabView extends GetView<HomeController> {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = context.appColors;
    final categories = controller.featuredCategories(colors);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text(
            'Welcome to',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          Text('Trusted Trades Manchester', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Reliable help for your home and business.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: controller.searchController,
            hint: 'How can we help today?',
            readOnly: true,
            onTap: () => Get.toNamed(AppRoutes.jobCategory),
            prefixIcon: Icon(Icons.search_rounded, color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) => ServiceCategoryCard(
              category: categories[index],
              onTap: () => Get.toNamed(AppRoutes.jobCategory, arguments: categories[index]),
            ),
          ),
          const SizedBox(height: 20),
          const InfoBanner(
            title: 'Verified local professionals',
            message: 'Background checked, insured and rated by customers like you.',
            variant: InfoBannerVariant.success,
          ),
          if (controller.currentBooking != null) ...[
            const SizedBox(height: 20),
            Text('Your current booking', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            CurrentBookingCard(
              booking: controller.currentBooking!,
              onTap: () => Get.toNamed(AppRoutes.technicianTracking),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/misc/settings_list_tile.dart';
import '../controller/account_controller.dart';
import '../widgets/profile_header_card.dart';

class AccountTabView extends GetView<AccountController> {
  const AccountTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text('Account', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          Obx(() {
            final user = controller.authService.currentUser.value;
            return ProfileHeaderCard(
              name: user?.name ?? '',
              email: user?.email ?? '',
              phone: user?.phone ?? '',
              onTap: () => controller.openComingSoon('Personal details'),
            );
          }),
          const SizedBox(height: 24),
          SettingsSection(
            title: 'Account',
            tiles: [
              SettingsListTile(
                icon: Icons.person_outline_rounded,
                label: 'Personal details',
                onTap: () => controller.openComingSoon('Personal details'),
              ),
              SettingsListTile(
                icon: Icons.location_on_outlined,
                label: 'Saved addresses',
                onTap: () => controller.openComingSoon('Saved addresses'),
              ),
              SettingsListTile(
                icon: Icons.credit_card_outlined,
                label: 'Payment methods',
                onTap: () => controller.openComingSoon('Payment methods'),
              ),
              SettingsListTile(
                icon: Icons.notifications_none_rounded,
                label: 'Notifications',
                onTap: () => controller.openComingSoon('Notification settings'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SettingsSection(
            title: 'Support & legal',
            tiles: [
              SettingsListTile(
                icon: Icons.help_outline_rounded,
                label: 'Help & support',
                onTap: () => controller.openComingSoon('Help & support'),
              ),
              SettingsListTile(
                icon: Icons.shield_outlined,
                label: 'Terms & privacy',
                onTap: () => controller.openComingSoon('Terms & privacy'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SettingsSection(
            tiles: [
              SettingsListTile(
                icon: Icons.logout_rounded,
                label: 'Log out',
                isDestructive: true,
                onTap: () => controller.confirmLogout(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

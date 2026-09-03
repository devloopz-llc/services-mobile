import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/misc/section_header_with_action.dart';
import '../controller/messages_controller.dart';
import '../widgets/conversation_list_tile.dart';
import '../widgets/notification_list_tile.dart';

class MessagesTabView extends GetView<MessagesController> {
  const MessagesTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text('Messages', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          SectionHeaderWithAction(title: 'Conversations', onAction: controller.viewAllConversations),
          const SizedBox(height: 6),
          for (final conversation in controller.conversations)
            ConversationListTile(
              conversation: conversation,
              onTap: () => controller.openConversation(conversation),
            ),
          const SizedBox(height: 20),
          SectionHeaderWithAction(title: 'Notifications', onAction: controller.viewAllNotifications),
          const SizedBox(height: 6),
          for (final notification in controller.notifications)
            NotificationListTile(
              notification: notification,
              onTap: () => controller.openNotification(notification),
            ),
        ],
      ),
    );
  }
}

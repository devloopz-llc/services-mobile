import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/feedback/app_toast.dart';
import '../model/conversation_item.dart';
import '../model/notification_item.dart';

class MessagesController extends GetxController {
  final conversations = const [
    ConversationItem(
      id: 1,
      name: 'Admin support',
      lastMessage: 'Thank you! Your booking is confirmed.',
      time: '10:15 am',
      unreadCount: 1,
    ),
    ConversationItem(
      id: 2,
      name: 'Amir K.',
      lastMessage: "I'm on my way and should arrive shortly.",
      time: '9:20 am',
      unreadCount: 2,
    ),
  ];

  final notifications = const [
    NotificationItem(
      id: 1,
      icon: Icons.description_rounded,
      iconColor: Color(0xFF2F8F5B),
      title: 'Quote ready to review',
      subtitle: 'Your quote for "Kitchen tap leak" is ready to review.',
      time: 'Yesterday, 4:30 pm',
      isUnread: true,
    ),
    NotificationItem(
      id: 2,
      icon: Icons.credit_card_rounded,
      iconColor: Color(0xFF2E7BE0),
      title: 'Payment received',
      subtitle: "We've received your payment of £120.00 for Boiler repair.",
      time: 'Yesterday, 11:05 am',
      isUnread: true,
    ),
  ];

  void openConversation(ConversationItem conversation) => AppToast.info('Chat with ${conversation.name} is coming soon.');

  void openNotification(NotificationItem notification) => AppToast.info(notification.title);

  void viewAllConversations() => AppToast.info('Full conversation list is coming soon.');

  void viewAllNotifications() => AppToast.info('Full notification list is coming soon.');
}

import 'package:flutter/material.dart';

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isUnread = false,
  });

  final int id;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;
}

import 'package:flutter/material.dart';

import '../model/notification_item.dart';

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({super.key, required this.notification, this.onTap});

  final NotificationItem notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notification.iconColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(notification.icon, color: notification.iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title, style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    notification.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.time,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (notification.isUnread) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

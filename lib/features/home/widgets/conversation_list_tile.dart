import 'package:flutter/material.dart';

import '../../../common_widgets/avatar/app_avatar.dart';
import '../model/conversation_item.dart';

class ConversationListTile extends StatelessWidget {
  const ConversationListTile({super.key, required this.conversation, this.onTap});

  final ConversationItem conversation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasUnread = conversation.unreadCount > 0;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppAvatar(name: conversation.name, imageUrl: conversation.avatarUrl, size: 46),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(conversation.name, style: Theme.of(context).textTheme.titleSmall)),
                      Text(
                        conversation.time,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    conversation.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: hasUnread ? scheme.onSurface : scheme.onSurfaceVariant,
                          fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
            if (hasUnread) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  '${conversation.unreadCount}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scheme.onPrimary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

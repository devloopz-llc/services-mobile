class ConversationItem {
  const ConversationItem({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.avatarUrl,
    this.unreadCount = 0,
  });

  final int id;
  final String name;
  final String lastMessage;
  final String time;
  final String? avatarUrl;
  final int unreadCount;
}

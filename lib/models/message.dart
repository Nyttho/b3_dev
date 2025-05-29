// models/message.dart
class Message {
  final dynamic id;
  final String content;
  final bool isUser;
  final dynamic conversationId;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    required this.isUser,
    this.conversationId,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    DateTime timestamp;
    try {
      timestamp = DateTime.parse(json['created_at'] ?? '');
    } catch (e) {
      timestamp = DateTime.now();
    }

    return Message(
      id: json['id'],
      content: json['content'] ?? '',
      isUser: json['is_sent_by_human'] ?? false,
      conversationId: json['conversation_id'],
      timestamp: timestamp,
    );
  }
}

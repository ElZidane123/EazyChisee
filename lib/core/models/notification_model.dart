class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type; // alert, info, success, promo
  final bool isRead;
  final DateTime createdAt;
  final String? actionRoute;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.actionRoute,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    String? actionRoute,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      actionRoute: actionRoute ?? this.actionRoute,
    );
  }
}

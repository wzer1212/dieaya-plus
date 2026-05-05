class NotificationItem {
  final int id;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final String type;
  final int isRead;
  final dynamic notificationData;
  final String? createdAt;
  final String? updatedAt;

  NotificationItem({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.type,
    required this.isRead,
    this.notificationData,
    this.createdAt,
    this.updatedAt,
  });

  NotificationItem copyWith({int? isRead}) {
    return NotificationItem(
      id: id,
      titleAr: titleAr,
      titleEn: titleEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      type: type,
      isRead: isRead ?? this.isRead,
      notificationData: notificationData,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as int? ?? 0,
      titleAr: json['title_ar'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? '',
      descriptionAr: json['description_ar'] as String? ?? '',
      descriptionEn: json['description_en'] as String? ?? '',
      type: json['type'] as String? ?? '',
      isRead: json['is_read'] as int? ?? 0,
      notificationData: json['notification_data'],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_ar': titleAr,
      'title_en': titleEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'type': type,
      'is_read': isRead,
      'notification_data': notificationData,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class NotificationResponse {
  final bool status;
  final int code;
  final String message;
  final List<NotificationItem> data;

  NotificationResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List? ?? [];
    return NotificationResponse(
      status: json['status'] as bool? ?? false,
      code: json['code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: dataList.map((item) => NotificationItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
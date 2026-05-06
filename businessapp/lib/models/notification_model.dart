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

class NotificationItem {
  final int id;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final String type;
  final String? createdAt;
  final String? updatedAt;
  final int issRead;

  NotificationItem({
    required this.id,
    required this.issRead,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
        id: json['id'] as int? ?? 0,
        titleAr: json['title_ar'] as String? ?? '',
        titleEn: json['title_en'] as String? ?? '',
        descriptionAr: json['description_ar'] as String? ?? '',
        descriptionEn: json['description_en'] as String? ?? '',
        type: json['type'] as String? ?? '',
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        issRead: json['is_read'] as int );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_ar': titleAr,
      'title_en': titleEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

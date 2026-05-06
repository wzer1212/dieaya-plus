// Response model for the splash API
class SplashResponse {
  final bool? status;
  final int? code;
  final String? message;
  final List<SplashData>? data;

  SplashResponse({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory SplashResponse.fromJson(Map<String, dynamic> json) {
    return SplashResponse(
      status: json['status'] as bool?,
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
          .map((e) => SplashData.fromJson(e as Map<String, dynamic>))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class SplashData {
  final int? id;
  final String? titleAr;
  final String? titleEn;
  final String? image;
  final String? descriptionAr;
  final String? descriptionEn;
  final int? status;
  final String? createdAt;
  final String? updatedAt;

  SplashData({
    this.id,
    this.titleAr,
    this.titleEn,
    this.image,
    this.descriptionAr,
    this.descriptionEn,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory SplashData.fromJson(Map<String, dynamic> json) {
    return SplashData(
      id: json['id'] as int?,
      titleAr: json['title_ar'] as String?,
      titleEn: json['title_en'] as String?,
      image: json['image'] as String?,
      descriptionAr: json['description_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      status: json['status'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_ar': titleAr,
      'title_en': titleEn,
      'image': image,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
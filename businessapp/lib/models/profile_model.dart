class ProfileResponse {
  final bool? status;
  final int? code;
  final String? message;
  final CustomerProfile? data;

  ProfileResponse({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ProfileResponse();
    }
    return ProfileResponse(
      status: json['status'] as bool?,
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? CustomerProfile.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (status != null) 'status': status,
      if (code != null) 'code': code,
      if (message != null) 'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class CustomerProfile {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? logo;
  final int? verified;
  final String? description;
  final String? link;
  final int? block;
  final int? isBest;
  final int? isActive;
  final int? viewsCount;
  final String? createdAt;
  final String? updatedAt;
  final int? packageId;
  final bool? whatsappNotification;
  final bool? isFavorite;
  final List<ProfileCategory>? categories;

  CustomerProfile({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.logo,
    this.verified,
    this.description,
    this.link,
    this.block,
    this.isBest,
    this.isActive,
    this.viewsCount,
    this.createdAt,
    this.updatedAt,
    this.packageId,
    this.whatsappNotification,
    this.isFavorite,
    this.categories,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CustomerProfile();
    }
    return CustomerProfile(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      logo: json['logo'] as String?,
      verified: json['verified'] as int?,
      description: json['description'] as String?,
      link: json['link'] as String?,
      block: json['block'] as int?,
      isBest: json['is_best'] as int?,
      isActive: json['is_active'] as int?,
      viewsCount: json['views_count'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      packageId: json['package_id'] as int?,
      whatsappNotification: json['whatsapp_notification'] as bool,
      isFavorite: json['is_favorite'] as bool?,
      categories: json['categories'] != null
          ? (json['categories'] as List)
          .map((item) => ProfileCategory.fromJson(item as Map<String, dynamic>))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (logo != null) 'logo': logo,
      if (verified != null) 'verified': verified,
      if (description != null) 'description': description,
      if (link != null) 'link': link,
      if (block != null) 'block': block,
      if (isBest != null) 'is_best': isBest,
      if (isActive != null) 'is_active': isActive,
      if (viewsCount != null) 'views_count': viewsCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (packageId != null) 'package_id': packageId,
      if (whatsappNotification != null) 'whatsapp_notification': whatsappNotification,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (categories != null)
        'categories': categories!.map((category) => category.toJson()).toList(),
    };
  }
}

class ProfileCategory {
  final int? id;
  final String? nameAr;
  final String? nameEn;
  final int? isActive;
  final String? image;
  final int? sort;
  final String? createdAt;
  final String? updatedAt;
  final Pivot? pivot;

  ProfileCategory({
    this.id,
    this.nameAr,
    this.nameEn,
    this.isActive,
    this.image,
    this.sort,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory ProfileCategory.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ProfileCategory();
    }
    return ProfileCategory(
      id: json['id'] as int?,
      nameAr: json['name_ar'] as String?,
      nameEn: json['name_en'] as String?,
      isActive: json['is_active'] as int?,
      image: json['image'] as String?,
      sort: json['sort'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      pivot: json['pivot'] != null
          ? Pivot.fromJson(json['pivot'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (isActive != null) 'is_active': isActive,
      if (image != null) 'image': image,
      if (sort != null) 'sort': sort,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (pivot != null) 'pivot': pivot!.toJson(),
    };
  }
}

class Pivot {
  final int? marketId;
  final int? categoryId;

  Pivot({
    this.marketId,
    this.categoryId,
  });

  factory Pivot.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Pivot();
    }
    return Pivot(
      marketId: json['market_id'] as int?,
      categoryId: json['category_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (marketId != null) 'market_id': marketId,
      if (categoryId != null) 'category_id': categoryId,
    };
  }
}
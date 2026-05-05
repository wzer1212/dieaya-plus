
class Market {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String logo;
  final String? description;
  final String link;
  final String createdAt;
  final String updatedAt;

  Market({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.logo,
    this.description,
    required this.link,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      logo: json['logo'] ?? '',
      description: json['description'],
      link: json['link'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'logo': logo,
      'description': description,
      'link': link,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class MarketCoupon {
  final int id;
  final String couponCode;
  final String descriptionAr;
  final String descriptionEn;
  final String? terms;
  final String link;
  final int categoryId;

  MarketCoupon({
    required this.id,
    required this.couponCode,
    required this.descriptionAr,
    required this.descriptionEn,
    this.terms,
    required this.link,
    required this.categoryId,
  });

  factory MarketCoupon.fromJson(Map<String, dynamic> json) {
    return MarketCoupon(
      id: json['id'] ?? 0,
      couponCode: json['coupon_code'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      terms: json['terms'],
      link: json['link'] ?? '',
      categoryId: json['category_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coupon_code': couponCode,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'terms': terms,
      'link': link,
      'category_id': categoryId,
    };
  }
}


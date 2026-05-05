class MarketCoupon {
  final int id;
  final String couponCode;
  final String descriptionAr;
  final String discount;
  final String descriptionEn;
  final String? terms;
  final DateTime? createdAt; // Added for sorting
  final String link;
  final int categoryId;
  final CouponMarket market;

  MarketCoupon({
    required this.id,
    required this.couponCode,
    required this.descriptionAr,
    required this.discount,

    required this.descriptionEn,
    this.createdAt,
    this.terms,
    required this.link,
    required this.categoryId,
    required this.market,
  });

  factory MarketCoupon.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        // Assuming date format is DD-MM-YYYY
        final parts = dateStr.split('-');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]), // Year
            int.parse(parts[1]), // Month
            int.parse(parts[0]), // Day
          );
        }
        return null;
      } catch (e) {
        return null;
      }
    }
    return MarketCoupon(
      id: json['id'] ?? 0,
      couponCode: json['coupon_code'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      discount: json['discount'] ?? '',
      terms: json['terms'],
      createdAt: parseDate(json['created_at'] as String?),
      link: json['link'] ?? '',
      categoryId: json['category_id'] ?? 0,
      market: CouponMarket.fromJson(json['market'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    String? formatDate(DateTime? date) {
      if (date == null) return null;
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    }
    return {
      'id': id,
      'coupon_code': couponCode,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'created_at': formatDate(createdAt),
      'terms': terms,
      'link': link,
      'category_id': categoryId,
      'market': market.toJson(),
    };
  }
}

class CouponMarket {
  final int id;
  final String name;
  final String logo;

  CouponMarket({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory CouponMarket.fromJson(Map<String, dynamic> json) {
    return CouponMarket(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
    };
  }
}
class OfferMarket {
  final int id;
  final String name;
  final String logo;

  OfferMarket({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory OfferMarket.fromJson(Map<String, dynamic> json) {
    return OfferMarket(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
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

class MarketOffer {
  final int id;
  final int marketId;
  final String? type;
  final OfferMarket market;
  final int categoryId;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? titleAr;
  final String? titleEn;
  final String? terms;
  final String? couponCode;
  final String link;
  final String shareLink;
  final int viewsCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isFavorite;
  final int status;

  MarketOffer( {
    required this.id,
    required this.marketId,
    this.type,
    required this.market,
    required this.categoryId,
    this.descriptionAr,
    this.descriptionEn,
    this.titleAr,
    this.titleEn,
    this.terms,
    this.couponCode,
    required this.link,
    required this.shareLink,
    required this.viewsCount,
    this.createdAt,
    this.updatedAt,
    this.isFavorite = false,
    required this.status,
  });

  factory MarketOffer.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
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

    return MarketOffer(
      id: json['id'] as int? ?? 0,
      marketId: json['market_id'] as int? ?? 0,
      type: json['type'] as String?,
      market: OfferMarket.fromJson(json['market'] as Map<String, dynamic>? ?? {}),
      categoryId: json['category_id'] as int? ?? 0,
      descriptionAr: json['description_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      titleAr: json['title_ar'] as String?,
      titleEn: json['title_en'] as String?,
      terms: json['terms'] as String?,
      couponCode: json['coupon_code'] as String?,
      link: json['link'] as String? ?? '',
      shareLink: json['share_link'] as String? ?? '',
      viewsCount: json['views_count'] as int? ?? 0,
      createdAt: parseDate(json['created_at'] as String?),
      updatedAt: parseDate(json['updated_at'] as String?),
      isFavorite: json['is_favorite'] as bool? ?? false,
      status: json['status'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    String? formatDate(DateTime? date) {
      if (date == null) return null;
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    }

    return {
      'id': id,
      'market_id': marketId,
      'type': type,
      'market': market.toJson(),
      'category_id': categoryId,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'title_ar': titleAr,
      'title_en': titleEn,
      'terms': terms,
      'coupon_code': couponCode,
      'link': link,
      'views_count': viewsCount,
      'created_at': formatDate(createdAt),
      'updated_at': formatDate(updatedAt),
      'is_favorite': isFavorite,
      'status': status,
    };
  }
}

class PaginationOffer {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationOffer({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationOffer.fromJson(Map<String, dynamic> json) {
    return PaginationOffer(
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 10,
      total: json['total'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}
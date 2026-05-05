


import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/models/product_model.dart';

import 'categories_model.dart';

import 'package:dieaya_user/models/product_model.dart';
import 'categories_model.dart';

// ✅ add these 2 imports where your Offer/Coupon models live (or create them below)
// import 'offer_model.dart';
// import 'coupon_model.dart';

class Market {
  final int id;
  final int? categoryId;
  final String name;
  final String email;
  final String phone;
  final String logo;
  final DateTime? createdAt;
  final String? description;
  final String link;

  /// NOTE:
  /// In your API response, top-level market item doesn't have `share_link`,
  /// but your model requires it. Keep it, but default to '' if missing.
  final String shareLink;

  bool isFavorite;
  final List<kCategory> categories;
  final List<Product> products;

  /// ✅ NEW
  final List<Offer> offers;
  final List<Coupon> coupons;

  Market({
    required this.id,
    this.categoryId,
    required this.name,
    required this.email,
    required this.phone,
    required this.logo,
    this.createdAt,
    this.description,
    required this.link,
    required this.shareLink,
    this.isFavorite = false,
    required this.categories,
    required this.products,

    /// ✅ NEW
    this.offers = const [],
    this.coupons = const [],
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        // Your API sample looks like MM-DD-YYYY (e.g. 12-30-2025, 02-08-2026)
        final parts = dateStr.split('-');
        if (parts.length == 3) {
          final a = int.tryParse(parts[0]);
          final b = int.tryParse(parts[1]);
          final c = int.tryParse(parts[2]);
          if (a == null || b == null || c == null) return null;

          // If first part > 12 => assume DD-MM-YYYY, else MM-DD-YYYY
          if (a > 12) return DateTime(c, b, a);
          return DateTime(c, a, b);
        }
        return null;
      } catch (_) {
        return null;
      }
    }

    return Market(
      id: json['id'] ?? 0,
      categoryId: json['category_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      logo: json['logo'] ?? '',
      createdAt: parseDate(json['created_at'] as String?),
      description: json['description'],
      link: json['link'] ?? '',
      shareLink: json['share_link'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((item) => kCategory.fromJson(item))
          .toList() ??
          [],
      products: ((json['products'] as List? ?? []))
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),

      /// ✅ NEW
      offers: ((json['offers'] as List? ?? []))
          .map((e) => Offer.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupons: ((json['coupons'] as List? ?? []))
          .map((e) => Coupon.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    String? formatDate(DateTime? date) {
      if (date == null) return null;
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    }

    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'email': email,
      'phone': phone,
      'logo': logo,
      'created_at': formatDate(createdAt),
      'description': description,
      'link': link,
      'share_link': shareLink,
      'is_favorite': isFavorite,
      'categories': categories.map((category) => category.toJson()).toList(),
      'products': products.map((p) => p.toJson()).toList(),

      /// ✅ NEW
      'offers': offers.map((o) => o.toJson()).toList(),
      'coupons': coupons.map((c) => c.toJson()).toList(),
    };
  }
}

/// ✅ Minimal models matching your API response.
/// If you already have them elsewhere, just delete these and import your own.

class Offer {
  final int id;
  final int marketId;
  final String type;
  final int? categoryId;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? titleAr;
  final String? titleEn;
  final String? terms;
  final String? shareLink;
  final String? couponCode;
  final String? link;
  final int? viewsCount;
  final String? createdAt;
  final String? updatedAt;
  final bool isFavorite;
  final int? status;

  Offer({
    required this.id,
    required this.marketId,
    required this.type,
    this.categoryId,
    this.descriptionAr,
    this.descriptionEn,
    this.titleAr,
    this.titleEn,
    this.terms,
    this.shareLink,
    this.couponCode,
    this.link,
    this.viewsCount,
    this.createdAt,
    this.updatedAt,
    required this.isFavorite,
    this.status,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    id: json['id'] ?? 0,
    marketId: json['market_id'] ?? 0,
    type: json['type'] ?? '',
    categoryId: json['category_id'],
    descriptionAr: json['description_ar'],
    descriptionEn: json['description_en'],
    titleAr: json['title_ar'],
    titleEn: json['title_en'],
    terms: json['terms'],
    shareLink: json['share_link'],
    couponCode: json['coupon_code'],
    link: json['link'],
    viewsCount: json['views_count'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    isFavorite: json['is_favorite'] ?? false,
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'market_id': marketId,
    'type': type,
    'category_id': categoryId,
    'description_ar': descriptionAr,
    'description_en': descriptionEn,
    'title_ar': titleAr,
    'title_en': titleEn,
    'terms': terms,
    'share_link': shareLink,
    'coupon_code': couponCode,
    'link': link,
    'views_count': viewsCount,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'is_favorite': isFavorite,
    'status': status,
  };
}

class Coupon {
  final int id;
  final String? couponCode;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? terms;
  final String? discount;
  final String? link;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final int? categoryId;
  final int? viewsCount;

  Coupon({
    required this.id,
    this.couponCode,
    this.descriptionAr,
    this.descriptionEn,
    this.terms,
    this.discount,
    this.link,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.viewsCount,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    id: json['id'] ?? 0,
    couponCode: json['coupon_code'],
    descriptionAr: json['description_ar'],
    descriptionEn: json['description_en'],
    terms: json['terms'],
    discount: json['discount']?.toString(),
    link: json['link'],
    status: json['status'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    categoryId: json['category_id'],
    viewsCount: json['views_count'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'coupon_code': couponCode,
    'description_ar': descriptionAr,
    'description_en': descriptionEn,
    'terms': terms,
    'discount': discount,
    'link': link,
    'status': status,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'category_id': categoryId,
    'views_count': viewsCount,
  };
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'last_page': lastPage,
    'per_page': perPage,
    'total': total,
  };
}

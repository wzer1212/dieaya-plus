import 'package:dieaya_market/models/product_model.dart';
import 'package:get/get.dart';

class Coupon {
  final int id;
  final String couponCode;
  final String descriptionAr;
  final String descriptionEn;
  final String? terms;
  final String discount;
  final String link;
  final String createdAt;
  final String updatedAt;
  final int categoryId;
  final MarketCoupon market;
  final int status;
  final int viewCoupon;

  Coupon({
    required this.id,
    required this.couponCode,
    required this.descriptionAr,
    required this.descriptionEn,
    this.terms,
    required this.discount,
    required this.link,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
    required this.market,
    required this.status,
    required this.viewCoupon,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] as int,
      couponCode: json['coupon_code'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      terms: json['terms'] ?? '',
      discount: json['discount'] ?? '',
      link: json['link'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      categoryId: json['category_id'] as int,
      market: MarketCoupon.fromJson(json['market'] as Map<String, dynamic>),
      status: json['status'] ?? 1,
      viewCoupon: json['views_count'] ?? 0,
    );
  }
}

class MarketCoupon {
  final int id;
  final String name;
  final String logo;

  MarketCoupon({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory MarketCoupon.fromJson(Map<String, dynamic> json) {
    return MarketCoupon(
      id: json['id'] as int,
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}

class CouponResponse {
  final bool status;
  final int code;
  final String message;
  final CouponData data;

  CouponResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      status: json['status'] as bool,
      code: json['code'] as int,
      message: json['message'] ?? '',
      data: CouponData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class CouponData {
  final List<Coupon> coupons;
  final Pagination pagination;

  CouponData({
    required this.coupons,
    required this.pagination,
  });

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      coupons: (json['coupons'] as List<dynamic>)
          .map((e) => Coupon.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }
}

import 'package:dieaya_market/models/product_model.dart';
import 'package:get/get.dart';

class BannerMarket {
  final int id;
  final int marketId;
  final MarketBanner market;
  final String image;
  final String link;
  final String descriptionAr;
  final String descriptionEn;
  final String createdAt;
  final String updatedAt;
  final String location;
  final String? couponCode;
  final int status;


  BannerMarket({
    required this.id,
    required this.marketId,
    required this.market,
    required this.image,
    required this.link,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.createdAt,
    required this.updatedAt,
    required this.location,
    this.couponCode,
    required this.status,

  });

  factory BannerMarket.fromJson(Map<String, dynamic> json) {
    return BannerMarket(
      id: json['id'] as int? ?? 0,
      marketId: json['market_id'] as int? ?? 0,
      market:
          MarketBanner.fromJson(json['market'] as Map<String, dynamic>)
         , // assuming you have an empty constructor
      image: json['image'] as String? ?? '',
      link: json['link'] as String? ?? '',
      descriptionAr: json['description_ar'] as String? ?? '',
      descriptionEn: json['description_en'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      location: json['location'] as String? ?? '',
      couponCode: json['coupon_code'] as String?, // nullable, no default
      status: json['status'] as int? ?? 1,

    );
  }
}

class MarketBanner {
  final int id;
  final String name;
  final String logo;

  MarketBanner({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory MarketBanner.fromJson(Map<String, dynamic> json) {
    return MarketBanner(
      id: json['id'] as int,
      name: json['name'] ??'',
      logo: json['logo'] ??'',
    );
  }
}

class BannerResponse {
  final bool status;
  final int code;
  final String message;
  final BannerData data;

  BannerResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      status: json['status'] as bool,
      code: json['code'] as int,
      message: json['message'] as String,
      data: BannerData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class BannerData {
  final List<BannerMarket> banners;
  final Pagination pagination;

  BannerData({
    required this.banners,
    required this.pagination,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      banners: (json['banners'] as List<dynamic>)
          .map((e) => BannerMarket.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }
}


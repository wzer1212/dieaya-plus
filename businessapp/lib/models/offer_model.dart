import 'package:dieaya_market/models/product_model.dart';
import 'package:get/get.dart';

class Offer {
  final int id;
  final int marketId;
  final MarketOfferOffer market;
  final int categoryId;
  final String type;
  final String descriptionAr;
  final String descriptionEn;
  final String? titleAr;
  final String? titleEn;
  final String? terms;
  final String? couponCode;
  // final String image;
  final String link;
  final String createdAt;
  final String updatedAt;
  final bool isFavorite;
  final int status;
  final int viewCount;


  Offer( {
    required this.type,
    required this.id,
    required this.marketId,
    required this.market,
    required this.categoryId,
    required this.descriptionAr,
    required this.descriptionEn,
    this.titleAr,
    this.titleEn,
    this.terms,
    this.couponCode,
    // required this.image,
    required this.link,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    required this.status,
    required this.viewCount,

  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      type: json['type'],
      id: json['id'] as int,
      marketId: json['market_id'] as int,
      market: MarketOfferOffer.fromJson(json['market'] as Map<String, dynamic>),
      categoryId: json['category_id'] as int,
      descriptionAr: json['description_ar'] ??'',
      descriptionEn: json['description_en'] ??'',
      titleAr: json['title_ar'] as String?,
      titleEn: json['title_en'] as String?,
      terms: json['terms'] as String?,
      couponCode: json['coupon_code'] as String?,
      // image: json['image'] as String,
      link: json['link'] ??'',
      createdAt: json['created_at'] ??'',
      updatedAt: json['updated_at'] ??'',
      isFavorite: json['is_favorite'] as bool,
      status: json['status'] ?? 1,
      viewCount: json['views_count'] ?? 0,

    );
  }
}

class MarketOfferOffer {
  final int id;
  final String name;
  final String logo;

  MarketOfferOffer({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory MarketOfferOffer.fromJson(Map<String, dynamic> json) {
    return MarketOfferOffer(
      id: json['id'] as int,
      name: json['name'] ??'',
      logo: json['logo'] ??'',
    );
  }
}

class OfferResponse {
  final bool status;
  final int code;
  final String message;
  final OfferData data;

  OfferResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory OfferResponse.fromJson(Map<String, dynamic> json) {
    return OfferResponse(
      status: json['status'] as bool,
      code: json['code'] as int,
      message: json['message'] ??'',
      data: OfferData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class OfferData {
  final List<Offer> offers;
  final Pagination pagination;

  OfferData({
    required this.offers,
    required this.pagination,
  });

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      offers: (json['offers'] as List<dynamic>)
          .map((e) => Offer.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }
}

// class Pagination {
//   final int currentPage;
//   final int lastPage;
//   final int perPage;
//   final int total;
//
//   Pagination({
//     required this.currentPage,
//     required this.lastPage,
//     required this.perPage,
//     required this.total,
//   });
//
//   factory Pagination.fromJson(Map<String, dynamic> json) {
//     return Pagination(
//       currentPage: json['current_page'] as int,
//       lastPage: json['last_page'] as int,
//       perPage: json['per_page'] as int,
//       total: json['total'] as int,
//     );
//   }
// }
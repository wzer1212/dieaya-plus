class HomeResponse {
  final bool? status;
  final int? code;
  final HomeMessage? message;
  final String? data;

  HomeResponse({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory HomeResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return HomeResponse();
    }
    return HomeResponse(
      status: json['status'] as bool?,
      code: json['code'] as int?,
      message: json['message'] != null
          ? HomeMessage.fromJson(json['message'] as Map<String, dynamic>?)
          : null,
      data: json['data'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (status != null) 'status': status,
      if (code != null) 'code': code,
      if (message != null) 'message': message!.toJson(),
      if (data != null) 'data': data,
    };
  }
}

class HomeMessage {
  final Statistic? surfers;
  final Statistic? visitors;
  final Statistic? favorites;
  final Statistic? shares;
  final Statistic? productFavorites;
  final Statistic? offersFavorites;
  final List<ProductHome>? mostViewedProducts;
  final List<OfferHome>? mostViewedOffers;
  final List<CouponHome>? mostViewedCoupons;
  final List<MarketBanner>? mostViewedMarketBanners;

  HomeMessage({
    this.surfers,
    this.visitors,
    this.favorites,
    this.shares,
    this.productFavorites,
    this.offersFavorites,
    this.mostViewedProducts,
    this.mostViewedOffers,
    this.mostViewedCoupons,
    this.mostViewedMarketBanners,
  });

  factory HomeMessage.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return HomeMessage();
    }
    return HomeMessage(
      surfers: json['surfers'] != null
          ? Statistic.fromJson(json['surfers'] as Map<String, dynamic>?)
          : null,
      visitors: json['visitors'] != null
          ? Statistic.fromJson(json['visitors'] as Map<String, dynamic>?)
          : null,
      favorites: json['favorites'] != null
          ? Statistic.fromJson(json['favorites'] as Map<String, dynamic>?)
          : null,
      shares: json['shares'] != null
          ? Statistic.fromJson(json['shares'] as Map<String, dynamic>?)
          : null,
      productFavorites: json['productFavorites'] != null
          ? Statistic.fromJson(
              json['productFavorites'] as Map<String, dynamic>?)
          : null,
      offersFavorites: json['offersFavorites'] != null
          ? Statistic.fromJson(json['offersFavorites'] as Map<String, dynamic>?)
          : null,
      mostViewedProducts: json['mostViewedProducts'] != null &&
              json['mostViewedProducts'] is List
          ? (json['mostViewedProducts'] as List)
              .map(
                  (item) => ProductHome.fromJson(item as Map<String, dynamic>?))
              .toList()
          : null,
      mostViewedOffers: json['mostViewedOffers'] != null &&
              json['mostViewedOffers'] is List
          ? (json['mostViewedOffers'] as List)
              .map((item) => OfferHome.fromJson(item as Map<String, dynamic>?))
              .toList()
          : null,
      mostViewedCoupons: json['mostViewedCoupons'] != null &&
              json['mostViewedCoupons'] is List
          ? (json['mostViewedCoupons'] as List)
              .map((item) => CouponHome.fromJson(item as Map<String, dynamic>?))
              .toList()
          : null,
      mostViewedMarketBanners: json['mostViewedMarketBanners'] != null &&
              json['mostViewedMarketBanners'] is List
          ? (json['mostViewedMarketBanners'] as List)
              .map((item) =>
                  MarketBanner.fromJson(item as Map<String, dynamic>?))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (surfers != null) 'surfers': surfers!.toJson(),
      if (visitors != null) 'visitors': visitors!.toJson(),
      if (favorites != null) 'favorites': favorites!.toJson(),
      if (shares != null) 'shares': shares!.toJson(),
      if (productFavorites != null)
        'productFavorites': productFavorites!.toJson(),
      if (offersFavorites != null) 'offersFavorites': offersFavorites!.toJson(),
      if (mostViewedProducts != null)
        'mostViewedProducts':
            mostViewedProducts!.map((e) => e.toJson()).toList(),
      if (mostViewedOffers != null)
        'mostViewedOffers': mostViewedOffers!.map((e) => e.toJson()).toList(),
      if (mostViewedCoupons != null)
        'mostViewedCoupons': mostViewedCoupons!.map((e) => e.toJson()).toList(),
      if (mostViewedMarketBanners != null)
        'mostViewedMarketBanners':
            mostViewedMarketBanners!.map((e) => e.toJson()).toList(),
    };
  }
}

class Statistic {
  final double? yesterday;
  final double? today;
  final double? percentage;
  final String? type;

  Statistic({
    this.yesterday,
    this.today,
    this.percentage,
    this.type,
  });

  factory Statistic.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Statistic();
    }
    return Statistic(
// Convert int to double if necessary
      yesterday: (json['yesterday'] is int)
          ? (json['yesterday'] as int).toDouble()
          : json['yesterday'] as double?,
      today: (json['today'] is int)
          ? (json['today'] as int).toDouble()
          : json['today'] as double?,
      percentage: (json['percentage'] is int)
          ? (json['percentage'] as int).toDouble()
          : json['percentage'] as double?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (yesterday != null) 'yesterday': yesterday,
      if (today != null) 'today': today,
      if (percentage != null) 'percentage': percentage,
      if (type != null) 'type': type,
    };
  }
}

class ProductImage {
  final int? id;
  final int? productId;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  ProductImage({
    this.id,
    this.productId,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ProductImage();
    }
    return ProductImage(
      id: json['id'] as int?,
      productId: json['product_id'] as int?,
      image: json['image'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (image != null) 'image': image,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}

class ProductHome {
  final int? id;
  final int? categoryId;
  final int? marketId;
  final String? nameAr;
  final String? nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? image;
  final String? price;
  final String? priceOffer;
  final String? link;
  final int? status;
  final int? isFeatured;
  final String? createdAt;
  final String? updatedAt;
  final int? viewsCount;
  final bool? isFavorite;
  final List<ProductImage>? images;

  ProductHome({
    this.id,
    this.categoryId,
    this.marketId,
    this.nameAr,
    this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.image,
    this.price,
    this.priceOffer,
    this.link,
    this.status,
    this.isFeatured,
    this.createdAt,
    this.updatedAt,
    this.viewsCount,
    this.isFavorite,
    this.images,
  });

  factory ProductHome.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ProductHome();
    }
    return ProductHome(
      id: json['id'] as int?,
      categoryId: json['category_id'] as int?,
      marketId: json['market_id'] as int?,
      nameAr: json['name_ar'] as String?,
      nameEn: json['name_en'] as String?,
      descriptionAr: json['description_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      image: json['image'] as String?,
      price: json['price'] as String?,
      priceOffer: json['price_offer'] as String?,
      link: json['link'] as String?,
      status: json['status'] as int?,
      isFeatured: json['is_featured'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      viewsCount: json['views_count'] as int?,
      isFavorite: json['is_favorite'] as bool?,
      images: json['images'] != null && json['images'] is List
          ? (json['images'] as List)
              .map((item) =>
                  ProductImage.fromJson(item as Map<String, dynamic>?))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (marketId != null) 'market_id': marketId,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (descriptionAr != null) 'description_ar': descriptionAr,
      if (descriptionEn != null) 'description_en': descriptionEn,
      if (image != null) 'image': image,
      if (price != null) 'price': price,
      if (priceOffer != null) 'price_offer': priceOffer,
      if (link != null) 'link': link,
      if (status != null) 'status': status,
      if (isFeatured != null) 'is_featured': isFeatured,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (viewsCount != null) 'views_count': viewsCount,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (images != null) 'images': images!.map((e) => e.toJson()).toList(),
    };
  }
}

class OfferHome {
  final int? id;
  final int? marketId;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? image;
  final String? link;
  final String? createdAt;
  final String? updatedAt;
  final String? titleAr;
  final String? titleEn;
  final int? categoryId;
  final String? couponCode;
  final String? terms;
  final int? status;
  final int? viewsCount;
  final bool? isFavorite;

  OfferHome({
    this.id,
    this.marketId,
    this.descriptionAr,
    this.descriptionEn,
    this.image,
    this.link,
    this.createdAt,
    this.updatedAt,
    this.titleAr,
    this.titleEn,
    this.categoryId,
    this.couponCode,
    this.terms,
    this.status,
    this.viewsCount,
    this.isFavorite,
  });

  factory OfferHome.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return OfferHome();
    }
    return OfferHome(
      id: json['id'] as int?,
      marketId: json['market_id'] as int?,
      descriptionAr: json['description_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      image: json['image'] as String?,
      link: json['link'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      titleAr: json['title_ar'] as String?,
      titleEn: json['title_en'] as String?,
      categoryId: json['category_id'] as int?,
      couponCode: json['coupon_code'] as String?,
      terms: json['terms'] as String?,
      status: json['status'] as int?,
      viewsCount: json['views_count'] as int?,
      isFavorite: json['is_favorite'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (marketId != null) 'market_id': marketId,
      if (descriptionAr != null) 'description_ar': descriptionAr,
      if (descriptionEn != null) 'description_en': descriptionEn,
      if (image != null) 'image': image,
      if (link != null) 'link': link,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (titleAr != null) 'title_ar': titleAr,
      if (titleEn != null) 'title_en': titleEn,
      if (categoryId != null) 'category_id': categoryId,
      if (couponCode != null) 'coupon_code': couponCode,
      if (terms != null) 'terms': terms,
      if (status != null) 'status': status,
      if (viewsCount != null) 'views_count': viewsCount,
      if (isFavorite != null) 'is_favorite': isFavorite,
    };
  }
}

class CouponHome {
  final int? id;
  final int? marketId;
  final String? couponCode;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? terms;
  final String? link;
  final String? createdAt;
  final String? updatedAt;
  final int? categoryId;
  final String? discount;
  final int? status;
  final int? viewsCount;

  CouponHome({
    this.id,
    this.marketId,
    this.couponCode,
    this.descriptionAr,
    this.descriptionEn,
    this.terms,
    this.link,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.discount,
    this.status,
    this.viewsCount,
  });

  factory CouponHome.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CouponHome();
    }
    return CouponHome(
      id: json['id'] as int?,
      marketId: json['market_id'] as int?,
      couponCode: json['coupon_code'] as String?,
      descriptionAr: json['description_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      terms: json['terms'] as String?,
      link: json['link'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      categoryId: json['category_id'] as int?,
      discount: json['discount'] as String?,
      status: json['status'] as int?,
      viewsCount: json['views_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (marketId != null) 'market_id': marketId,
      if (couponCode != null) 'coupon_code': couponCode,
      if (descriptionAr != null) 'description_ar': descriptionAr,
      if (descriptionEn != null) 'description_en': descriptionEn,
      if (terms != null) 'terms': terms,
      if (link != null) 'link': link,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (categoryId != null) 'category_id': categoryId,
      if (discount != null) 'discount': discount,
      if (status != null) 'status': status,
      if (viewsCount != null) 'views_count': viewsCount,
    };
  }
}

class MarketBanner {
  final int? id;
  final int? marketId;
  final String? image;
  final String? link;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? location;
  final String? createdAt;
  final String? updatedAt;
  final int? status;
  final int? viewsCount;

  MarketBanner({
    this.id,
    this.marketId,
    this.image,
    this.link,
    this.descriptionAr,
    this.descriptionEn,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.viewsCount,
  });

  factory MarketBanner.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MarketBanner();
    }
    return MarketBanner(
      id: json['id'] as int?,
      marketId: json['market_id'] as int?,
      image: json['image'] as String?,
      link: json['link'] as String?,
      descriptionAr: json['description_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      location: json['location'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      status: json['status'] as int?,
      viewsCount: json['views_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (marketId != null) 'market_id': marketId,
      if (image != null) 'image': image,
      if (link != null) 'link': link,
      if (descriptionAr != null) 'description_ar': descriptionAr,
      if (descriptionEn != null) 'description_en': descriptionEn,
      if (location != null) 'location': location,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (status != null) 'status': status,
      if (viewsCount != null) 'views_count': viewsCount,
    };
  }
}

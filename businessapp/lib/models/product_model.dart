class ProductResponse {
  final bool status;
  final int code;
  final String message;
  final ProductData data;

  ProductResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: ProductData.fromJson(json['data'] ?? {}),
    );
  }
}

class ProductData {
  final List<Product> products;
  final Pagination pagination;

  ProductData({
    required this.products,
    required this.pagination,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      products: (json['products'] as List<dynamic>?)
          ?.map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class Product {
  final int id;
  final String nameAr;
  final String? nameEn;
  final String descriptionAr;
  final String? descriptionEn;
  final String price;
  final String? priceOffer;
  final String link;
  final bool isFeatured;
  final bool isFavorite;
  final int categoryId;
  final String createdAt;
  final String updatedAt;
  final Category category;
  final List<ProductImage> images;
  final List<InstallmentWay> installmentWays;
  final int status;
  final int viewCount;

  Product({
    required this.id,
    required this.nameAr,
    this.nameEn,
    required this.descriptionAr,
    this.descriptionEn,
    required this.price,
    this.priceOffer,
    required this.link,
    required this.isFeatured,
    required this.isFavorite,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.images,
    required this.installmentWays,

    required this.status,
    required this.viewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'],
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'],
      price: json['price']?.toString() ?? '',
      priceOffer: json['price_offer']?.toString(),
      link: json['link'] ?? '',
      isFeatured: (json['is_featured'] is bool)
          ? json['is_featured']
          : (json['is_featured'] == 1),
      isFavorite: (json['is_favorite'] is bool)
          ? json['is_favorite']
          : (json['is_favorite'] == 1),
      categoryId: json['category_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
      images: (json['images'] as List<dynamic>?)
          ?.map((item) => ProductImage.fromJson(item))
          .toList() ??
          [],
      installmentWays: (json['installment_ways'] as List<dynamic>?)
          ?.map((item) => InstallmentWay.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
      status: json['status'] ?? 1,
      viewCount: json['views_count'] ?? 0,
    );
  }
}

class Category {
  final int id;
  final String nameAr;
  final String nameEn;
  final String image;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class InstallmentWay {
  final int id;
  final String nameAr;
  final String nameEn;
  final String image;

  InstallmentWay({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.image,
  });

  factory InstallmentWay.fromJson(Map<String, dynamic> json) {
    return InstallmentWay(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      image: json['image'] ?? '',
    );
  }
}


class ProductImage {
  final int id;
  final String image;

  ProductImage({
    required this.id,
    required this.image,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
    );
  }
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
}
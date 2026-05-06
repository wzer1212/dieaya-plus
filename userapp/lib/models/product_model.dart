
class CategoryProduct {
  final int id;
  final String nameAr;
  final String nameEn;
  final String image;

  CategoryProduct({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.image,
  });

  /// ✅ Empty default object
  factory CategoryProduct.empty() {
    return CategoryProduct(
      id: 0,
      nameAr: '',
      nameEn: '',
      image: '',
    );
  }
  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'image': image,
    };
  }
}

class MarketProduct {
  final int id;
  final String nameAr;
  final String logo;

  MarketProduct({
    required this.id,
    required this.nameAr,
    required this.logo,
  });
  /// ✅ Empty default object
  factory MarketProduct.empty() {
    return MarketProduct(
      id: 0,
      nameAr: '',
      logo: '',
    );
  }
  factory MarketProduct.fromJson(Map<String, dynamic> json) {
    return MarketProduct(
      id: json['id'] ?? 0,
      nameAr: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nameAr,
      'logo': logo,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
    };
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



class PaginationProduct {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationProduct({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationProduct.fromJson(Map<String, dynamic> json) {
    return PaginationProduct(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
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


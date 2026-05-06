import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/models/product_model.dart';

class CategoriesResponse {
  final bool status;
  final int code;
  final String message;
  final List<Category> data;

  CategoriesResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
        status: json['status'],
        code: json['code'],
        message: json['message'],
        data: (json['data'] as List)
            .map((cat) => Category.fromJson(cat))
            .toList());
  }
}

class Category {
  final int id;
  final String nameAr;
  final String nameEn;
  final String image;
  final int sort;
  final int showInHome;
  final ProductList products;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.image,
    required this.sort,
    required this.showInHome,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      image: json['image'],
      sort: json['sort'],
      showInHome: json['show_in_home'],
      products: ProductList.fromJson(json['products']),
    );
  }
}

class ProductList {
  final List<Product> data;
  final PaginationProduct pagination;

  ProductList({
    required this.data,
    required this.pagination,
  });

  factory ProductList.fromJson(Map<String, dynamic> json) {
    return ProductList(
      data: (json['data'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
      pagination: PaginationProduct.fromJson(json['pagination']),
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
//       currentPage: json['current_page'],
//       lastPage: json['last_page'],
//       perPage: json['per_page'],
//       total: json['total'],
//     );
//   }
// }
// class Product {
//   final int id;
//   final String nameAr;
//   final String nameEn;
//   final String descriptionAr;
//   final String descriptionEn;
//   final String price;
//   final String priceOffer;
//   final String link;
//   final bool isFeatured;
//   final bool isFavorite;
//   final int categoryId;
//   final int status;
//   final int viewsCount;
//   final String createdAt;
//   final String updatedAt;
//   final CategoryInfo category;
//   final Market market;
//   final List<ProductImage> images;
//
//   Product({
//     required this.id,
//     required this.nameAr,
//     required this.nameEn,
//     required this.descriptionAr,
//     required this.descriptionEn,
//     required this.price,
//     required this.priceOffer,
//     required this.link,
//     required this.isFeatured,
//     required this.isFavorite,
//     required this.categoryId,
//     required this.status,
//     required this.viewsCount,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.category,
//     required this.market,
//     required this.images,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       nameAr: json['name_ar'],
//       nameEn: json['name_en'],
//       descriptionAr: json['description_ar'],
//       descriptionEn: json['description_en'],
//       price: json['price'],
//       priceOffer: json['price_offer'],
//       link: json['link'],
//       isFeatured: json['is_featured'],
//       isFavorite: json['is_favorite'],
//       categoryId: json['category_id'],
//       status: json['status'],
//       viewsCount: json['views_count'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//       category: CategoryInfo.fromJson(json['category']),
//       market: Market.fromJson(json['market']),
//       images: (json['images'] as List)
//           .map((img) => ProductImage.fromJson(img))
//           .toList(),
//     );
//   }
// }
class CategoryInfo {
  final int id;
  final String nameAr;
  final String nameEn;
  final String image;

  CategoryInfo({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.image,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      image: json['image'],
    );
  }
}

class Market {
  final int id;
  final String name;
  final String logo;

  Market({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
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
      id: json['id'],
      image: json['image'],
    );
  }
}

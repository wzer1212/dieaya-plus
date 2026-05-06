// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../../Utils/app_sharedprefs_contants.dart';
//
// class RemoveFavoriteController extends GetxController {
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;
//   var successMessage = ''.obs;
//
//   Future<bool> removeFavorite({
//     int? productId,
//     int? marketId,
//     int? marketOfferId,
//   }) async {
//     if (productId == null && marketId == null && marketOfferId == null) {
//       errorMessage.value = 'At least one ID (product, market, or offer) is required';
//       return false;
//     }
//
//     try {
//       final token = await SharedPrefsConstants.getToken();
//       isLoading(true);
//       final body = <String, dynamic>{};
//       if (productId != null) body['product_id'] = productId;
//       if (marketId != null) body['market_id'] = marketId;
//       if (marketOfferId != null) body['market_offer_id'] = marketOfferId;
//
//       final response = await http.post(
//         Uri.parse('https://dieaya-plus.com/api/customer/favorite/remove_favorite'),
//         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
//         body: json.encode(body),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['status'] == true) {
//           successMessage.value = jsonData['message'] ?? 'Favorite removed successfully';
//           errorMessage.value = '';
//           return true;
//         } else {
//           errorMessage.value = jsonData['message'] ?? 'Failed to remove favorite';
//           successMessage.value = '';
//           return false;
//         }
//       } else {
//         errorMessage.value = 'Server error: ${response.statusCode}';
//         successMessage.value = '';
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = 'Error: $e';
//       successMessage.value = '';
//       return false;
//     } finally {
//       isLoading(false);
//     }
//   }
// }
//
// class AddFavoriteController extends GetxController {
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;
//   var successMessage = ''.obs;
//
//   Future<bool> addFavorite({
//     int? productId,
//     int? marketId,
//     int? marketOfferId,
//   }) async {
//     if (productId == null && marketId == null && marketOfferId == null) {
//       errorMessage.value = 'At least one ID (product, market, or offer) is required';
//       return false;
//     }
//
//     try {
//       final token = await SharedPrefsConstants.getToken();
//       isLoading(true);
//       final body = <String, dynamic>{};
//       if (productId != null) body['product_id'] = productId;
//       if (marketId != null) body['market_id'] = marketId;
//       if (marketOfferId != null) body['market_offer_id'] = marketOfferId;
//
//       final response = await http.post(
//         Uri.parse('https://dieaya-plus.com/api/customer/favorite/add_favorite'),
//         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
//         body: json.encode(body),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['status'] == true) {
//           successMessage.value = jsonData['message'] ?? 'Favorite added successfully';
//           errorMessage.value = '';
//           return true;
//         } else {
//           errorMessage.value = jsonData['message'] ?? 'Failed to add favorite';
//           successMessage.value = '';
//           return false;
//         }
//       } else {
//         errorMessage.value = 'Server error: ${response.statusCode}';
//         successMessage.value = '';
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = 'Error: $e';
//       successMessage.value = '';
//       return false;
//     } finally {
//       isLoading(false);
//     }
//   }
// }
//
// class GetFavoritesController extends GetxController {
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;
//   final Rx<FavoritesResponse> favorites = FavoritesResponse(
//     status: false,
//     code: 0,
//     message: '',
//     data: FavoritesData(products: [], markets: [], offers: []),
//   ).obs;
//
//   Future<void> fetchFavorites() async {
//     isLoading.value = true;
//     errorMessage.value = '';
//
//     try {
//       final token = await SharedPrefsConstants.getToken();
//       final response = await http.get(
//         Uri.parse('https://dieaya-plus.com/api/customer/favorite/get_favorites'),
//         headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         favorites.value = FavoritesResponse.fromJson(jsonData);
//       } else {
//         errorMessage.value = 'Failed to fetch favorites: ${response.statusCode}';
//       }
//     } catch (e) {
//       errorMessage.value = 'Error fetching favorites: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
//
// class FavoritesResponse {
//   final bool status;
//   final int code;
//   final String message;
//   final FavoritesData data;
//
//   FavoritesResponse({
//     required this.status,
//     required this.code,
//     required this.message,
//     required this.data,
//   });
//
//   factory FavoritesResponse.fromJson(Map<String, dynamic> json) {
//     return FavoritesResponse(
//       status: json['status'] ?? false,
//       code: json['code'] ?? 0,
//       message: json['message'] ?? '',
//       data: FavoritesData.fromJson(json['data'] ?? {}),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'code': code,
//       'message': message,
//       'data': data.toJson(),
//     };
//   }
// }
//
// class FavoritesData {
//   final List<ProductFav> products;
//   final List<MarketFav> markets;
//   final List<FavoriteOffer> offers;
//
//   FavoritesData({
//     required this.products,
//     required this.markets,
//     required this.offers,
//   });
//
//   factory FavoritesData.fromJson(Map<String, dynamic> json) {
//     return FavoritesData(
//       products: (json['products'] as List<dynamic>?)
//           ?.map((item) => ProductFav.fromJson(item))
//           .toList() ??
//           [],
//       markets: (json['markets'] as List<dynamic>?)
//           ?.map((item) => MarketFav.fromJson(item))
//           .toList() ??
//           [],
//       offers: (json['offers'] as List<dynamic>?)
//           ?.map((item) => FavoriteOffer.fromJson(item))
//           .toList() ??
//           [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'products': products.map((item) => item.toJson()).toList(),
//       'markets': markets.map((item) => item.toJson()).toList(),
//       'offers': offers.map((item) => item.toJson()).toList(),
//     };
//   }
// }
//
// class ProductFav {
//   final int id;
//   final String nameAr;
//   final String nameEn;
//   final String descriptionAr;
//   final String descriptionEn;
//   final String price;
//   final String priceOffer;
//   final String link;
//   final bool isFeatured;
//   bool isFavorite;
//   final int categoryId;
//   final CategoryFav category;
//   final MarketFav market;
//   final List<ImageModel> images;
//
//   ProductFav({
//     required this.id,
//     required this.nameAr,
//     required this.nameEn,
//     required this.descriptionAr,
//     required this.descriptionEn,
//     required this.price,
//     required this.priceOffer,
//     required this.link,
//     required this.isFeatured,
//     this.isFavorite = false,
//     required this.categoryId,
//     required this.category,
//     required this.market,
//     required this.images,
//   });
//
//   factory ProductFav.fromJson(Map<String, dynamic> json) {
//     return ProductFav(
//       id: json['id'] ?? 0,
//       nameAr: json['name_ar'] ?? '',
//       nameEn: json['name_en'] ?? '',
//       descriptionAr: json['description_ar'] ?? '',
//       descriptionEn: json['description_en'] ?? '',
//       price: json['price']?.toString() ?? '',
//       priceOffer: json['price_offer']?.toString() ?? '',
//       link: json['link'] ?? '',
//       isFeatured: json['is_featured'] ?? false,
//       isFavorite: json['is_favorite'] ?? false,
//       categoryId: json['category_id'] ?? 0,
//       category: CategoryFav.fromJson(json['category'] ?? {}),
//       market: MarketFav.fromJson(json['market'] ?? {}),
//       images: (json['images'] as List<dynamic>?)
//           ?.map((item) => ImageModel.fromJson(item))
//           .toList() ??
//           [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name_ar': nameAr,
//       'name_en': nameEn,
//       'description_ar': descriptionAr,
//       'description_en': descriptionEn,
//       'price': price,
//       'price_offer': priceOffer,
//       'link': link,
//       'is_featured': isFeatured,
//       'is_favorite': isFavorite,
//       'category_id': categoryId,
//       'category': category.toJson(),
//       'market': market.toJson(),
//       'images': images.map((item) => item.toJson()).toList(),
//     };
//   }
// }
//
// class MarketFav {
//   final int id;
//   final String name;
//   final int? categoryId;
//   final String email;
//   final String phone;
//   final String logo;
//   final String? description;
//   final String link;
//   bool isFavorite;
//   final List<CategoryFav> categories;
//
//   MarketFav({
//     required this.id,
//     required this.name,
//     this.categoryId,
//     required this.email,
//     required this.phone,
//     required this.logo,
//     this.description,
//     required this.link,
//     this.isFavorite = false,
//     required this.categories,
//   });
//
//   factory MarketFav.fromJson(Map<String, dynamic> json) {
//     return MarketFav(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       categoryId: json['category_id'],
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       logo: json['logo'] ?? '',
//       description: json['description'],
//       link: json['link'] ?? '',
//       isFavorite: json['is_favorite'] ?? false,
//       categories: (json['categories'] as List<dynamic>?)
//           ?.map((item) => CategoryFav.fromJson(item))
//           .toList() ??
//           [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'category_id': categoryId,
//       'email': email,
//       'phone': phone,
//       'logo': logo,
//       'description': description,
//       'link': link,
//       'is_favorite': isFavorite,
//       'categories': categories.map((item) => item.toJson()).toList(),
//     };
//   }
// }
//
// class FavoriteOffer {
//   final int id;
//   final int marketId;
//   final MarketFav market;
//   final int categoryId;
//   final String descriptionAr;
//   final String descriptionEn;
//   final String image;
//   final String link;
//   bool isFavorite;
//
//   FavoriteOffer({
//     required this.id,
//     required this.marketId,
//     required this.market,
//     required this.categoryId,
//     required this.descriptionAr,
//     required this.descriptionEn,
//     required this.image,
//     required this.link,
//     this.isFavorite = false,
//   });
//
//   factory FavoriteOffer.fromJson(Map<String, dynamic> json) {
//     return FavoriteOffer(
//       id: json['id'] ?? 0,
//       marketId: json['market_id'] ?? 0,
//       market: MarketFav.fromJson(json['market'] ?? {}),
//       categoryId: json['category_id'] ?? 0,
//       descriptionAr: json['description_ar'] ?? '',
//       descriptionEn: json['description_en'] ?? '',
//       image: json['image'] ?? '',
//       link: json['link'] ?? '',
//       isFavorite: json['is_favorite'] ?? false,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'market_id': marketId,
//       'market': market.toJson(),
//       'category_id': categoryId,
//       'description_ar': descriptionAr,
//       'description_en': descriptionEn,
//       'image': image,
//       'link': link,
//       'is_favorite': isFavorite,
//     };
//   }
// }
//
// class CategoryFav {
//   final int id;
//   final String nameAr;
//   final String nameEn;
//   final String image;
//   final int? sort;
//
//   CategoryFav({
//     required this.id,
//     required this.nameAr,
//     required this.nameEn,
//     required this.image,
//     this.sort,
//   });
//
//   factory CategoryFav.fromJson(Map<String, dynamic> json) {
//     return CategoryFav(
//       id: json['id'] ?? 0,
//       nameAr: json['name_ar'] ?? '',
//       nameEn: json['name_en'] ?? '',
//       image: json['image'] ?? '',
//       sort: json['sort'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name_ar': nameAr,
//       'name_en': nameEn,
//       'image': image,
//       'sort': sort,
//     };
//   }
// }
//
// class ImageModel {
//   final int id;
//   final String image;
//
//   ImageModel({
//     required this.id,
//     required this.image,
//   });
//
//   factory ImageModel.fromJson(Map<String, dynamic> json) {
//     return ImageModel(
//       id: json['id'] ?? 0,
//       image: json['image'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'image': image,
//     };
//   }
// }




// models/favorite_models.dart
// controllers/favorite_controller.dart

import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Utils/app_sharedprefs_contants.dart';
import '../../models/product_model.dart';

class FavoriteController extends GetxController {
  final Rx<FavoriteData?> favorites = Rx<FavoriteData?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isGrid = true.obs;
  final RxString errorMessage = ''.obs;

  void initState() {

    getFavorites(); // Fetch favorites on initialization
  }
  // Helper method to get headers with token
  Future<Map<String, String>> _getHeaders() async {
    final token = await SharedPrefsConstants.getToken();
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Add to favorites
  Future<void> addFavorite({
    int? marketId,
    int? productId,
    int? marketOfferId,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = Uri.parse(ApiConstants.addFav);

      final response = await HttpService.instance.post(
        url,
        body: {
          if (marketId != null) 'market_id': marketId.toString(),
          if (productId != null) 'product_id': productId.toString(),
          if (marketOfferId != null) 'market_offer_id': marketOfferId.toString(),
        },
        headers: await _getHeaders(),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        // Get.snackbar('Success', responseData['message']);
        await getFavorites();
      } else {
        errorMessage.value = responseData['message'] ?? 'Failed to add favorite';
        // Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      // Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Remove from favorites
  Future<void> removeFavorite({
    int? marketId,
    int? productId,
    int? marketOfferId,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = Uri.parse(ApiConstants.removeFav);

      final response = await HttpService.instance.post(
        url,
        body: {
          if (marketId != null) 'market_id': marketId.toString(),
          if (productId != null) 'product_id': productId.toString(),
          if (marketOfferId != null) 'market_offer_id': marketOfferId.toString(),
        },
        headers: await _getHeaders(),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        // Get.snackbar('Success', responseData['message']);
        await getFavorites();
      } else {
        errorMessage.value = responseData['message'] ?? 'Failed to remove favorite';
        // Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      // Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Get all favorites
  Future<void> getFavorites() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = Uri.parse(ApiConstants.getFav);

      final response = await HttpService.instance.get(
        url,
        headers: await _getHeaders(),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        favorites.value = FavoriteData.fromJson(responseData['data']);
      } else {
        errorMessage.value = responseData['message'] ?? 'Failed to load favorites';
        // Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      // Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Check if an item is favorite
  bool isFavorite({
    int? marketId,
    int? productId,
    int? marketOfferId,
  }) {
    if (favorites.value == null) return false;

    if (productId != null) {
      return favorites.value!.products.any((product) => product.id == productId);
    } else if (marketId != null) {
      return favorites.value!.markets.any((market) => market.id == marketId);
    } else if (marketOfferId != null) {
      return favorites.value!.offers.any((offer) => offer.id == marketOfferId);
    }

    return false;
  }

  // Toggle favorite status
  Future<void> toggleFavorite({
    int? marketId,
    int? productId,
    int? marketOfferId,
  }) async {
    final currentlyFavorite = isFavorite(
      marketId: marketId,
      productId: productId,
      marketOfferId: marketOfferId,
    );

    if (currentlyFavorite) {
      await removeFavorite(
        marketId: marketId,
        productId: productId,
        marketOfferId: marketOfferId,
      );
    } else {
      await addFavorite(
        marketId: marketId,
        productId: productId,
        marketOfferId: marketOfferId,
      );
    }
  }
}

class FavoriteResponse {
  final bool status;
  final int code;
  final String message;
  final FavoriteData data;

  FavoriteResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteResponse(
      status: json['status'] is bool ? json['status'] as bool : false,
      code: json['code'] is int ? json['code'] as int : 0,
      message: json['message'] is String ? json['message'] as String : '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? FavoriteData.fromJson(json['data'] as Map<String, dynamic>)
          : FavoriteData(products: [], markets: [], offers: []),
    );
  }
}

class FavoriteData {
  final List<Product> products;
  final List<MarketFav> markets;
  final List<MarketOfferFav> offers;

  FavoriteData({
    required this.products,
    required this.markets,
    required this.offers,
  });

  factory FavoriteData.fromJson(Map<String, dynamic> json) {
    return FavoriteData(
      products: json['products'] is List
          ? List<Product>.from(
        (json['products'] as List<dynamic>)
            .map((x) => Product.fromJson(x is Map<String, dynamic> ? x : {})),
      )
          : [],
      markets: json['markets'] is List
          ? List<MarketFav>.from(
        (json['markets'] as List<dynamic>)
            .map((x) => MarketFav.fromJson(x is Map<String, dynamic> ? x : {})),
      )
          : [],
      offers: json['offers'] is List
          ? List<MarketOfferFav>.from(
        (json['offers'] as List<dynamic>)
            .map((x) => MarketOfferFav.fromJson(x is Map<String, dynamic> ? x : {})),
      )
          : [],
    );
  }
}

class ProductFav {
  final int id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String price;
  final String priceOffer;
  final String link;
  final bool isFeatured;
  final bool isFavorite;
  final int categoryId;
  final String createdAt;
  final String updatedAt;
  final CategoryFav category;
  final MarketFav market;
  final List<ProductImageFav> images;
  final List<InstallmentWay> installmentWays;

  ProductFav({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    required this.priceOffer,
    required this.link,
    required this.isFeatured,
    required this.isFavorite,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.market,
    required this.images,
    required this.installmentWays,

  });

  factory ProductFav.fromJson(Map<String, dynamic> json) {
    return ProductFav(
      id: json['id'] is int ? json['id'] as int : 0,
      nameAr: json['name_ar'] is String ? json['name_ar'] as String : '',
      nameEn: json['name_en'] is String ? json['name_en'] as String : '',
      descriptionAr: json['description_ar'] is String ? json['description_ar'] as String : '',
      descriptionEn: json['description_en'] is String ? json['description_en'] as String : '',
      price: json['price'] is String
          ? json['price'] as String
          : json['price'] is num
          ? (json['price'] as num).toString()
          : '0',
      priceOffer: json['price_offer'] is String
          ? json['price_offer'] as String
          : json['price_offer'] is num
          ? (json['price_offer'] as num).toString()
          : '',
      link: json['link'] is String ? json['link'] as String : '',
      isFeatured: json['is_featured'] is bool ? json['is_featured'] as bool : false,
      isFavorite: json['is_favorite'] is bool ? json['is_favorite'] as bool : false,
      categoryId: json['category_id'] is int ? json['category_id'] as int : 0,
      createdAt: json['created_at'] is String ? json['created_at'] as String : '',
      updatedAt: json['updated_at'] is String ? json['updated_at'] as String : '',
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? CategoryFav.fromJson(json['category'] as Map<String, dynamic>)
          : CategoryFav(id: 0, nameAr: '', nameEn: '', image: ''),
      market: json['market'] != null && json['market'] is Map<String, dynamic>
          ? MarketFav.fromJson(json['market'] as Map<String, dynamic>)
          : MarketFav(
        id: 0,
        name: '',
        email: '',
        phone: '',
        logo: '',
        link: '',
        isFavorite: false,
        createdAt: '',
        updatedAt: '',
        categories: [],
      ),
      images: json['images'] is List
          ? List<ProductImageFav>.from(
        (json['images'] as List<dynamic>)
            .map((x) => ProductImageFav.fromJson(x is Map<String, dynamic> ? x : {})),
      )
          : [],
      installmentWays: (json['installment_ways'] as List<dynamic>?)
          ?.map((item) => InstallmentWay.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class MarketFav {
  final int id;
  final String name;
  final int? categoryId;
  final String email;
  final String phone;
  final String logo;
  final String? description;
  final String link;
  final bool isFavorite;
  final String createdAt;
  final String updatedAt;
  final List<CategoryFav> categories;

  MarketFav({
    required this.id,
    required this.name,
    this.categoryId,
    required this.email,
    required this.phone,
    required this.logo,
    this.description,
    required this.link,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    required this.categories,
  });

  factory MarketFav.fromJson(Map<String, dynamic> json) {
    return MarketFav(
      id: json['id'] is int ? json['id'] as int : 0,
      name: json['name'] is String ? json['name'] as String : '',
      categoryId: json['category_id'] is int ? json['category_id'] as int : null,
      email: json['email'] is String ? json['email'] as String : '',
      phone: json['phone'] is String ? json['phone'] as String : '',
      logo: json['logo'] is String ? json['logo'] as String : '',
      description: json['description'] is String ? json['description'] as String : null,
      link: json['link'] is String ? json['link'] as String : '',
      isFavorite: json['is_favorite'] is bool ? json['is_favorite'] as bool : false,
      createdAt: json['created_at'] is String ? json['created_at'] as String : '',
      updatedAt: json['updated_at'] is String ? json['updated_at'] as String : '',
      categories: json['categories'] is List
          ? List<CategoryFav>.from(
        (json['categories'] as List<dynamic>)
            .map((x) => CategoryFav.fromJson(x is Map<String, dynamic> ? x : {})),
      )
          : [],
    );
  }
}

class MarketOfferFav {
  final int id;
  final int marketId;
  final MarketFav market;
  final int categoryId;
  final String descriptionAr;
  final String descriptionEn;
  final String? titleAr;
  final String? titleEn;
  final String? couponCode;
  final String image;
  final String link;
  final String createdAt;
  final String updatedAt;
  final bool isFavorite;

  MarketOfferFav({
    required this.id,
    required this.marketId,
    required this.market,
    required this.categoryId,
    required this.descriptionAr,
    required this.descriptionEn,
    this.titleAr,
    this.titleEn,
    this.couponCode,
    required this.image,
    required this.link,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
  });

  factory MarketOfferFav.fromJson(Map<String, dynamic> json) {
    return MarketOfferFav(
      id: json['id'] is int ? json['id'] as int : 0,
      marketId: json['market_id'] is int ? json['market_id'] as int : 0,
      market: json['market'] != null && json['market'] is Map<String, dynamic>
          ? MarketFav.fromJson(json['market'] as Map<String, dynamic>)
          : MarketFav(
        id: 0,
        name: '',
        email: '',
        phone: '',
        logo: '',
        link: '',
        isFavorite: false,
        createdAt: '',
        updatedAt: '',
        categories: [],
      ),
      categoryId: json['category_id'] is int ? json['category_id'] as int : 0,
      descriptionAr: json['description_ar'] is String ? json['description_ar'] as String : '',
      descriptionEn: json['description_en'] is String ? json['description_en'] as String : '',
      titleAr: json['title_ar'] is String ? json['title_ar'] as String : null,
      titleEn: json['title_en'] is String ? json['title_en'] as String : null,
      couponCode: json['coupon_code'] is String ? json['coupon_code'] as String : null,
      image: json['image'] is String ? json['image'] as String : '',
      link: json['link'] is String ? json['link'] as String : '',
      createdAt: json['created_at'] is String ? json['created_at'] as String : '',
      updatedAt: json['updated_at'] is String ? json['updated_at'] as String : '',
      isFavorite: json['is_favorite'] is bool ? json['is_favorite'] as bool : false,
    );
  }
}

class CategoryFav {
  final int id;
  final String nameAr;
  final String nameEn;
  final String image;
  final int? sort;

  CategoryFav({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.image,
    this.sort,
  });

  factory CategoryFav.fromJson(Map<String, dynamic> json) {
    return CategoryFav(
      id: json['id'] is int ? json['id'] as int : 0,
      nameAr: json['name_ar'] is String ? json['name_ar'] as String : '',
      nameEn: json['name_en'] is String ? json['name_en'] as String : '',
      image: json['image'] is String ? json['image'] as String : '',
      sort: json['sort'] is int ? json['sort'] as int : null,
    );
  }
}

class ProductImageFav {
  final int id;
  final String image;

  ProductImageFav({
    required this.id,
    required this.image,
  });

  factory ProductImageFav.fromJson(Map<String, dynamic> json) {
    return ProductImageFav(
      id: json['id'] is int ? json['id'] as int : 0,
      image: json['image'] is String ? json['image'] as String : '',
    );
  }
}
import 'dart:async';

import 'package:dieaya_user/models/best_market_model.dart';
import 'package:dieaya_user/models/product_model.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final int id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String price;
  final String priceOffer;
  final DateTime? createdAt;
  final String link;
  final String shareLink;
  final bool isFeatured;
  bool isFavorite;
  final int categoryId;
  final CategoryProduct category;
  final MarketProduct market;
  final List<ProductImage> images;
  final List<InstallmentWay> installmentWays;

  Product({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    required this.priceOffer,
    this.createdAt,
    required this.link,
    required this.shareLink,
    required this.isFeatured,
    this.isFavorite = false,
    required this.categoryId,
    required this.category,
    required this.market,
    required this.images,
    required this.installmentWays,
  });

  /// ✅ Default empty object
  static empty() {
    return Product(
      id: 0,
      nameAr: 'none',
      nameEn: 'none',
      descriptionAr: 'the product not found',
      descriptionEn: 'the product not found',
      price: '0',
      priceOffer: '',
      createdAt: null,
      link: '',
      shareLink: 'none',
      isFeatured: false,
      isFavorite: false,
      categoryId: 0,
      category: CategoryProduct.empty(),
      market: MarketProduct.empty(),
      images: [],
      installmentWays: [],
    );
  }
  factory Product.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        // Assuming date format is DD-MM-YYYY
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
    print('===========================');
    print('===                      ==');
    print('===                      ==');
    print('===                      ==');
    print('===                      ==');
    print('===========================');

    print(json['price_offer']!=null? (double.parse(json['price_offer'])).toStringAsFixed(2): '');
    print(json['price']!=null? (double.parse(json['price'])).toStringAsFixed(2): '');
    return Product(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      // price: json['price'] ?? '',
      price:json['price']!=null? (double.parse(json['price'])).toStringAsFixed(2): '',
      priceOffer:json['price_offer']!=null? (double.parse(json['price_offer'])).toStringAsFixed(2): '',
      createdAt: parseDate(json['created_at'] as String?),
      link: json['link'] ?? '',
      shareLink: json['share_link'] ?? '',
      isFeatured: json['is_featured'] ?? false,
      isFavorite: json['is_favorite'] ?? false,
      categoryId: json['category_id'] ?? 0,
      category: CategoryProduct.fromJson(json['category'] ?? {}),
      market: MarketProduct.fromJson(json['market'] ?? {}),
      images: (json['images'] as List<dynamic>?)
              ?.map((item) => ProductImage.fromJson(item))
              .toList() ??
          [],
      installmentWays: (json['installment_ways'] as List<dynamic>?)
              ?.map((item) =>
                  InstallmentWay.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    String? formatDate(DateTime? date) {
      if (date == null) return null;
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    }

    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'price': price,
      'price_offer': priceOffer,
      'created_at': formatDate(createdAt),
      'link': link,
      'is_featured': isFeatured,
      'is_favorite': isFavorite,
      'category_id': categoryId,
      'category': category.toJson(),
      'market': market.toJson(),
      'images': images.map((image) => image.toJson()).toList(),
      'installment_ways': installmentWays,
    };
  }
}

class ProductsInfo {
  final List<Product> products;
  final int? currentPage;
  final int? lastPage;
  final int? countPerPage;
  final int? totalProductsPerPages;

  ProductsInfo(
    this.products,
    this.currentPage,
    this.lastPage,
    this.countPerPage,
    this.totalProductsPerPages,
  );

  factory ProductsInfo.fromJson(Map<String, dynamic> json) => ProductsInfo(
        (json['products'] as List)
            .map(
              (e) => Product.fromJson(e),
            )
            .toList(),
        json['pagination']['current_page'],
        json['pagination']['last_page'],
        json['pagination']['per_page'],
        json['pagination']['total'],
      );
}

class CategoryMarketProduct {
  final int id;
  final String nameAr;
  final String nameEn;
  final String image;
  final int sort;
  final String createdAt;
  final String? updatedAt;

  CategoryMarketProduct({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.image,
    required this.sort,
    required this.createdAt,
    this.updatedAt,
  });

  factory CategoryMarketProduct.fromJson(Map<String, dynamic> json) {
    return CategoryMarketProduct(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      image: json['image'] ?? '',
      sort: json['sort'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'image': image,
      'sort': sort,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class CategoryDetailsController extends GetxController {
  var category = Rxn<CategoryMarketProduct>();
  var products = <Product>[].obs;
  var markets = <Market>[].obs;
  var productsPagination =
      Pagination(currentPage: 1, lastPage: 1, perPage: 15, total: 0).obs;
  var marketsPagination =
      Pagination(currentPage: 1, lastPage: 1, perPage: 15, total: 0).obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs; // Track the current search query
  String selectedCategoryId = '1'; // Default to 'all' (id: 1 from API)
  Timer? _debounceTimer; // Timer for debouncing search

  @override
  void onInit() {
    // fetchCategoryDetails(categoryId: int.parse(selectedCategoryId));
    super.onInit();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel(); // Cancel the timer when the controller is closed
    super.onClose();
  }

  Future<void> fetchCategoryDetails(
      {required int categoryId,
      int productsPerPage = 15,
      int marketsPerPage = 15,
      int productsPage = 1,
      int marketsPage = 1,
      int page = 1,
      String? keyword,
      bool? isFromPaginationUi = false}) async {
    try {
      if (!isFromPaginationUi!) {
        isLoading(true);
        errorMessage('');
      }
      print(ApiConstants.marketCategoryDetails);
      // Build the URL with optional keyword
      String url = '${ApiConstants.marketCategoryDetails}'
          '?category_id=$categoryId'
          '&products_per_page=$productsPerPage'
          '&markets_per_page=$marketsPerPage'
          '&products_page=$productsPage'
          '&page=$page'
          '&markets_page=$marketsPage';
      if (keyword != null && keyword.isNotEmpty) {
        products.clear();
        url += '&keyword=$keyword';
      }

      final response = await HttpService.instance.get(
        Uri.parse(url),
      );
      print(url);
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          final categoryData = jsonData['data']['category'];
          category.value = CategoryMarketProduct.fromJson(categoryData);
          products.value.addAll(
              (categoryData['products']['data'] as List<dynamic>?)
                      ?.map((json) => Product.fromJson(json))
                      .toList() ??
                  []);

          print('==========================>>>>>>>>>>>> products length ${products.length}');

          markets.value = (categoryData['markets']['data'] as List<dynamic>?)
                  ?.map((json) => Market.fromJson(json))
                  .toList() ??
              [];
          productsPagination.value =
              Pagination.fromJson(categoryData['products']['pagination'] ?? {});
          marketsPagination.value =
              Pagination.fromJson(categoryData['markets']['pagination'] ?? {});
        } else {
          errorMessage.value =
              jsonData['message'] ?? 'Failed to load category data';
        }
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      print('================================================================');
      print('================================================================');
      print('================================================================');
      print('================================================================');

      if(e is TypeError)
        {
          print(e.stackTrace);
        }
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }

  // Method to handle real-time search with debouncing
  void searchCategoryDetails(String keyword) {
    // Cancel any existing debounce timer
    _debounceTimer?.cancel();

    searchQuery.value = keyword.trim();

    // Start a new timer to debounce the search
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (keyword.isNotEmpty) {
        fetchCategoryDetails(
          categoryId: int.parse(selectedCategoryId),
          keyword: keyword,
        );
      } else {
        fetchCategoryDetails(
            categoryId:
                int.parse(selectedCategoryId)); // Fetch all if keyword is empty
      }
    });
  }

  // Method to clear search
  void clearSearch() {
    _debounceTimer?.cancel();
    searchQuery.value = '';
    fetchCategoryDetails(categoryId: int.parse(selectedCategoryId));
  }
}

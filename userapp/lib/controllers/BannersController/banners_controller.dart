import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Banner {
  final int id;
  final String? titleAr;
  final String? titleEn;
  final String link;
  final String image;
  final String? descriptionEn;
  final String? descriptionAr;

  Banner({
    required this.id,
    this.titleAr,
    this.titleEn,
    required this.link,
    required this.image,
    this.descriptionEn,
    this.descriptionAr,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'] ?? 0,
      titleAr: json['title_ar'],
      titleEn: json['title_en'],
      link: json['link'] ?? '',
      image: json['image'] ?? '',
      descriptionEn: json['description_en'],
      descriptionAr: json['description_ar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_ar': titleAr,
      'title_en': titleEn,
      'link': link,
      'image': image,
      'description_en': descriptionEn,
      'description_ar': descriptionAr,
    };
  }
}

class BannersController extends GetxController {
  var banners = <Banner>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }
  Future<void> fetchBanners() async {
    try {
      isLoading(true);
      final response = await HttpService.instance.get(
        Uri.parse(ApiConstants.getBanners),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          banners.value = (jsonData['data']['banners'] as List<dynamic>?)
              ?.map((json) => Banner.fromJson(json))
              .toList() ??
              [];
        } else {
          errorMessage.value = jsonData['message'] ?? 'Failed to load banners';
        }
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }
}
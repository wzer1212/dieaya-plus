class BannerResponse {
  final bool status;
  final String code;
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
      status: json['status'],
      code: json['code'].toString(),
      message: json['message'],
      data: BannerData.fromJson(json['data']),
    );
  }
}

class BannerData {
  final List<Banner> banners;

  BannerData({required this.banners});

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      banners: (json['banners'] as List)
          .map((x) => Banner.fromJson(x))
          .toList(),
    );
  }
}

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
      id: json['id'],
      titleAr: json['title_ar'],
      titleEn: json['title_en'],
      link: json['link'],
      image: json['image'],
      descriptionEn: json['description_en'],
      descriptionAr: json['description_ar'],
    );
  }
}